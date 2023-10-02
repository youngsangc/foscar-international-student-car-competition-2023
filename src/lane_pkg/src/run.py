#!/usr/bin/python3
#-*- encoding: utf-8 -*-
import os.path as ops
import numpy as np
import torch
import cv2
import time
import math
import os
import matplotlib.pylab as plt
import sys
from tqdm import tqdm
import imageio
from dataset.dataset_utils import TUSIMPLE
from Lanenet.model2 import Lanenet
from utils.evaluation import gray_to_rgb_emb, process_instance_embedding
import rospy
from cv_bridge import CvBridge
from sensor_msgs.msg import Image
from race.msg import drive_values

drive_values_pub= rospy.Publisher('control_value', drive_values, queue_size = 1)


bridge = CvBridge()
img = np.empty(shape=[0])
rospy.init_node("lane")

# torch.backends.cudnn.enabled = False

device = 'cuda' if torch.cuda.is_available() else 'cpu'
# device = 'cuda'

def image_callback(img_data):
	global bridge
	global img
	img = bridge.imgmsg_to_cv2(img_data, "rgb8")

# Load the Model
model_path = './TUSIMPLE/Lanenet_output/lanenet_epoch_250_batch_8.model' #내동영상으로 바꿔준다
LaneNet_model = Lanenet(2, 4)
LaneNet_model.load_state_dict(torch.load(model_path, map_location=torch.device(device)))
LaneNet_model.to(device)

motor_info = drive_values()

def inference(gt_img_org):
    global motor_info
    # BGR 순서
    org_shape = gt_img_org.shape
    gt_image = cv2.resize(gt_img_org, dsize=(512, 256), interpolation=cv2.INTER_LINEAR)
    gt_image = gt_image / 127.5 - 1.0
    gt_image = torch.tensor(gt_image, dtype=torch.float)
    gt_image = np.transpose(gt_image, (2, 0, 1))
    gt_image = gt_image.to(device)
    # lane segmentation 
    binary_final_logits, instance_embedding = LaneNet_model(gt_image.unsqueeze(0))
    binary_final_logits, instance_embedding = binary_final_logits.to('cpu'), instance_embedding.to('cpu') 
    binary_img = torch.argmax(binary_final_logits, dim=1).squeeze().numpy()
    binary_img[0:80,:] = 0 #(0~85행)을 무시 - 불필요한 영역 제거

    # 차선 클러스터링, 색상 지정
    rbg_emb, cluster_result = process_instance_embedding(instance_embedding, binary_img,distance=1.5, lane_num=2)
    rbg_emb = cv2.resize(rbg_emb, dsize=(org_shape[1], org_shape[0]), interpolation=cv2.INTER_LINEAR)
    a = 0.6
    frame = a * gt_img_org[..., ::-1] / 255 + rbg_emb * (1 - a)
    frame = np.rint(frame * 255)
    frame = frame.astype(np.uint8)

    y, x = get_lane_center(binary_img)
    
    motor_info.steering = (math.atan2(y,x)*(180/3.14)-90) * 0.5
    print("1stmotor_info.steering: ",motor_info.steering)
   
        
    motor_info.throttle = 7
    drive_values_pub.publish(motor_info)



    return frame

def get_lane_center(binary_img):
    global motor_info
    binary_img = binary_img[binary_img.shape[0]//2:]

    # Calculate the histogram of the bottom half
    histogram = np.sum(binary_img, axis=0)

    # Find peaks of left and right halves
    midpoint = np.int(histogram.shape[0]//2)
    leftx_base = np.argmax(histogram[:midpoint])
    rightx_base = np.argmax(histogram[midpoint:]) + midpoint

    # Calculate lane center
    lanex_center = (leftx_base + rightx_base) / 2
    

    # Assuming the car is placed in the center of the image
    car_center = binary_img.shape[1] // 2
    # if abs(leftx_base-car_center) <=50:
    #      motor_info.steering = 8
    # if abs(rightx_base-car_center) <=50:
    #      motor_info.steering = -8
         

    # Calculate longitudinal and lateral distances
    longitudinal_distance = binary_img.shape[0]
    lateral_distance = lanex_center - car_center
    
    #print(f"Longitudinal distance: {longitudinal_distance}, Lateral distance: {lateral_distance}")
    return longitudinal_distance, lateral_distance


# 이 코드는 각 차선의 히스토그램을 계산한 후, 이 히스토그램의 최대값(즉, 차선의 중심)을 찾아 차선의 중간 좌표를 계산합니다.




if __name__ == "__main__":
    image_sub = rospy.Subscriber("/usb_cam/image_raw/", Image, image_callback)
    while not rospy.is_shutdown():
        try:
            show_img = inference(img)
            cv2.imshow("lane_image", show_img)
            cv2.waitKey(1)

            height, width = img.shape[:2]
            half_height = height // 2
            cropped_img = img[half_height:height, :]
            height, width = img.shape[:2]
            left = 100
            right = width - 100
            cropped_img = cropped_img[:, left:right]
            crop_img = inference(cropped_img)

            cv2.imshow("crop_image", crop_img)
            cv2.waitKey(1)

        except:
            pass
        
        rospy.sleep(0.05)