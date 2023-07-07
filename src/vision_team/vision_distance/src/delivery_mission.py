#!/usr/bin/python
#-*- encoding: utf-8 -*-

# video : /home/foscar/ISCC_2021/src/vision_distance/src/ISCC_2021_Vision/yesun/9-2/origin_2021-9-2-13-41.avi
import cv2, rospy, time
import numpy as np
import math
import copy
#yolo에서 보내주는 메세지. 클래스 확률, 좌표값이 들어있음
from darknet_ros_msgs.msg import BoundingBox, BoundingBoxes
# 배달표지판과 차와 배달표지판으로 부터의 x,y 거리 저장
from vision_distance.msg import Delivery, DeliveryArray

from sensor_msgs.msg import Image
from cv_bridge import CvBridge
from geometry_msgs.msg import Point
# from SlidingWindow import SlidingWindow

bridge = CvBridge()
img = np.empty(shape=[0])

# 화면에서의 1픽셀 값이 실제 몇 cm인지 계산하기
pixel = 80.0/200.0 # 0.4cm
# 카메라에서 보이는 실제 위치까지의 거리 (나중에 더해주기)
invisible_distance = 430 # 366
# 화면 640x480의 아래 중간값
center = np.array([320,480,1], np.float32)

# black square points
# 검정 네모가 화면에서 보이는 위치값
up_left = [223,381]
up_right = [369,381]
down_left = [217,422]
down_right = [407,422]
# 4개의 모서리 코너 포인트를 저장하는 배열
corner_points_array = np.float32([up_left, up_right, down_left, down_right])

# 바운딩박스 메세지를 담을 변수 선언
box_class = None
box_xmin = None
box_xmax = None
box_ymin = None
box_ymax = None

matrix_path = '/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/src/delivery_matrix'
matrix = None

# 최종적으로 보내주는 메세지 ('토픽이름', import한 토픽 형태, 걍 어디서 보고 씀)
delivery_pub = rospy.Publisher('delivery', DeliveryArray, queue_size=10)

data_list = []

# test visualization
a = np.array([-1,-1,-1], np.float32)
b = np.array([-1,-1,-1], np.float32)

def image_callback(img_data):
	global bridge
	global img
	img = bridge.imgmsg_to_cv2(img_data, "bgr8")


# boundig_box callback
def bounding_callback(msg):
	global box_class, box_xmin, box_xmax, box_ymin, box_ymax
	global data_list
	global bounding_list
	global matrix
	bbox_num = len(msg.bounding_boxes)
	bbox = msg.bounding_boxes
	# yellow_lst = []
	# blue_lst = []
	# bounding_list = []
	if np.any(matrix) == None: return
	
	data_list = []
	
	for idx, box in enumerate(bbox):
		b_flag = -1
		box_class = box.Class
		box_xmin = box.xmin
		box_xmax = box.xmax
		box_ymin = box.ymin
		box_ymax = box.ymax

		# b1(0), b2(1), b3(2)
		if box_class == "B1": b_flag = 1
		if box_class == "B2": b_flag = 2
		if box_class == "B3": b_flag = 3

		if box_class == "A1": b_flag = 4
		if box_class == "A2": b_flag = 5
		if box_class == "A3": b_flag = 6

		# 와프된 이미지의 아래 가운데 계산
		tf_object_center = get_object_center2(box.Class, box.xmin, box.ymin, box.xmax, box.ymax)
		# 와프된 화면의 아래 가운데 계산
		tf_center = np.matmul(matrix, center)
		#print("center:::::::::::", tf_center)
		if tf_center[2] > 0:
			tf_center /= -tf_center[2]
		else:
			tf_center /= tf_center[2]
		#print("::::::::::::::center:::::::::::", tf_center)
		
		# 카메라와 물체까지 거리 계산
		distance = calculate(tf_center, tf_object_center)
		# 절댓값으로 계산 
		distance = abs(distance)

		# print("{}) tf_center: {}, distance: {}".format(idx, tf_center, distance))

		# 플래그값이 들어오면 실행
		if b_flag != -1:
			delivery = Delivery()
			delivery.flag = b_flag
			delivery.dist_x = distance[0]
			delivery.dist_y = distance[1]

			data_list.append(delivery)

	if len(data_list) > 0:
		# 거리순으로 할 필요가 없음 
		# data_list = sorted(data_list, key=lambda x:(x[2],x[1],x[0]))
		# data_list = sorted(data_list, key=lambda x:(x.dist_y,x.dist_x,x.flag))
		delivery_array = DeliveryArray()
		delivery_array.visions = data_list
		# 보내주는 토픽 최종 설정
		delivery_pub.publish(delivery_array)


def get_object_center2(box_class, xmin, ymin, xmax, ymax):
	print("origin:::::::::::::::", ymax) 
	# 욜로 박스 아래 가운데 계산
	object_center = np.array([(xmin + xmax) / 2, ymax, 1], np.float32)
	# 와프된 이미지의 아래 가운데 계산
	tf_object_center = np.matmul(matrix, object_center)
	#print("object__center:::::::::::", tf_object_center)
	# 3D -> 2D로 바꾸기 위해 
	tf_object_center /= tf_object_center[2]
	print("::::::::::::::object__center:::::::::::", tf_object_center)
	

	#if box_class == "B1":
		#print("B1 : ", tf_object_center)
	#elif box_class == "B2":
		#print("B2 : ", tf_object_center)
	#elif box_class == "B3":
		#print("B3 : ", tf_object_center)

	return tf_object_center

