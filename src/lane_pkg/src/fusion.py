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
from ransac_1d import RANSAC
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

# Load the Model
model_path = './TUSIMPLE/Lanenet_output/lanenet_epoch_39_batch_8.model' #내동영상으로 바꿔준다
LaneNet_model = Lanenet(2, 4)
LaneNet_model.load_state_dict(torch.load(model_path, map_location=torch.device(device)))
LaneNet_model.to(device)

def imageCallback(msg):
    global BEV_H,BEV_W, BEV_TOP_PADDING, M, revM

    print("CALLBACK")
    bridge = CvBridge()
    img = bridge.imgmsg_to_cv2(msg, "rgb8")

    # img = cv2.resize(img, dsize=(640, 480), interpolation=cv2.INTER_AREA)
    img = cv2.resize(img, dsize=(640, 480))
    img = cv2.cvtColor(img,cv2.COLOR_RGB2BGR)
    #cv2.imshow("raw_img",img)   

    # croped_img = img[BEV_TOP_PADDING:(BEV_TOP_PADDING+BEV_H), 0:BEV_W] # Apply np slicing for ROI crop
    croped_img = img[BEV_TOP_PADDING:(BEV_TOP_PADDING+BEV_H), 0:BEV_W] # Apply np slicing for ROI crop
    BEV_img = getBEV(croped_img) # Get BEV Image

    # 12 
    # 43 (x,y)
    l_vertices = np.array(
                        [
                            [   
                                (CROP_WIDTH_PADDING,0),
                                (BEV_W/2,0), 
                                (BEV_W/2,BEV_H), 
                                (CROP_WIDTH_PADDING + 50,BEV_H)
                            ]
                        ], 
                        dtype=np.int32)
    r_vertices = np.array(
                        [
                            [   
                                (BEV_W/2,0),
                                (BEV_W-CROP_WIDTH_PADDING,0), 
                                (BEV_W-CROP_WIDTH_PADDING - 50,BEV_H), 
                                (BEV_W/2,BEV_H)
                            ]
                        ], 
                        dtype=np.int32)

    
    l_ROI_img = filter_line(region_of_interest(BEV_img, l_vertices))
    #cv2.imshow("l_image",l_ROI_img)

    gray_img = cv2.cvtColor(l_ROI_img, cv2.COLOR_BGR2GRAY)
    blur_img = cv2.GaussianBlur(gray_img, (3, 3), 0) # gaussian Blur 
    l_ROI_img = cv2.Canny(blur_img, 70, 100) # Canny edge 

    r_ROI_img = filter_line(region_of_interest(BEV_img, r_vertices))
    #cv2.imshow("r_image", r_ROI_img)

    gray_img = cv2.cvtColor(r_ROI_img, cv2.COLOR_BGR2GRAY)
    blur_img = cv2.GaussianBlur(gray_img, (3, 3), 0) # gaussian Blur 
    # cv2.imshow("blur",blur_img)

    r_ROI_img = cv2.Canny(blur_img, 70, 100) # Canny edge 

    left_line = cv2.HoughLinesP(l_ROI_img, 1, 1*np.pi/180, 1, minLineLength = 5)
    left_line = np.squeeze(left_line)

    # print("LEFT LINE")
    # print(left_line)

    # tiltSum = 0
    # for line in np.array(left_line)[:,None]:
    #     for x1,y1,x2,y2 in line:
    #         tilt = (y2 - y1) / (x2-x1 + 0.0000001)
    #         tiltSum = tiltSum+tilt
    #         print("TILT = {}".format(tilt))
    # tiltSum = tiltSum / len(left_line)
    # print("TILTEVER = {}".format(tiltSum))

    right_line = cv2.HoughLinesP(r_ROI_img, 1, 1*np.pi/180, 1, minLineLength = 5)
    right_line = np.squeeze(right_line)

    
    line_img = np.zeros((BEV_img.shape[0], BEV_img.shape[1], 3), dtype=np.uint8)
    if left_line.size != 0:
        draw_lines(line_img, np.array(left_line)[:,None])
    if right_line.size != 0:
        draw_lines(line_img, np.array(right_line)[:,None])

    edge_img = cv2.addWeighted(BEV_img, 1, line_img, 1, 0)


    # # --------------------- Get Model ---------------------------

    global model_Lx, model_Ly, model_Rx, model_Ry,  Rx, Ry, Lx, Ly, forward, pre_l_model_a, pre_l_model_c, pre_r_model_a, pre_r_model_c, left_bias, right_bias, center
    model_Lx[:], model_Ly[:], model_Rx[:], model_Ry[:], Rx[:], Ry[:], Lx[:], Ly[:] = [], [], [], [], [], [], [], []
    l_model_a, l_model_c, r_model_a, r_model_c = 0,0,0,0
    
    if len(left_line)>10:
        l_model_a, l_model_c, inlier = getModel(left_line, Lx, Ly)
        print("LEFT -----------------------------")
        if canUseModel(l_model_a, l_model_c, pre_l_model_a, pre_l_model_c, inlier/len(left_line)) == False:
            l_model_a = pre_l_model_a
            l_model_c = pre_l_model_c

        
        model_Lx = [a for a in range(0, 600)]
        model_Ly = [l_model_a*a+int(l_model_c) for a in range(0, 600)]

        if len(model_Ly) != len(model_Lx):
            print("XY {} {}".format(len(model_Lx), len(model_Ly)))
            print("model {} {}".format(l_model_a, l_model_c))
            while True:
                l_model_a=l_model_a

        pre_l_model_a = l_model_a
        pre_l_model_c = l_model_c

    if len(right_line)>10:
        r_model_a, r_model_c, inlier = getModel(right_line, Rx, Ry)
        print("RIGHT -----------------------------")

        if canUseModel(r_model_a, r_model_c, pre_r_model_a, pre_r_model_c, inlier/len(right_line)) == False:
            r_model_a = pre_r_model_a
            r_model_c = pre_r_model_c

        model_Rx = [a for a in range(0, 600)]
        model_Ry = [r_model_a*a+int(r_model_c) for a in range(0, 600)]

        if len(model_Ry) != len(model_Rx):
            print("XY {} {}".format(len(model_Rx), len(model_Ry)))
            print("model {} {}".format(r_model_a, r_model_c))
            while True:
                r_model_a=r_model_a

        pre_r_model_a = r_model_a
        pre_r_model_c = r_model_c
    

    print("BIAS 0") 
    center = getCenter( getXBias(pre_l_model_a, pre_l_model_c, 0) , getXBias(pre_r_model_a, pre_r_model_c, 0) )
    print(" RETURN {} ".format(center))

    lane_img = printLane(BEV_img, croped_img, l_model_a, l_model_c, r_model_a, r_model_c, forward)

    result_img=img.copy()
    result_img.setflags(write=1)
    result_img[BEV_TOP_PADDING:(BEV_TOP_PADDING+BEV_H), 0:BEV_W] = lane_img
    

    # # ---------------------- PRINT ------------------------------
    # cv2.imshow("line_img",line_img)
    # cv2.imshow("raw_img",img)
    # cv2.imshow("BEV_image",BEV_img)
    # cv2.imshow("MY_IMAGE", img)
    cv2.imshow("BEY", edge_img)
    cv2.imshow("result", result_img)
    cv2.waitKey(1)
    os.system('clear')

    

    return


