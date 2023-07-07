#!/usr/bin/env python

from xml.dom.pulldom import START_DOCUMENT
import cv2
import rospy
import numpy as np
from darknet_ros_msgs.msg import BoundingBox, BoundingBoxes
from vision_distance.msg import Delivery, DeliveryArray
from sensor_msgs.msg import Image
from cv_bridge import CvBridge
from delivery_mission.msg import drive_values
import time
from datetime import datetime

now = datetime.now()

bridge = CvBridge()
usleep = lambda x: time.sleep(x/1000000.0)

rospy.init_node("go_straight")
drive_values_pub = rospy.Publisher('control_value', drive_values, queue_size=1)

car_run_speed = 6 #4
max_speed = 8 #5

a_max_index = 1
b_max_index = -1

b_cnt = [-1,-1,-1]
a_flag = [False,True,False]
b_flag = [False,False,False]
mission_flag = 1

# min a dist
min_b_dist = 99999999

def delivery_callback(msg):
	global flag
	global min_b_dist
	global mission_flag
	global dist_x
	global dist_y
	global b_cnt, b_max_index, b_flag
	
	deliverySign = msg.visions
	
	sorted_data_list = sorted(deliverySign, key=lambda x:(x.dist_y, x.dist_x))
	#print(len(data_list))
	if len(sorted_data_list):
		print("* CLOSEST B FLAG : ", sorted_data_list[0].flag)
	else:
		print("* Not Detected ")
	
	for i in range(1,len(deliverySign)):
		if deliverySign[i].dist_y < sorted_data_list[0].dist_y:
			sorted_data_list[0] = deliverySign[i] 
			print("sorted_data_list::::", sorted_data_list)
	
	
	if sorted_data_list[0].dist_y > 450 and sorted_data_list[0].dist_y < 850:
		if (sorted_data_list[0].flag == 1):
			b_cnt[0] += 1
		if (sorted_data_list[0].flag == 2):
			b_cnt[1] += 1
		if (sorted_data_list[0].flag == 3):
			b_cnt[2] += 1
		if sorted_data_list[0].dist_y < min_b_dist:
			min_b_dist = sorted_data_list[0].dist_y
			# print("yaaaaaaaaaaaaa@@@@@@@@@", min_b_dist)
		print(b_cnt)
	else:
		min_b_dist = 99999999

def image_callback(img_data):
	global bridge
	global img
	img = bridge.imgmsg_to_cv2(img_data, "bgr8")


def auto_drive():
	global car_run_speed
	global max_speed
	global mission_flag
	global min_b_dist
	global b_cnt, b_flag
	global b_max_index
	drive_value = drive_values()

	drive_value.throttle = int(car_run_speed)
	drive_value.steering = 0.0
	drive_values_pub.publish(drive_value)
	
	print("mission_flag : ", mission_flag)
	
	if mission_flag == 1 and min_b_dist < 850 :
		# calc flag
		if ((b_cnt[0] + b_cnt[1] + b_cnt[2]) != -3):
			b_max_index = np.argmax(b_cnt) 
			print(":::::::::::::::::::::::::", b_max_index)

		mission_flag = 2
		#drive_values_pub.publish(drive_value)
	
	elif mission_flag == 2:
		if a_flag[b_max_index] == True: 
			for i in range (0, 200):
				print("!!!!!!!!!mission2!!!!!!!!!!")
				usleep(10000)
				drive_value.throttle = int(car_run_speed)
				drive_value.steering = 0
				drive_values_pub.publish(drive_value)
			mission_flag = 3
		elif a_flag[b_max_index] != True:
			mission_flag = 1
		print("MIN_B_DIST :   ", min_b_dist)
		if min_b_dist > 850 :
			print("850!!!!!!!!!!!!!!!!!!!!!!!!")
			min_b_dist = 99999999
			b_cnt = [0,0,0]

		
		
	elif mission_flag == 3:
		for i in range (0, 200):
			print("!!!!!!!!!!!!mission3!!!!!!!!!!!!!!!")
			usleep(10000)
			drive_value.throttle = 0 #int(car_run_speed)
			drive_value.steering = 0
			drive_values_pub.publish(drive_value)
		mission_flag = 4
	elif mission_flag == 4:
		drive_value.throttle = int(car_run_speed)
		drive_value.steering = 0
		drive_values_pub.publish(drive_value)
	#drive_value.throttle = int(car_run_speed)
	#drive_values_pub.publish(drive_value)

    #drive_values_pub.publish(drive_value)
    #print("steer : ", drive_value.steering)
    #print("throttle : ", drive_value.throttle)



if __name__ == "__main__":
	image_sub = rospy.Subscriber("/usb_cam/image_raw/", Image, image_callback)
	delivery_sub = rospy.Subscriber("/delivery", DeliveryArray, delivery_callback) 
	
	while not rospy.is_shutdown():
		auto_drive()
		rospy.sleep(0.05)