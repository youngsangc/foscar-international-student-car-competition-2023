#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import rospy
import rospkg
import numpy as np
from datetime import datetime
from geometry_msgs.msg import Point
from math import sqrt, pow

rospack = rospkg.RosPack()
ROS_HOME = rospack.get_path('pure_pursuit')


class pm:
    
    def callback(self, msg):
        self.is_status = True
        self.status_msg = msg
    
    def __init__(self):
        rospy.init_node("path_maker")
        now = datetime.now()
        #read file(Input mode)
        self.f = open(ROS_HOME + "/paths/{}-{}-{}_{}-{}.txt".format(now.year, now.month, now.day, now.hour, now.minute), 'w')

        rospy.Subscriber('utmk_coordinate', Point, self.callback)

        self.is_status = False
        self.prev_x = 0
        self.prev_y = 0

        self.idx = 0

        rate = rospy.Rate(30)

        while not rospy.is_shutdown():
            if self.is_status:
                self.path_make()
            rate.sleep()
            
        self.f.close()

    def path_make(self):
        x = self.status_msg.x
        y = self.status_msg.y
        distance = sqrt(pow(x - self.prev_x , 2)+pow(y - self.prev_y , 2)) 
        
        if distance > 0.2:  
            self.f.write(str(x) + ' ' + str(y) + ' ' + '5' + '\n')
            self.prev_x = x
            self.prev_y = y
            self.idx += 1
            print(self.idx, x, y)

    


if __name__ == '__main__':
    try:
        test_track = pm()
    except rospy.ROSInterruptException:
        pass