# -------------------PARAMETER-------------------------
BEV_H = 250
BEV_W = 640 
BEV_TOP_PADDING = 230

IMAGE_W = 640
IMAGE_H = 480
DISTORTION = 270

CROP_WIDTH_PADDING = 150 # (LR crop  v---------------v)


forward = 20

left_bias, right_bias = 330,350

#----------------------------------------------------

model_Lx = []
model_Ly = []
model_Rx = []
model_Ry = []
Rx = []
Ry = []
Lx = []
Ly = []

pre_l_model_a, pre_l_model_c, pre_r_model_a, pre_r_model_c = 0,0,0,0

M=None
revM=None

center = 0


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
    rbg_emb, cluster_result = process_instance_embedding(instance_embedding, binary_img,distance=1.5, lane_num=2)
    rbg_emb = cv2.resize(rbg_emb, dsize=(org_shape[1], org_shape[0]), interpolation=cv2.INTER_LINEAR)
    a = 0.6
    frame = a * gt_img_org[..., ::-1] / 255 + rbg_emb * (1 - a)
    frame = np.rint(frame * 255)
    frame = frame.astype(np.uint8)

    motor_info = drive_values()

    y, x = get_lane_center(binary_img)
    
    motor_info.steering = math.atan2(y,x)*(180/3.14)-90
    motor_info.throttle = 3
    drive_values_pub.publish(motor_info)

    print("motor_info.steering: ",motor_info.steering)
    print("")


    return frame

def get_lane_center(binary_img):
    """Calculate center coordinates of the lane.
    This function assumes the input image's vanishing point is in the middle of the image.
    """
    # We're only interested in the bottom half of the image
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

    # Calculate longitudinal and lateral distances
    longitudinal_distance = binary_img.shape[0]
    lateral_distance = lanex_center - car_center
    
    #print(f"Longitudinal distance: {longitudinal_distance}, Lateral distance: {lateral_distance}")
    return longitudinal_distance, lateral_distance


