#!/usr/bin/env python

import cv2
import rospy
import numpy as np
from darknet_ros_msgs.msg import BoundingBox, BoundingBoxes
from vision_distance.msg import Delivery, DeliveryArray
from sensor_msgs.msg import Image
from cv_bridge import CvBridge
from race.msg import drive_values
import time
from datetime import datetime

now = datetime.now()

bridge = CvBridge()
usleep = lambda x: time.sleep(x/1000000.0)

rospy.init_node("go_straight")
drive_values_pub = rospy.Publisher('control_value', drive_values, queue_size=1)

car_run_speed = 4
max_speed = 5

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
	
	min_deliverySign = deliverySign[0]
	
	
	for i in range(1,len(deliverySign)):
		'''
		print("#############dist##############",deliverySign[i].dist_y)
		if (deliverySign[i].dist_y > 600 and deliverySign[i].dist_y < 850):
			if (deliverySign[i].flag == 1):
			    b_cnt[0] += 1
			if (deliverySign[i].flag == 2):
			    b_cnt[1] += 1
			if (deliverySign[i].flag == 3):
		  	    b_cnt[2] += 1
			if deliverySign[i].dist_y < min_b_dist:
				min_b_dist = deliverySign[i].dist_y
		print("total-----------B_CNT???", b_cnt)
		'''
		if deliverySign[i].dist_y < min_deliverySign.dist_y:
			min_deliverySign = deliverySign[i] 
	
	
	if min_deliverySign.dist_y > 600 and min_deliverySign.dist_y < 850:
		if (min_deliverySign.flag == 1):
			b_cnt[0] += 1
		if (min_deliverySign.flag == 2):
			b_cnt[1] += 1
		if (min_deliverySign.flag == 3):
			b_cnt[2] += 1
		if min_deliverySign.dist_y < min_b_dist:
			min_b_dist = min_deliverySign.dist_y
		print(b_cnt)
	
	'''
	if ((b_cnt[0] + b_cnt[1] + b_cnt[2]) != -3):
		b_max_index = np.argmax(b_cnt)
		print("%%%%%%%%%%%%%%%%%%%%%%%", b_max_index)

		if (a_max_index == b_max_index):
			b_flag[b_max_index] = True
		else:
			b_cnt = [0,0,0]
	
	print("MAX_INDEX???", b_max_index)
	#print("B_CNT???", b_cnt)
	print("B_FLAG???", b_flag)
	'''
	'''
	if mission_flag == 1 and (min_b_dist < 700):
		#mission_flag = 2
		# calc flag
		if ((b_cnt[0] + b_cnt[1] + b_cnt[2]) != -3):
			b_max_index = np.argmax(b_cnt)
			print("%%%%%%%%%%%%%%%%%%%%%%%", b_max_index)
		if (a_max_index == b_max_index):
			b_flag[b_max_index] = True
			mission_flag = 2
		else:
			b_cnt = [0,0,0]
			min_b_dist = 99999999
	'''
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
	
	if mission_flag == 1 and (min_b_dist < 550):
		if min_b_dist < 550:
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
			print("750000000000000000000000000000")
			print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
		# calc flag
		if ((b_cnt[0] + b_cnt[1] + b_cnt[2]) != -3):
			b_max_index = np.argmax(b_cnt)
			print("%%%%%%%%%%%%%%%%%%%%%%%", b_max_index)
		if (a_max_index == b_max_index):
			b_flag[b_max_index] = True
			mission_flag = 2
		else:
			# mission_flag = 1
			b_cnt = [0,0,0]
			min_b_dist = 99999999
		drive_values_pub.publish(drive_value)
	
	elif mission_flag == 2:
	    if(a_flag[0] and b_flag[0]) or (a_flag[1] and b_flag[1]) or (a_flag[2] and b_flag[2]):
			for i in range (0, 200):
				print("---------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -----")
				usleep(10000)
				drive_value.throttle = int(car_run_speed)
				drive_value.steering = 0
				drive_values_pub.publish(drive_value)
			mission_flag = 3
	elif mission_flag == 3:
		for i in range (0, 200):
			print("---------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -----")
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
    delivery_sub = rospy.Subscriber("/delivery/", DeliveryArray, delivery_callback) 
    out = cv2.VideoWriter('/home/foscar/ISCC_2021/src/vision_distance/src/9-16/origin_{}-{}-{}-{}-{}.avi'.format(now.year,now.month, now.day, now.hour, now.minute), cv2.VideoWriter_fourcc(*'MJPG'),30,(640,480))

    while not rospy.is_shutdown():
	try:
		out.write(img)
	except:
		pass
	auto_drive()
	rospy.sleep(0.05)

    