# 카메라와 물체까지의 거리
def calculate(tf_center, tf_object_center):
	global a,b
	a = tf_center
	b = tf_object_center	
	# 카메라가 보이는 곳부터 물체까지의 거리 
	distance = tf_center - tf_object_center
	# 픽셀을 곱해서 실제 거리를 바꾸고 
	distance = distance * pixel
	# 안보이는 거리까지 더해줘서 카메라가 안보이는 부분까지 더해주기
	distance[1] += invisible_distance
	print("distance", distance[1])
	# print("distance[0]", int(distance[0]), int(distance[1]))
	return distance


# center_visualization
# 가운데 점 표시
def check_center(image):
	cv2.circle(image, (288,240), 5, (122,0,255), -1)
	return image
	

if __name__ == '__main__':
	global matrix
	#global data_list
	#global img
	rospy.init_node('warp')
	# Video 용 Subscriber
	# image_sub = rospy.Subscriber("/videofile/image_raw/", Image, image_callback)
	# USB CAMERA 용 Subscriber	
	# 카메라 토픽정보 받아오기
	image_sub = rospy.Subscriber("/camera2/usb_cam2/image_raw", Image, image_callback)
	
	# cap = cv2.VideoCapture("/home/foscar/ISCC_2021/src/vision_distance/src/ISCC_2021_Vision/yesun/8-31/origin_2021-8-31-19-42.avi")
	# 욜로 토픽정보 받아오기
	bbox_sub = rospy.Subscriber("/darknet_ros/bounding_boxes/", BoundingBoxes, bounding_callback)
	
	rate = rospy.Rate(10)
	while not rospy.is_shutdown(): #cap.isOpened()
		#ret, img = cap.read()
		#img = cv2.resize(img, (640,480))
		#print(img.shape)
		#print(ret)
		if img.size != (640 * 480 * 3):
			continue
		
		width = 1000
		height = 850
		
		# data_list가 값이 계속 바뀌니까 원본을 저장하기 위한 어레이 ~
		new_data_list = []
		if len(data_list) > 0:
			new_data_list = copy.deepcopy(data_list) 
		#else:
		#	continue
	
		# 와프 전 원본 화면에서 와프된 이미지가 최대한 정사각형으로 보이기 위한 위치 설정 
		img_up_left = [400,600] #[450, 650] #[220,150] #[400,600]
		img_up_right = [600,600] #[550, 650] #[420,150] #[600,600]
		img_down_left = [400,800] #[450, 750] #[220,350] #[400,800]
		img_down_right = [600,800] #[550, 750] #[420,350] #[600,800]
		img_params = np.float32([img_up_left, img_up_right, img_down_left, img_down_right])
		
		# Compute and return the transformation matrix
		# 와프 변환을 위해 곱해줘야하는 matrix 값 계산 
		# 와프를 하려면 matrix를 곱해줘야하는데 그 Matrix를 계산하는 함수 
		matrix = cv2.getPerspectiveTransform(corner_points_array, img_params)
		np_matrix = np.array(matrix)
		np.save(matrix_path, np_matrix)
		print(np_matrix)
		# 와프 변환 계산
		img_transformed = cv2.warpPerspective(img, matrix, (width, height))

		if box_xmin == None or box_ymin == None or box_xmax == None or box_ymax == None: continue 

		xmin = float(box_xmin)
		ymin = float(box_ymin)
		xmax = float(box_xmax)
		ymax = float(box_ymax)

		warp_xymin = np.array([xmin, ymin, 1], np.float32)
		warp_xymax = np.array([xmax, ymax, 1], np.float32)

		warp_xymin = np.matmul(np_matrix, warp_xymin)
		warp_xymax = np.matmul(np_matrix, warp_xymax)
		warp_xymin /= warp_xymin[2]
		warp_xymax /= warp_xymax[2]

		img = check_center(img)
		# print('class name', box_class)
    
		cv2.circle(img, (up_left[0], up_left[1]), 5, (255,0,0), -1)
		cv2.circle(img, (up_right[0], up_right[1]), 5, (0,255,0), -1)
		cv2.circle(img, (down_left[0], down_left[1]), 5, (0,0,255), -1)
		cv2.circle(img, (down_right[0], down_right[1]), 5, (0,0,0), -1)

		cv2.circle(img, (box_xmin, box_ymin), 5, (122,0,0), -1)
		cv2.circle(img, (box_xmax, box_ymin), 5, (122,0,0), -1)
		cv2.circle(img, (box_xmin, box_ymax), 5, (122,0,0), -1)
		cv2.circle(img, (box_xmax, box_ymax), 5, (122,0,0), -1)

		cv2.circle(img, (288,480), 5, (255,0,0),-1 ) # center
		cv2.circle(img_transformed, (int(a[0]),int(a[1])),10,(122,134,115),-1)
		cv2.circle(img_transformed, (int(b[0]),int(b[1])),10,(0,0,155),-1)

		# if (len(new_data_list) > 0):
		# 	left_point = np.array([70.18, 520, 1], np.float32) #[184.18, 520, 1]
		# 	right_point = np.array([570.4, 520, 1], np.float32) #[389.4, 520, 1]
		# 	warp_left_point = np.matmul(np_matrix, left_point)
		# 	warp_left_point /= warp_left_point[2]
		# 	warp_right_point = np.matmul(np_matrix, right_point)
		# 	warp_right_point /= warp_right_point[2]


		# if cv2.waitKey(1) & 0xFF == ord('q'):
		#	break   
		# cv2.imshow("warp", img_transformed) 		
		
		cv2.waitKey(33)
		rate.sleep()

	cv2.destroyAllWindows()