# 이 코드는 각 차선의 히스토그램을 계산한 후, 이 히스토그램의 최대값(즉, 차선의 중심)을 찾아 차선의 중간 좌표를 계산합니다.


def getHomography():
    global BEV_H,BEV_W, DISTORTION, M, revM
    # 12
    # 34
    src = np.float32([[0, BEV_H], [IMAGE_W, BEV_H], [0, 0], [BEV_W, 0]])
    dst = np.float32([[DISTORTION, BEV_H], [BEV_W - DISTORTION, BEV_H], [0, 0], [BEV_W, 0]])

    M = cv2.getPerspectiveTransform(src, dst) # 원근 투영 변환 행렬
    revM = cv2.getPerspectiveTransform(dst, src) # 역행렬
    print("MATRIX  1{}".format(M))
    print("MATRIX  2{}".format(revM))
    return

#위에 함수에서 받은 M을 사용하여 BEV변환을 수행합니다.
def getBEV(img):
    BEV = cv2.warpPerspective(img, M, (BEV_W, BEV_H))
    return BEV

#  hough변환을 사용하여 이미지에서 선을 찾음
def hough_lines(img, rho, theta, threshold, min_line_len, max_line_gap): # hough transform
    lines = cv2.HoughLinesP(img, rho, theta, threshold, np.array([]), minLineLength=min_line_len, maxLineGap=max_line_gap)
    return lines

#이미지 위에 선을 글그립니다. (선의 색상과 두께 설정)
def draw_lines(img, lines, color=[0, 0, 255], thickness=7):
    for line in lines:
        for x1,y1,x2,y2 in line:
            cv2.line(img, (x1, y1), (x2, y2), color, thickness)

#흰색과 노란색을 필터링하는 역할
def filter_line(image): 
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    h,s,v = cv2.split(hsv)

    re_img=image
    # 흰색 필터(140~180)
    white_threshold = 140 #130
    lower_white = np.array([white_threshold, white_threshold, white_threshold])
    upper_white = np.array([180, 180, 180])
    white_mask = cv2.inRange(image, lower_white, upper_white)
    white_image = cv2.bitwise_and(image, image, mask=white_mask)

    # Filter black pixels
    # black_threshold = 50 #130
    # lower_black = np.array([0, 0, 0])
    # upper_black = np.array([black_threshold, black_threshold, black_threshold])
    # black_mask = cv2.inRange(image, lower_black, upper_black)
    # black_image = cv2.bitwise_not(cv2.bitwise_and(image, image, mask=black_mask))

    # # # # Filter yellow pixels
    # lower_yellow = np.array([90,100,100])
    # upper_yellow = np.array([110,255,255])
    
    #노랑색 필터
    lower_yellow = np.array([20,120,120])
    upper_yellow = np.array([255,255,255])
    yellow_mask = cv2.inRange(hsv, lower_yellow, upper_yellow)
    yellow_image = cv2.bitwise_and(image, image, mask=yellow_mask)

    #흰색 이미지와 노란색 이미지를 합칩니다.
    null_img = np.zeros((image.shape[0], image.shape[1],3), dtype=np.uint8)
    re_img = cv2.addWeighted(white_image, 1., null_img, 1., 0.)
    re_img = cv2.addWeighted(yellow_image, 1., re_img, 1., 0.)
    
    # cv2.imshow("while_filter", white_image)
    # cv2.imshow("yellow_filter", yellow_image)

    return re_img

#관심 영역( ROI)을 설정
def region_of_interest(img, vertices, color3=(255,255,255), color1=255): # ROI set

    mask = np.zeros_like(img) 
    if len(img.shape) > 2: 
        color = color3
    else: 
        color = color1
        
    cv2.fillPoly(mask, vertices, color)
    ROI_image = cv2.bitwise_and(img, mask)
    return ROI_image

#RANSAC 알고리즘을 사용하여 모델을 학습합니다.
def getModel(line_arr, arrX, arrY):
    
    for i in line_arr:
        reArray=interpolate(i[0],i[1],i[2],i[3])
        if len(reArray)==0:
            ttemp=1
        else:
            for re in reArray:
                arrX.append(re[0])
                arrY.append(re[1])

    model_a, model_b, model_c, max = RANSAC(arrX,arrY)

    # print("LINE {}, Point {} Inlier {}".format(len(line_arr), len(arrX), max))
    return model_a, model_c, max

    # return 1,1

