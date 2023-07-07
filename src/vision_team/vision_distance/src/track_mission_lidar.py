#!/usr/bin/python
#-*- encoding: utf-8 -*-

######################################################
#################### 라이다+비전 #####################
######################################################

import cv2, rospy, time
import numpy as np
import math
import copy
from darknet_ros_msgs.msg import BoundingBox, BoundingBoxes
from sensor_msgs.msg import Image
from vision_distance.msg import Colorcone_lidar, ColorconeArray_lidar
from geometry_msgs.msg import Point
from cv_bridge import CvBridge

pixel = 80.0/200.0 # 0.4cm
center = np.array([288,480,1], np.float32)
invisible_distance = 207

bridge = CvBridge()
img = np.empty(shape=[0])

up_left = [253,315]
up_right = [323,315]
down_left = [247,383]
down_right = [328,383]
corner_points_array = np.float32([up_left,up_right,down_left,down_right])

box_class = None
box_xmin = None
box_xmax = None
box_ymin = None
box_ymax = None

matrix_path = '/home/youngsangcho/ISCC_2023/src/vision_team/vision_distance/src/matrix'
matrix = None
cone_pub = rospy.Publisher('color_cone', ColorconeArray_lidar, queue_size=10)

data_list = []


def image_callback(img_data):
	global bridge
	global img
	img = bridge.imgmsg_to_cv2(img_data, "bgr8")

# boundig_box callback
def bounding_callback(msg):
	global box_class, box_xmin, box_xmax, box_ymin, box_ymax
	global data_list	
	global matrix
	global cone_array
	bbox_num = len(msg.bounding_boxes)
	bbox = msg.bounding_boxes

	if np.any(matrix) == None: return
	
	data_list = []

	for idx, box in enumerate(bbox):
		box_class = box.Class
		box_xmin = box.xmin
		box_xmax = box.xmax
		box_ymin = box.ymin
		box_ymax = box.ymax

		# blue(1), yellow(0)		
		cone_flag = 1
		if box_class == "yellow cone": cone_flag = 0

		tf_object_center = get_object_center2(box_xmin, box_ymin, box_xmax, box_ymax)
		tf_center = np.matmul(matrix, center)
		tf_center /= tf_center[2]

		distance = calculate(tf_center, tf_object_center)
		print("{}) tf_center: {}, distance: {}".format(idx, tf_center, distance))

		cone = Colorcone_lidar()
		cone.flag = cone_flag
		cone.dist_x = distance[0]
		cone.dist_y = distance[1]

		data_list.append(cone)
		#print("Data_list", data_list)
		#print("data_list len", len(data_list))

	cone_array = ColorconeArray_lidar()
	cone_array.colorcone = data_list
	cone_pub.publish(cone_array)

def calculate(tf_center, tf_object_center):
	distance = tf_center - tf_object_center
	distance = distance * pixel
	distance[1] += invisible_distance
	#print("distance", distance)
	return distance	

# center_visualization
def check_center(image):
	cv2.circle(image,(288,240),5, (122,0,255),-1)
	return image

def get_object_center2(xmin, ymin, xmax, ymax): 
	object_center = np.array([(xmin + xmax) / 2, ymax, 1], np.float32)
	tf_object_center = np.matmul(matrix, object_center)
	tf_object_center /= tf_object_center[2]
	# print("trffic_rubber : ", tf_object_center)

	return tf_object_center


if __name__ == '__main__':
	global matrix
	#global data_list
	#global img
	rospy.init_node('warp')

	# USB CAMERA 용 Subscriber	
	image_sub = rospy.Subscriber("/usb_cam/image_raw/", Image, image_callback)
	
	bbox_sub = rospy.Subscriber("/darknet_ros/bounding_boxes/", BoundingBoxes, bounding_callback)
	
	rate = rospy.Rate(10)
	while not rospy.is_shutdown(): #cap.isOpened()
		#ret, img = cap.read()
		#img = cv2.resize(img, (640,480))
		#print(img.shape)
		#print(ret)
		if img.size != (640 * 480 * 3):
			continue

		# try:
		# 	out.write(img)
		# except:
		# 	pass
		
		width = 1000
		height = 850
		
		new_data_list = []
		
		if len(data_list) > 0:
			new_data_list = copy.deepcopy(data_list)
			#new_data_list = data_list.copy()
			print("new_data_list %%%%%%%%%%%%%% ", new_data_list)
		#else:
		#	continue
				
		
		img_up_left = [450, 650] #[220,150] #[400,600]
		img_up_right = [550, 650] #[420,150] #[600,600]
		img_down_left = [450, 750] #[220,350] #[600,800]
		img_down_right = [550, 750] #[420,350] #[400,800]
		img_params = np.float32([img_up_left, img_up_right, img_down_left, img_down_right])

	    # Compute and return the transformation matrix
		matrix = cv2.getPerspectiveTransform(corner_points_array, img_params)
		np_matrix = np.array(matrix)
		np.save(matrix_path, np_matrix)	
		# print(np_matrix)
		img_transformed = cv2.warpPerspective(img, matrix, (width, height))

		#black_img_roi = black_img[200:850, 0:1000]

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

		cv2.circle(img, (288,480), 5, (255,0,0),-1 ) #center

		yellow_arr = []
		blue_arr = []
		# yolo center visualization
		if (len(new_data_list) > 0):
			print("data_list**************", data_list)
			
			print("len(new_data_list) :", len(new_data_list))
			
			yello_cnt = 0
			blue_cnt = 0
			
			for i in range (0, len(new_data_list)):
				print("i", i)
				print("data list i", new_data_list[i])
 
				if (new_data_list[i].flag == 0):
					yello_cnt += 1
					print("yello_cnt : ", yello_cnt)
					yellow_arr.append([new_data_list[i].flag, new_data_list[i].dist_x, new_data_list[i].dist_y])
					#print("yellow_arr", yellow_arr)
					#cv2.circle(img_transformed_y, (int(new_data_list[i].x), int(new_data_list[i].y)), 25, (0,122,122), -1)
				elif (new_data_list[i].flag == 1):
					blue_cnt += 1
					print("blue_cnt : ", blue_cnt)
					blue_arr.append([new_data_list[i].flag, new_data_list[i].dist_x, new_data_list[i].dist_y])	
					#print("blue_arr", blue_arr)
					#cv2.circle(img_transformed_b, (int(new_data_list[i].dist_x), int(new_data_list[i].dist_y)), 25, (0,122,122), -1)
				#print("cone_center", cone_center_x, cone_center_y)
			'''
			yellow_arr = sorted(yellow_arr, key=lambda x:(x[2],x[1],x[0]))
			print("sort_yellow", yellow_arr)
			blue_arr = sorted(blue_arr, key=lambda x:(x[2],x[1],x[0]))	
			print("sort_blue", blue_arr)
			'''
			
		#cv2.imshow("display", img)

		#cv2.imshow("warp", img_transformed)
		#cv2.imshow('out_img', out_img)


		#if cv2.waitKey(1) & 0xFF <node pkg="rviz" type="rviz" name="rviz" args="-d $(find lidar_team_morai)/rviz/track_waypoint_morai.rviz" />== ord('q'):
		#	break    		
		cv2.waitKey(33)
		rate.sleep()

	cv2.destroyAllWindows()
