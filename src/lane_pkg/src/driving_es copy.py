#!/usr/bin/env python3
# -*- coding: utf-8 -*-


#기본제공 코드에 대한 주석은 인코딩문제로 문자가 깨져있어 모두 삭제하였습니다.

import numpy as np
import cv2, math
import rospy, rospkg, time

from sensor_msgs.msg import Image
from cv_bridge import CvBridge
from race.msg import drive_values

from math import *
import signal
import sys
import os
import random


drive_values_pub= rospy.Publisher('control_value', drive_values, queue_size = 1)

previous_angle = 0
show_img = np.empty(shape=[0])

# 추후에 color filtering을 통해 흰색의 차선만을 추출하기 위한 픽셀 범위값을 미리 선언하였습니다
global lower_white
lower_white = np.array([200,60,150])
global upper_white
upper_white = np.array([255,255,255])
global yellow_lower
lower_yellow = np.array([200,60,150])
global yellow_upper
upper_yellow = np.array([255,255,255])




def init_show_img(img) :
    global show_img
    show_img = img


def signal_handler(sig, frame):
    time.sleep(3)
    os.system('killall -9 python rosout')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)


image = np.empty(shape=[0]) 
bridge = CvBridge() 
motor = 0


CAM_FPS = 30    
WIDTH, HEIGHT = 640, 480    


def img_callback(data):
    
    
    global image
    image = bridge.imgmsg_to_cv2(data, "bgr8")

global motor_info

def drive(angle, speed):
    motor_info = drive_values()
    motor_info.steering = angle
    motor_info.throttle = speed
    drive_values_pub.publish(motor_info)




# 흰색의 픽셀만을 추출해내기 위한 color_filter 함수입니다. 앞서 선언한 lower_white 와 upper_white 값을 이용하여 cv2.inRange함수를 통해 해당 범위 내의 픽셀만을 추출해내었습니다.
def color_filter(img):
    mask_yellow = cv2.inRange(img, lower_yellow, upper_yellow)
    mask_white = cv2.inRange(img,lower_white,upper_white)
    masks = cv2.bitwise_or(mask_yellow, mask_white)
    masked = cv2.bitwise_and(img,img,mask = masks)

    return masked


# 카메라의 원근왜곡을 제거하여 차선을 평행하게 만들어주기 위한 Bird-eye-view 변환 함수입니다.
# bird-eye-view 변환에는 넓은시야각을 얻기 위해 역투영변환법을 적용하였습니다
def bird_eye_view(img,width,height):
    src = np.float32([[0,0],
                  [width,0],
                  [0,160],
                  [width,160]])

    dst = np.float32([[0,0],
                  [width,0],
                  [185,height],
                  [460,height]])   #src, dst는 모두 순서대로 왼쪽위, 오른쪽위, 왼쪽아래, 오른쪽 아래 점입니다.230, 415
                                    #원본의 점인 src를 상단보다 하단이 좁은 사다리꼴 형태의 dst점으로 변환시킴으로서 bird-eye-view가 완성됩니다.
         
    M = cv2.getPerspectiveTransform(src,dst)
    M_inv = cv2.getPerspectiveTransform(dst,src)
    img_warped = cv2.warpPerspective(img,M,(width,height))  # cv2.getPerspectiveTransform 함수를 이용하여 변환행렬을 계산하고 warpPerspective 함수를 이용하여 시점변환하였습니다.
    return img_warped


#차선이 포함될 것으로 예상되는 부분 이외의 픽셀의 픽셀값은 모두 0으로 바꿔주었습니다. 차량이 속해있는 차선외의 차선에 간섭을 줄이기 위함입니다.
def region_of_interest(img):
    #height = 480

    height = 480
    width = 640
    mask = np.zeros((height,width),dtype="uint8")
    pts = np.array([[100,0],[500,0],[500,480],[100,480]])  # 차례대로 왼쪽위, 오른쪽위, 오른쪽아래,왼쪽아래 점이며 저희는 하나의 차선만 인식되어도 안정적으로 주행할 수 있도록 구현하였기에 roi를 보수적으로 설정하여 노이즈를 가능한 줄여주었습니다.
	

    mask= cv2.fillPoly(mask,[pts],(255,255,255),cv2.LINE_AA)


    img_masked = cv2.bitwise_and(img,mask)
    return img_masked


