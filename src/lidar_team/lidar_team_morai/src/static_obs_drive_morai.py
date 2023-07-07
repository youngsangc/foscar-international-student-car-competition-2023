#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys,os
import rospy
import rospkg
import numpy as np
from morai_msgs.msg import EgoVehicleStatus,CtrlCmd
from std_msgs.msg import Bool
import tf
import time
from math import cos, sin, sqrt, pow, atan2, pi



class drive():
    def __init__(self):
        rospy.init_node('static_morai_drive', anonymous=True)
        
        self.is_obs_detected_long = False
        self.is_obs_detected = False
        self.steering_flag = 1

        #publisher
        ctrl_pub = rospy.Publisher('/ctrl_cmd',CtrlCmd, queue_size=1)

        ctrl_msg= CtrlCmd() 
        
        #subscriber
        rospy.Subscriber("/Ego_topic", EgoVehicleStatus, self.statusCB)
        rospy.Subscriber("/static_obs_flag_long", Bool, self.st_long_callback)
        rospy.Subscriber("/static_obs_flag_short", Bool, self.st_callback)

        self.status_msg=EgoVehicleStatus()

        rate = rospy.Rate(60)
        ctrl_msg.longlCmdType = 2

        while not rospy.is_shutdown():
            if self.is_obs_detected_long:
                ctrl_msg.velocity = 10
                ctrl_msg.steering = 0

            elif self.is_obs_detected:
                while(self.is_obs_detected == True):
                    ctrl_msg.velocity = 5
                    ctrl_msg.steering = -15
                    
                    ctrl_pub.publish(ctrl_msg)
                    
                    rate.sleep()
                    time.sleep(2)
                    

                while(self.is_obs_detected == False):
                    ctrl_msg.velocity = 10
                    ctrl_msg.steering = 0.1
                    
                    ctrl_pub.publish(ctrl_msg)
                    
                    rate.sleep()
                    time.sleep(1)
                    
                    ctrl_msg.velocity = 10
                    ctrl_msg.steering = 0.0
                    
                    ctrl_pub.publish(ctrl_msg)
                    
                    rate.sleep()
                    time.sleep(1)

                while(self.is_obs_detected == True):
                
                    ctrl_msg.velocity = 5
                    ctrl_msg.steering = 15
                    
                    ctrl_pub.publish(ctrl_msg)

                    rate.sleep()
                    time.sleep(2)

                while(self.is_obs_detected == False):
                    ctrl_msg.velocity = 20
                    ctrl_msg.steering = -0.2
                    
                    ctrl_pub.publish(ctrl_msg)

                    rate.sleep()

            else:
                ctrl_msg.velocity = 15
                ctrl_msg.steering = 0

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

    def st_long_callback(self, msg):
        self.is_obs_detected_long = msg.data

    def st_callback(self, msg):
        self.is_obs_detected = msg.data

if __name__ == '__main__':
    try:
        drive = drive()
    except rospy.ROSInterruptException:
        pass

