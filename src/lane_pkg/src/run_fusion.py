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
from driving_es import *

drive_values_pub= rospy.Publisher('control_value', drive_values, queue_size = 1)


bridge = CvBridge()
image = np.empty(shape=[0])

# rospy.init_node("lane")

# torch.backends.cudnn.enabled = False

device = 'cuda' if torch.cuda.is_available() else 'cpu'
# device = 'cuda'

def image_callback(img_data):
	global bridge
	global image
	image = bridge.imgmsg_to_cv2(img_data, "rgb8")

# Load the Model
model_path = './TUSIMPLE/Lanenet_output/lanenet_epoch_250_batch_8.model' #내동영상으로 바꿔준다
LaneNet_model = Lanenet(2, 4)
LaneNet_model.load_state_dict(torch.load(model_path, map_location=torch.device(device)))
LaneNet_model.to(device)


def inference(gt_img_org):
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
    binary_img[0:85,:] = 0 #(0~85행)을 무시 - 불필요한 영역 제거

    # 차선 클러스터링, 색상 지정
    rbg_emb, cluster_result = process_instance_embedding(instance_embedding, binary_img,distance=1.5, lane_num=1)
    rbg_emb = cv2.resize(rbg_emb, dsize=(org_shape[1], org_shape[0]), interpolation=cv2.INTER_LINEAR)
    a = 0.1
    frame = a * gt_img_org[..., ::-1] / 255 + rbg_emb * (1 - a)
    frame = np.rint(frame * 255)
    frame = frame.astype(np.uint8)

    motor_info = drive_values()


    return frame



if __name__ == "__main__":
    image_sub = rospy.Subscriber("/usb_cam/image_raw/", Image, image_callback)
    

    lx,ly,rx,ry = [200,] , [] , [428,] , []  #sliding_Window 함수 내에서 x_temp , y_temp 매개변수에 lx[0]과 rx[0]을 할당해주어야 하기에 초기화 합니다. 
    
    left_lane_inds , right_lane_inds = [], [] #left_lane_inds 와 right_lane_inds 리스트 또한 left_prob와 right_prob를 계산하는데에 사용해야하기에 초기화해줍니다.
 
    rospy.init_node('lane')
    # motor = rospy.Publisher('xycar_motor', xycar_motor, queue_size=1)
    image_sub = rospy.Subscriber("/usb_cam/image_raw/",Image,img_callback)

    # print ("----- Xycar self driving -----")
    left_prob,right_prob = 0,0 #left_prob와 right_prob또한 slidingwindow 함수의 매개변수로 사용해야하기에 초기화합니다.

    while not rospy.is_shutdown():

        show_img = inference(image)
        init_show_img(show_img)
        cv2.imshow("lane_image", show_img)
        cv2.waitKey(1)
        img_frame = show_img.copy() # img_frame변수에 카메라 이미지를 받아옵니다.   
        height,width,channel = img_frame.shape # 이미지의 높이,너비,채널값을 변수에 할당합니다. 
        img_roi = img_frame[280:,0:]   # y좌표 0~320 사이에는 차선과 관련없는 이미지들이 존재하기에 노이즈를 줄이기 위하여 roi설정을 해주었습니다.
        img_filtered = color_filter(img_roi)   #roi가 설정된 이미지를 color_filtering 하여 흰색 픽셀만을 추출해냅니다. 
        

        img_warped = bird_eye_view(img_filtered,width,height) # 앞서 구현한 bird-eye-view 함수를 이용하여 시점변환해줍니다. 
    
    
        _, L, _ = cv2.split(cv2.cvtColor(img_warped, cv2.COLOR_BGR2HLS))
        _, img_binary = cv2.threshold(L, 0, 255, cv2.THRESH_BINARY) #color_filtering 된 이미지를 한번 더 이진화 하여 차선 검출의 신뢰도를 높였습니다. 

        img_masked = region_of_interest(img_binary) #이진화까지 마친 이미지에 roi를 다시 설정하여줍니다.
    
        out_img,lx,ly,rx,ry,left_lane_inds,right_lane_inds = sliding_window(img_masked,lx[0],rx[0],left_prob,right_prob) #sliding window함수에서 return받을 수 있는 값들을 모두 할당해줍니다. 
    
        img_blended = cv2.addWeighted(out_img, 1, img_warped, 0.6, 0) # sliding window결과를 시각화하기 위하여 out_img와 시점변환된이미지를 merging 하였습니다. 

        R= Radius(lx,ly)
    
        angle = steering_Angle(R) *13  # 앞서 구현한 곡률반경 함수와 steering Angle값 계산함수를 이용하여 R과 angle변수를 초기화합니다. default로 좌측차선을 인식하여 주행합니다. 
    
    
        left_prob = np.mean(np.count_nonzero(left_lane_inds))
        right_prob = np.mean(np.count_nonzero(right_lane_inds)) #left_prob와 right_prob에 좌,우측차선의 모든 window 내의 0이 아닌 픽셀의 갯수를 평균 계산하여 좌,우측 차선의 신뢰도로 활용합니다. 
    
    
        if(right_prob>left_prob or rx[-1] - rx[3] <0 ):	#좌회전을 실시하는 경우 우측차선만 검출될 확률이 높기에 우측차선의 신뢰도가 좌측차선보다 높거나 우측차선의 맨 끝 window의 x좌표가 4번째 window의 x좌표보다 작을 경우 좌회전을 하도록 하였습니다.
            R = Radius(rx,ry)
            angle = steering_Angle(R)*-7  
            if(rx[3 ]>435):
                angle*=0.7
            
    
        if (abs(angle)<=5 and lx[3]<170): #차량이 너무 우측차선에 쏠려있는 경우 차량의 중앙으로 정렬할 수 있게끔 방어코드를 작성하였습니다.
        
            angle=steering_Angle(R)*-7
    
            
    
        
        cv2.imshow("CAM View", img_blended)
        cv2.waitKey(1)     
        speed_ctrl = abs(angle)
        
        if(speed_ctrl==0):
            speed_ctrl=1
    
    
        speed = 400/speed_ctrl
        if speed>35:
            speed=10
        elif speed<25:
            speed = 10 # 속도를 선형제어 하기 위하여 angle값을 speed_ctrl 변수에 받아온 후 비율을 정하여 speed값을 산출해내었고, 최대, 최소 speed값을 지정하였습니다.

        if(right_prob<100 and left_prob<100):
            speed = 10
            angle = previous_angle   #좌,우측 차선의 신뢰도가 모두 낮을 경우 감속하고 이전 조향각을 그대로 유지하도록 하였습니다. 
        
        previous_angle = angle
        
        #drive(angle, speed)
        
        # height, width = img.shape[:2]
        # half_height = height // 2
        # cropped_img = img[half_height:height, :]
        # height, width = img.shape[:2]
        # left = 100
        # right = width - 100
        # cropped_img = cropped_img[:, left:right]
        # crop_img = inference(cropped_img)
        # cv2.imshow("crop_image", crop_img)
        # cv2.waitKey(1)
        # except:
        #     pass
        
        rospy.sleep(0.05)