#차선의 곡률반경을 구하는 함수입니다.
#자세한 계산방법은 과제3번 SW설계서 1번미션에 기술하였습니다.
#차선의 맨 윗점과 맨 아랫점을 추출하고, 두 점 사이의 거리와 두점을 잇는 직선의 방정식을 이용하여 계산하였습니다.
def Radius(lx, ly):
    a=0
    b=0
    c=0
    R=0
    h=0
    w=0  #변수들을 초기화하는 과정입니다.
    if (lx[-1] - lx[1] != 0): 
        a = (ly[-1] - ly[3]) / (lx[-1] - lx[3])
        b = -1
        c = ly[3] - lx[3] * (ly[-1] - ly[3]) / (lx[-1] - lx[3])
        h = abs(a * np.mean(lx) + b * np.mean(ly) + c) / math.sqrt(pow(a, 2) + pow(b, 2))
        w = math.sqrt(pow((ly[-1] - ly[3]), 2) + pow((lx[-1] - lx[3]), 2))
             #rx,ry 는 각 window 조사창 내에 속해있는 흰색 픽셀들의 픽셀좌표의 평균을 담아놓은 리스트입니다.
	     #rx[-1]은 제일 위에있는 window를, rx[3]은 아래에서 4번째에 있는 window를 의미합니다.
	     #rx[0]대신 rx[3]을 이용한 이유는 시뮬레이터상의 카메라 높이가 낮아 차량에 가까운 차선이 인식이 불안정하였기 때문입니다.

    if h != 0:
        R = h / 2 + pow(w, 2) / h * 8
	
    return R*3/800 


#계산한 곡률반경을 이용하여 steering_Angle값을 계산하는 함수입니다.
#차량의 제원이 제공되지않아 1.04m로 가정하고 계산하였습니다.
def steering_Angle(R):
    if R == 0:
        return 0
    if R != 0:
        angle = np.arctan(1.04/R) 
        return angle 
        # if angle*180/np.pi < 0.07:  #Angle값이 매우 작은 경우 직진상태로 판단하여 0을 return 하도록 하였습니다.
        #     return 0
        # else:		
        #     return angle # arctan로 계산한 값이 radian값이기 때문에 degree로 변환하여 return하였습니다.

		    
