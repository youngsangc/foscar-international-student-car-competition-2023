#!/usr/bin/env python
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
        rospy.init_node("my_path")
        now = datetime.now()
        #read file(Input mode)
        self.f = open(ROS_HOME + "/paths/{}-{}-{}_{}-{}.txt".format(now.year, now.month, now.day, now.hour, now.minute), 'w')

        rospy.Subscriber('utmk_coordinate', Point, self.callback)

        self.is_status = False
        self.prev_x = 0
        self.prev_y = 0

        rate = rospy.Rate(30)

        self.first_lap = False
        self.first_x = 0
        self.first_y = 0
        
        self.last_x = 0
        self.last_y = 0
        
        self.distance_from_start = 0
        self.cnt = 0

        while self.first_lap == False:
            if self.is_status:
                self.path_make()
            rate.sleep()
            
        x_list = np.linspace(self.last_x , self.first_x - 0.1 , 10)
        y_list = np.linspace(self.last_y , self.first_y - 0.1 , 10)
        for element_x , element_y in zip(x_list , y_list):
            self.f.write(str(element_x) + ' ' + str(element_y) + ' ' + '0' + '\n')

        self.f.close()

    def path_make(self):
        if self.first_x == 0 and self.first_y == 0:
            self.first_x = self.status_msg.x
            self.first_y = self.status_msg.y
        x = self.status_msg.x
        y = self.status_msg.y
        distance = sqrt(pow(x - self.prev_x , 2)+pow(y - self.prev_y , 2)) 
        
        if distance > 0.3:  
            self.f.write(str(x) + ' ' + str(y) + ' ' + '0' + '\n')
            self.prev_x = x
            self.prev_y = y
            self.cnt += 1
            print(x, y)
            print(self.distance_from_start)

        # self.f.write(str(x) + ' ' + str(y) + ' ' + '0' + '\n')
        # self.prev_x = x
        # self.prev_y = y
        # self.cnt += 1
        # print(x, y)
        # print(self.distance_from_start)
        
        self.distance_from_start = sqrt(pow(x - self.first_x, 2) + pow(y - self.first_y, 2)) #distance between start point and current point

        if self.distance_from_start < 1.5 and self.cnt > 30:  # distance where stop gathering gps points.
            self.first_lap = True
            self.last_x = x
            self.last_y = y

    


if __name__ == '__main__':
    try:
        test_track = pm()
    except rospy.ROSInterruptException:
        pass