#!/usr/bin/python
#-*- encoding: utf-8 -*-

import cv2, rospy, time
import numpy as np
import math

from sensor_msgs.msg import Image
from cv_bridge import CvBridge

bridge = CvBridge()
img = np.empty(shape=[0])

pixel = 80.0/100.0 # 0.4cm
center = np.array([288,480,1], np.float32)
invisible_distance = 207

up_left = [227,313]
up_right = [346,313]
down_left = [212,383]
down_right = [362,383]

matrix_path = '/home/foscar/ISCC_2021/src/vision_distance/src/ISCC_2021_Vision/yesun/matrix'


def image_callback(img_data):
	global bridge
	global img
	img = bridge.imgmsg_to_cv2(img_data, "bgr8")

# get matrix
def get_matrix(image, ul, ur, dl, dr):
	corner_points_array = np.float32([ul, ur, dl, dr])
	
	# visualization
	cv2.circle(img, (227,313), 5, (255,0,0), -1) # up_left
    	cv2.circle(img, (346,313), 5, (0,255,0), -1) # up_right
    	cv2.circle(img, (212,383), 5, (0,0,255), -1) # down_left
    	cv2.circle(img, (362,383), 5, (0,0,0), -1) # down_right
	
	# Create an array with the parameters (the dimensions) required to build the matrix
	img_up_left = [450,650]#[220,150] #[400,600]
	img_up_right = [550,650]#[420,150] #[600,600]
	img_down_left = [450,750]#[220,350] #[600,800]
	img_down_right = [550,750]#[420,350] #[400,800]
	img_params = np.float32([img_up_left, img_up_right, img_down_left, img_down_right])

    	# Compute and return the transformation matrix
    	matrix = cv2.getPerspectiveTransform(corner_points_array, img_params)
    	print("matrix", matrix)

	return matrix


if __name__ == '__main__':
	rospy.init_node('warp')
	rospy.Subscriber("/usb_cam/image_raw/", Image, image_callback)
	while not rospy.is_shutdown():
		if img.size != (640*480*3):
                    continue
		
		width = 1000
	    	height = 1000

		matrix = get_matrix(img, up_left, up_right, down_left, down_right)
	    	img_transformed = cv2.warpPerspective(img, matrix, (width,height))
		np_matrix = np.array(matrix)
		
		# save matrix 
		np.save(matrix_path, np_matrix)
		

    		cv2.imshow("display", img)
    		cv2.imshow("warp", img_transformed)
    		cv2.waitKey(33)

	cv2.destroyAllWindows()