#밑의 계산한 좌쵸들을 리스트에 추가하여 반환 
def interpolate(x1, y1, x2, y2):
    re=[]
    if abs(y2-y1) <2:
        return re

    re.append([x1, y1])
    re.append([x2, y2])
    
    if x2-x1 == 0:
        tilt =10000
    else:
        tilt = (y2-y1)/(x2 - x1+0.000001)
    for i in range(x1, x2, 1):
        idx = i-x1
        re.append([x1+idx, y1+tilt*idx])
    return re

#주어진 파라미터를 이용하여 차선을 시각화하고 이를 원해 이미지에 합성합니다.
def printLane(img, img2, la, lc, ra, rc, forward):
    global BEV_H
    color=(255,0,0)
    lx = (forward - lc)/(la+0.00001)
    rx = (forward - rc)/(ra+0.00001)

    lx2 = (BEV_H-lc)/(la+0.00001)
    rx2 = (BEV_H-rc)/(ra+0.00001)
    #    lx rx
    # lx2     rx2

    if lx > 600:
        lx = 320
    if rx > 600:
        rx = 360

    if lx2 > 600:
        lx2 = 340
    if rx2 > 600:
        rx2 = 300
    # print("XXX ======================= {} {}".format(lx, rx))

    vertice = np.array(
        [
            [
                (int(lx), forward),
                (int(rx), forward),
                (int(rx2), BEV_H),
                (int(lx2), BEV_H)
            ]
        ]
    )
    mask = np.zeros_like(img)
    cv2.fillPoly(mask, vertice, color)
    ROI_image = cv2.bitwise_or(img, mask)

    nor_mask = np.zeros_like(img2)
    cv2.fillPoly(nor_mask, vertice, color)

    BEV = cv2.warpPerspective(nor_mask, revM, (BEV_W, BEV_H)) # get BEV
    ROI_image2 = cv2.bitwise_or(img2, BEV)

    return ROI_image2

#주어진 높이에서 차선이 어디에 위치하느지를 결정.
def getXBias(model_a, model_c, height):
    model_bias = (height+model_c)/(model_a + 0.000001)
    return model_bias


def canUseModel(model_a, model_c, pre_model_a, pre_model_c, inlierRatio):
    #현재 모델 없으면 false반환    
    if model_a == 0:
        print("NO MODEL")
        return False

    model_bias = getXBias(model_a, model_c, 200)
    pre_model_bias = getXBias(pre_model_a, pre_model_c, 200)

    sub = abs(model_bias - pre_model_bias)
    print("SUB = {}".format(sub))
    print("BIAS = {}".format(model_bias))


    if pre_model_a == 0 or inlierRatio > 0.4:
        return True
    
    if sub > 100:
        return False

    return True

def getCenter(l_bias, r_bias):
    l_bias = abs(l_bias)
    r_bias = abs(r_bias)
    leftError, rightError, centerError = False, False, False

    if l_bias < 210 or 270 < l_bias:
        print("LEFT ERROR!!!!")
        leftError = True

    if r_bias < 370 or 430 < r_bias:
        print("RIGHT ERROR!!!!")
        rightError = True


    center = (abs(l_bias) + abs(r_bias))/2
    if center < 290 or 350 < center:
        print("CENTER ERROR!!!!")
        centerError = True

    print("{}  /  {}".format(l_bias, r_bias))
    print("CENTER : {}".format(center))


    if centerError == False:
        return center
    if leftError and rightError:
        return -1

    if leftError:
        return r_bias - 80
    if rightError:
        return l_bias + 80
    
    return center

#Birdeyeview
def main():
    rospy.init_node('birdEye')
    rate = rospy.Rate(3)
    print("Node_On")
    getHomography()
    rospy.Subscriber(img_msg_name,Image, imageCallback, queue_size=1)
    center_pub = rospy.Publisher("lane_pub", Float64, queue_size=10)

    global  model_Lx, model_Ly, model_Rx, model_Ry, Rx, Ry, Lx, Ly
    
    while not rospy.is_shutdown():
        rate.sleep() 
        plt.cla()
        plt.gcf().canvas.mpl_connect(
            'key_release_event',
            lambda event: [exit(0) if event.key == 'escape' else None])
        if len(model_Lx) > 10:
            plt.plot(model_Lx,model_Ly,'-r')
            plt.plot(Lx,Ly,'*k')
        if len(model_Rx) > 10:
            plt.plot(model_Rx,model_Ry,'-g')
            plt.plot(Rx,Ry,'*b')
        plt.xlim(0,640)
        plt.ylim(200,0)
        plt.pause(0.0001)
        plt.grid(True)
        center_pub.publish(center)
        

        #


if __name__ == "__main__":
    image_sub = rospy.Subscriber("/usb_cam/image_raw/", Image, imageCallback)
    #main()
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