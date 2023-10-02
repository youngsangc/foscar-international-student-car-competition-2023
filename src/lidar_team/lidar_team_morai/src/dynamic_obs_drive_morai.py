#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys,os
import rospy
import rospkg
import numpy as np
from morai_msgs.msg import EgoVehicleStatus,CtrlCmd
from std_msgs.msg import Bool
import tf
from math import cos, sin, sqrt, pow, atan2, pi
import time

from lidar_team_morai.msg import Boundingbox


class drive():
    def __init__(self):
        rospy.init_node('dy_morai_drive', anonymous=True)
        
        self.is_obs_detected_long = False
        self.is_obs_detected = False
        
        OK = False

        self.obs_y = 0.0

        #publisher
        ctrl_pub = rospy.Publisher('/ctrl_cmd',CtrlCmd, queue_size=1)

        ctrl_msg= CtrlCmd() 
        
        #subscriber
        rospy.Subscriber("/Ego_topic", EgoVehicleStatus, self.statusCB)
        rospy.Subscriber("/dynamic_obs_flag_long", Bool, self.dy_long_callback)
        rospy.Subscriber("/dynamic_obs_flag_short", Bool, self.dy_callback)

        rospy.Subscriber("/dynamic_obs_position", Boundingbox, self.dy_pos_callback)

        self.status_msg=EgoVehicleStatus()

        rate = rospy.Rate(60)
        ctrl_msg.longlCmdType = 2

        while not rospy.is_shutdown():
            if self.is_obs_detected and not OK:
                first_obs_y = self.obs_y
                while self.is_obs_detected:
                    if (first_obs_y * self.obs_y) < 0:
                        if (first_obs_y > 0 and self.obs_y < -1) or (first_obs_y < 0 and self.obs_y > 1):
                            print("NO WARNING")
                            OK = True
                            break
                    ctrl_msg.velocity = 0
                    ctrl_msg.steering = 0
                    ctrl_msg.brake = 1

                    ctrl_pub.publish(ctrl_msg)
                    rate.sleep()

            elif self.is_obs_detected_long:
                ctrl_msg.velocity = 5
                ctrl_msg.steering = 0
                ctrl_msg.brake = 0

            else:
                ctrl_msg.velocity = 15
                ctrl_msg.steering = 0
                ctrl_msg.brake = 0
            
            if OK:
                ctrl_msg.velocity = 20
                ctrl_msg.steering = 0
                ctrl_msg.brake = 0
                ctrl_pub.publish(ctrl_msg)

                time.sleep(3)
                OK = False

            ctrl_pub.publish(ctrl_msg)

            rate.sleep()
        
    def statusCB(self,data):
        self.status_msg=EgoVehicleStatus()
        self.status_msg=data
        br = tf.TransformBroadcaster()
        br.sendTransform((self.status_msg.position.x, self.status_msg.position.y, self.status_msg.position.z),
                        tf.transformations.quaternion_from_euler(0, 0, self.status_msg.heading/180*pi),
                        rospy.Time.now(),
                        "gps",
                        "map")
        self.is_status=True

    def dy_long_callback(self, msg):
        self.is_obs_detected_long = msg.data

    def dy_callback(self, msg):
        self.is_obs_detected = msg.data
    
    def dy_pos_callback(self, msg):
        self.obs_y = msg.y

if __name__ == '__main__':
    try:
        drive = drive()
    except rospy.ROSInterruptException:
        pass