#sliding_window 기법을 구현한 함수입니다.
def sliding_window(img_masked,x_temp,y_temp,left_prob,right_prob):
    
    nwindows = 13  #조사창의 갯수입니다.

    window_height = 20 #조사창의 높이입니다.

    
    if(left_prob<150 and right_prob<150): #차선의 검출신뢰도를 계산하여 left_prob, right_prob 변수에 할당하였습니다.
              #차선의 검출 신뢰도는 각 차선의 모든 조사창 내의 0이 아닌 픽셀수의 평균을 계산하여 산출하였습니다. window에 차선이 아예 인식되지 않을경우 0이 됩니다    
        margin=60
    else:
 
        margin = 20         #margin은 window의 너비를 지칭하는 변수입니다. 기본 너비는 20으로 하되 좌,우 차선이 모두 인식률이 낮을때만 차선을 탐색하기 위하여 너비를 60으로 만들어주었습니다.
    minpix= 5
    
    out_img = np.dstack((img_masked, img_masked, img_masked)) * 255 #window 검출결과를 이미지로 담기 위해 빈 이미지를 선언해주었습니다.

    histogram = np.sum(img_masked[img_masked.shape[0] // 2:, :], axis=0) #y축 방향으로 0이아닌 픽셀의 갯수를 조사하여 histogram변수에 할당하였습니다.

    midpoint = 320
    leftx_current = np.argmax(histogram[150:250])+150   #histogram 변수에서 150~250범위 내에 0이아닌 픽셀이 가장 많은 x좌표를 검출하여 sliding window의 최초 조사창의 x좌표로 설정하였습니다.
    rightx_current = np.argmax(histogram[midpoint+100:450]) + midpoint+100 # 같은 방법으로 우측차선의 x좌표를 설정하였습니다.

    '''if(abs(leftx_current - x_temp) >30):
        leftx_current = x_temp
		
    if(abs(rightx_current-y_temp)>30):
        rightx_current= y_temp'''  # x_temp y_temp변수에 좌,우측차선의 직전 x좌표를 할당하고 새로 계산된 leftx_current와 rightx_current좌표가 기존 값과 30이상 차이가 날 경우 본래 차선이 아닌 다른차선이나 물체가 인식되었다고 판단하고, 그럴 경우 기존의 x좌표를 유지하도록 강제하였습니다.
		
		
    y_temp = rightx_current    
    x_temp = leftx_current #x_temp와 y_temp변수에 leftx_current값과 rightx_current값을 할당하여 다음 시행에 사용하도록 하였습니다.
    nz = img_masked.nonzero()

    left_lane_inds = []
    right_lane_inds = [] # 좌,우측차선의 0이아닌 픽셀의 모든 좌표를 받아내기 위해 left,right_lane_inds 리스트를 선언하였습니다.

    lx, ly, rx, ry = [], [], [], [] #좌,우측 차선의 각 window의 0이아닌 픽셀의 좌표의 평균x좌표와 y좌표를 받아내기 위해 lx,ly,rx,ry 리스트를 선언하였습니다.

    

    for window in range(nwindows):

        win_yl = img_masked.shape[0] - (window + 1) * window_height 
        win_yh = img_masked.shape[0] - window * window_height #win_yl, win_yh변수를 선언하여 각 window 직사각형의 아랫y좌표와 위 y좌표를 할당하였습니다. 

        win_xll = leftx_current - margin # 좌측 차선 window 직사각형의 왼쪽 꼭짓점의 x 좌표입니다.
        win_xlh = leftx_current + margin # 좌측 촤선 window 직사각형의 오른쪽  꼭짓점의 x좌표입니다
        win_xrl = rightx_current - margin # 우측 차선 window 직사각형의 왼쪽 꼭짓점의 x좌표입니다.
        win_xrh = rightx_current + margin # 우측 차선 window 직사각형의 오른쪽 꼭짓점의 x좌표입니다.



        good_left_inds = ((nz[0] >= win_yl) & (nz[0] < win_yh) & (nz[1] >= win_xll) & (nz[1] < win_xlh)).nonzero()[0]
        good_right_inds = ((nz[0] >= win_yl) & (nz[0] < win_yh) & (nz[1] >= win_xrl) & (nz[1] < win_xrh)).nonzero()[0] #window 범위 내에서 0이 아닌 픽셀이 있는경우 해당 픽셀의 좌표를 good_left_inds와 good_right_inds 변수에 할당해주었습니다.

        left_lane_inds.append(good_left_inds)
        right_lane_inds.append(good_right_inds) #직전에 구한 좌표를 위에서 선언한 left , right_lane_inds 리스트에 append 해주었습니다.

        if len(good_left_inds) > minpix:
            leftx_current = int(np.mean(nz[1][good_left_inds]))
        if len(good_right_inds) > minpix:
            rightx_current = int(np.mean(nz[1][good_right_inds])) #각 차선의 window에 0이 아닌 픽셀의 평균x좌표를 계산하여 다음 윈도우의 중앙 x좌표로 사용합니다.

        lx.append(leftx_current) # 계산된 window의 중앙x,y좌표를 lx,ly리스트에 append하여 모든 window의 중앙x,y좌표를 얻어냅니다.
        ly.append((win_yl + win_yh) / 2)

        rx.append(rightx_current)
        ry.append((win_yl + win_yh) / 2) #lx,ly와 같은 방법을 우측차선에도 적용시킵니다. 

        cv2.rectangle(out_img, (win_xll, win_yl), (win_xlh, win_yh), (0, 255, 0), 2)
        cv2.rectangle(out_img, (win_xrl, win_yl), (win_xrh, win_yh), (0, 255, 0), 2) #sliding window를 시각화하기 위해 계산해낸 좌표를 기반으로하여 직사각형을 그려줍니다.

    left_lane_inds = np.concatenate(left_lane_inds)
    right_lane_inds = np.concatenate(right_lane_inds) #left ,right_lane_inds 를 array로 변환합니다. 


    

    out_img[nz[0][left_lane_inds], nz[1][left_lane_inds]] = [255, 0, 0]
    out_img[nz[0][right_lane_inds], nz[1][right_lane_inds]] = [0, 0, 255] # 좌,우측차선의 window 내의 픽셀값이 0이 아닌 모든 픽셀에 color를 할당하여 시각화합니다.



    

    return out_img ,lx,ly,rx,ry,good_left_inds,good_right_inds

def start():
    
    global previous_angle

    lx,ly,rx,ry = [200,] , [] , [428,] , []  #sliding_Window 함수 내에서 x_temp , y_temp 매개변수에 lx[0]과 rx[0]을 할당해주어야 하기에 초기화 합니다. 
    
    left_lane_inds , right_lane_inds = [], [] #left_lane_inds 와 right_lane_inds 리스트 또한 left_prob와 right_prob를 계산하는데에 사용해야하기에 초기화해줍니다.
    global motor, image

 
    rospy.init_node('lane')
    # motor = rospy.Publisher('xycar_motor', xycar_motor, queue_size=1)
    image_sub = rospy.Subscriber("/usb_cam/image_raw/",Image,img_callback)

    print ("----- Xycar self driving -----")

  
    while not image.size == (WIDTH * HEIGHT * 3):
        continue
 
    left_prob,right_prob = 0,0 #left_prob와 right_prob또한 slidingwindow 함수의 매개변수로 사용해야하기에 초기화합니다.
    while not rospy.is_shutdown():
        speed =10
      
        img_frame = image.copy() # img_frame변수에 카메라 이미지를 받아옵니다.   
        height,width,channel = img_frame.shape # 이미지의 높이,너비,채널값을 변수에 할당합니다. 
        img_roi = img_frame[280:,0:]   # y좌표 0~320 사이에는 차선과 관련없는 이미지들이 존재하기에 노이즈를 줄이기 위하여 roi설정을 해주었습니다.
        img_filtered = color_filter(img_roi)   #roi가 설정된 이미지를 color_filtering 하여 흰색 픽셀만을 추출해냅니다. 
	    

        img_warped = bird_eye_view(img_filtered,width,height) # 앞서 구현한 bird-eye-view 함수를 이용하여 시점변환해줍니다. 
	
	
        _, L, _ = cv2.split(cv2.cvtColor(img_warped, cv2.COLOR_BGR2HLS))
        _, img_binary = cv2.threshold(L, 200, 255, cv2.THRESH_BINARY) #color_filtering 된 이미지를 한번 더 이진화 하여 차선 검출의 신뢰도를 높였습니다. 

        img_masked = region_of_interest(img_binary) #이진화까지 마친 이미지에 roi를 다시 설정하여줍니다.  
	
        out_img,lx,ly,rx,ry,left_lane_inds,right_lane_inds = sliding_window(img_masked,lx[0],rx[0],left_prob,right_prob) #sliding window함수에서 return받을 수 있는 값들을 모두 할당해줍니다. 
	
        img_blended = cv2.addWeighted(out_img, 1, img_warped, 0.6, 0) # sliding window결과를 시각화하기 위하여 out_img와 시점변환된이미지를 merging 하였습니다. 

        R= Radius(lx,ly)
	
        angle = steering_Angle(R) *16  # 앞서 구현한 곡률반경 함수와 steering Angle값 계산함수를 이용하여 R과 angle변수를 초기화합니다. default로 좌측차선을 인식하여 주행합니다. 
	
	
        left_prob = np.mean(np.count_nonzero(left_lane_inds))
        right_prob = np.mean(np.count_nonzero(right_lane_inds)) #left_prob와 right_prob에 좌,우측차선의 모든 window 내의 0이 아닌 픽셀의 갯수를 평균 계산하여 좌,우측 차선의 신뢰도로 활용합니다. 
	
	
        if(right_prob>left_prob or rx[-1] - rx[3] <0 ):	#좌회전을 실시하는 경우 우측차선만 검출될 확률이 높기에 우측차선의 신뢰도가 좌측차선보다 높거나 우측차선의 맨 끝 window의 x좌표가 4번째 window의 x좌표보다 작을 경우 좌회전을 하도록 하였습니다.
            R = Radius(rx,ry)
            angle = steering_Angle(R)*-9
            if(rx[3 ]>435):
                angle*=0.7
			
	
	
			

	
        if (abs(angle)<=5 and lx[3]<170): #차량이 너무 우측차선에 쏠려있는 경우 차량의 중앙으로 정렬할 수 있게끔 방어코드를 작성하였습니다.
		
            angle=steering_Angle(R)*-9
			
	
		
	
	
	
	
              
       
        
        cv2.imshow("CAM View", img_blended)
        cv2.waitKey(1)     
        speed_ctrl = abs(angle)
        
        if(speed_ctrl==0):
            speed_ctrl=1
	
	
        speed = 400/speed_ctrl
        if speed>35:
            speed=5
        elif speed<25:
            speed = 5 # 속도를 선형제어 하기 위하여 angle값을 speed_ctrl 변수에 받아온 후 비율을 정하여 speed값을 산출해내었고, 최대, 최소 speed값을 지정하였습니다.

        if(right_prob<100 and left_prob<100):
            speed = 5
            angle = previous_angle   #좌,우측 차선의 신뢰도가 모두 낮을 경우 감속하고 이전 조향각을 그대로 유지하도록 하였습니다. 
	    
        previous_angle = angle
        
        drive(angle, speed)
	


if __name__ == '__main__':
    start()

