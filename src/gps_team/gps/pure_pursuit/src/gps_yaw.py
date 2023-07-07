#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import math
import rospy
from geometry_msgs.msg import PoseStamped
from std_msgs.msg import Float64
from ar_track_alvar_msgs.msg import AlvarMarkers
from tf.transformations import euler_from_quaternion

present_x = 0
present_y = 0
present_yaw = 0

arData = {"AX": 0.0, "AY": 0.0, "AZ": 0.0, "AW": 0.0}

def state_callback(data):
    global present_x, present_y, present_yaw, arData
    present_x = data.pose.position.x
    present_y = data.pose.position.y
  
    arData["AX"] = data.pose.orientation.x
    arData["AY"] = data.pose.orientation.y
    arData["AZ"] = data.pose.orientation.z
    arData["AW"] = data.pose.orientation.w

if __name__ == '__main__':
    rospy.init_node("pure_pursuit_gps", anonymous=True)

    rospy.Subscriber('current_pose', PoseStamped, state_callback)

    yawPub = rospy.Publisher("gps_yaw", Float64, queue_size = 1)

    rate = rospy.Rate(60)

    while not rospy.is_shutdown():

        (roll, pitch, yaw) = euler_from_quaternion((arData["AX"], arData["AY"], arData["AZ"], arData["AW"]))
        present_yaw = math.degrees(yaw) 

        yawPub.publish(present_yaw)

        rate.sleep()