#!/usr/bin/env python3
#include
import os
import cv2
import numpy as np
import matplotlib.pyplot as plt
import rospy
from sensor_msgs.msg import Image
from std_msgs.msg import String
from cv_bridge import CvBridge
from ransac_1d import RANSAC
from std_msgs.msg import Float64
from race.msg import drive_values


drive_values_pub= rospy.Publisher('control_value', drive_values, queue_size = 1)
drive_values_pub= rospy.Publisher('--', drive_values, queue_size = 1)


# img_msg_name = "/vds_node_localhost_2211/image_raw"
img_msg_name = "/usb_cam/image_raw"



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

#원근 투영 변환 행렬을 계산하는 함수 - 2D이미지에서 3D공간을 시물레이션하는 데 사용되는 기술(Bird-Eye View)
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

#차량의 조향 각도 계산
def getSteeringAngle(left_line, right_line, frame_width, frame_height):
    motor_info = drive_values()
    # 차선의 중앙을 계산
    lane_center = (left_line[2] + right_line[2]) / 2.0

    # 차량의 중앙을 설정
    vehicle_center = frame_width / 2

    # 차량 중앙과 차선 중앙 사이의 거리를 계산
    center_offset_pixels = lane_center - vehicle_center

    # 픽셀 단위의 거리를 미터로 변환 (이 값을 실제 차량과 환경에 맞게 조정해야 함) - 실험하면서 값 변경
    center_offset_meters = center_offset_pixels / 250.0

    # 조향 각도를 계산 (예를 들어, 미터당 (0.4)도로 설정) - 0.4 변경 해야할 수도
    motor_info.steering = center_offset_meters * 0.4
    return motor_info.steering


def imageCallback(msg):
    global BEV_H,BEV_W, BEV_TOP_PADDING, M, revM

    print("CALLBACK")
    bridge = CvBridge()
    img = bridge.imgmsg_to_cv2(msg)

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

    #조향각
    left_line = [l_model_a, 0, l_model_c]
    right_line = [r_model_a, 0, r_model_c]

    # 조향 각도를 계산
    steering_angle = getSteeringAngle(left_line, right_line, BEV_W, BEV_H)

    # 조향 각도를 출력
    print("Steering Angle: ", steering_angle)
    

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

        
    
if __name__=='__main__':
    main()
    #if()
    #motor_info.steering

