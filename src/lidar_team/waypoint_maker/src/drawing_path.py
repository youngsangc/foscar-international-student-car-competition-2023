#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from threading import local
import numpy as np
from std_msgs.msg import Float64,Int16,Float32MultiArray
import rospy
import rospkg
import tf
from visualization_msgs.msg import Marker
from visualization_msgs.msg import MarkerArray
from waypoint_maker.msg import Waypoint

linspace_num = 200

class drawing_path():
    def __init__(self):
        global linspace_num

        rospy.init_node('linspace')
        pub1 = rospy.Publisher('waypoint_linspace', MarkerArray, queue_size = 1)
        pub2 = rospy.Publisher('local_path', Waypoint, queue_size = 1)
        rospy.Subscriber('/waypoint_info', Waypoint, self.callback)
        self.x_array = []
        self.y_array = []
        array = [[] for _ in range(linspace_num)]

        rate = rospy.Rate(60)

        while not rospy.is_shutdown():
            
            local_path = Waypoint()

            if len(self.x_array) > 1 and len(self.y_array) > 1:

                x = self.x_array
                y = self.y_array
                cnt = self.cnt - 1

                try:
                    z = np.polyfit(x, y, 2)
                except:
                    pass
                p = np.poly1d(z)

                # print(2*z[0] + z[1])
                 
                # evaluate on new data points
                x_new = np.linspace(min(x), max(x), 200)
                y_new = p(x_new)

                for i in range(linspace_num):
                    array[i] = [x_new[i], y_new[i]]
                
                #1006
                # waypoint_marker_arr = MarkerArray()
                # for i in range(linspace_num):
                #     marker = Marker()
                #     marker.header.frame_id = "/velodyne"
                #     marker.id = i
                #     marker.type = marker.SPHERE
                #     marker.action = marker.ADD
                #     marker.scale.x = 0.05
                #     marker.scale.y = 0.05
                #     marker.scale.z = 0.05
                #     marker.color.a = 1.0
                #     marker.color.r = 0.0
                #     marker.color.g = 1.0
                #     marker.color.b = 0.0
                #     marker.pose.orientation.w = 1.0
                #     marker.pose.position.x = array[i][0]
                #     marker.pose.position.y = array[i][1]
                #     marker.pose.position.z = 0.2
                #     marker.lifetime = rospy.Duration(0.1)
                #     waypoint_marker_arr.markers.append(marker)

                for i in range(linspace_num):
                    local_path.x_arr[i] = array[i][0]
                    local_path.y_arr[i] = array[i][1]

                #1006
                # pub1.publish(waypoint_marker_arr)
                pub2.publish(local_path)

            rate.sleep()


    def callback(self, msg):
        self.x_array = list(msg.x_arr)[0:msg.cnt]
        self.y_array = list(msg.y_arr)[0:msg.cnt]
        self.cnt = msg.cnt
        self.x_array.insert(0, -1.1)
        self.y_array.insert(0, 0)


if __name__ == '__main__':
    try:
        drawing = drawing_path()
    except rospy.ROSInterruptException:
        pass
