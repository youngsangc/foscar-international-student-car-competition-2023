#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# from ast import Starred
import numpy as np
import math
import rospy
import sys
import os
import signal

from nav_msgs.msg import Path,Odometry
from std_msgs.msg import Bool, Float64,Int16,Float32MultiArray
from geometry_msgs.msg import PoseStamped,Point

from visualization_msgs.msg import Marker
from visualization_msgs.msg import MarkerArray
from lidar_team_erp42.msg import Waypoint
from track_race.msg import Velocity
from track_race.msg import Steering

# Parameters
# 도로 폭이 좁을 때 k = 0.09 Lfc = 2.25
# 도록 폭이 넓을 때 k = 0.09 Lfc = 2.5
k = 0.22  # look forward gain 0.09
Lfc = 1.75 # [m] look-ahead distance 2.25
WB = 1.04  # [m] wheel base of vehicle

# k = 0.09, Lfc = 2.5 KYUHYUN

target_speed = 10
speed = 10

path_x = []
path_y = []
current_velocity = 0

gpsVel = 0
realVel = 15
is_one_lap_finished = False

class State:

    def __init__(self, x = -1.1, y = 0.0, yaw = 0.0, v = 0.0):
        self.yaw = yaw
        self.v = v
        self.rear_x = x
        self.rear_y = y

    def calc_distance(self, point_x, point_y):
        dx = self.rear_x - point_x
        dy = self.rear_y - point_y

        return math.hypot(dx, dy)


class TargetCourse:

    def __init__(self, cx, cy):
        self.cx = cx
        self.cy = cy
        self.old_nearest_point_index = None
 

    def search_target_index(self, state):
        global realVel, gpsVel
        # To speed up nearest point search, doing it at only first time.  
        if self.old_nearest_point_index is None:
            # search nearest point index

            dx = [state.rear_x - icx for icx in self.cx]
            dy = [state.rear_y - icy for icy in self.cy]
            d = np.hypot(dx, dy)

            ind = np.argmin(d)
            self.old_nearest_point_index = ind
        else:
            ind = self.old_nearest_point_index
            distance_this_index = state.calc_distance(self.cx[ind], self.cy[ind])
            while True:
                distance_next_index = state.calc_distance(self.cx[ind + 1], self.cy[ind + 1])

                if distance_this_index < distance_next_index + 1:
                    break
                
                if (ind + 1) < len(self.cx):
                    ind = ind + 1
                else:
                    ind = ind 
                distance_this_index = distance_next_index
            self.old_nearest_point_index = ind

        Lf = k * gpsVel + Lfc  # update look ahead distance
        # Lf = Lfc

        # search look ahead target point index
        while Lf > state.calc_distance(self.cx[ind], self.cy[ind]):
            if (ind + 1) >= len(self.cx):
                break  # not exceed goal
            ind += 1

        # print("LF:", Lf)

        return ind, Lf


def pure_pursuit_steer_control(state, trajectory, pind):
    ind, Lf = trajectory.search_target_index(state)

    if pind >= ind:
        ind = pind

    if ind < len(trajectory.cx):
        tx = trajectory.cx[ind]
        ty = trajectory.cy[ind]
    else:  # toward goal
        tx = trajectory.cx[-1]
        ty = trajectory.cy[-1]
        ind = len(trajectory.cx) - 1

    alpha = math.atan2(ty - state.rear_y, tx - state.rear_x) - state.yaw

    delta = math.atan2(2.0 * WB * math.sin(alpha), Lf) * -100 #* 1.1

    curvature = 2.0 * math.sin(alpha) / Lf

    # print("Curvature : ", curvature)

    return delta, ind, tx, ty

def path_callback(data):
    global path_x, path_y
    path_x = data.x_arr
    path_y = data.y_arr

def ego_callback(data):
    global current_velocity
    current_velocity = data.velocity.x

def publishSteering(di):
    steeringMsg.steering = di
    motor_pub.publish(steeringMsg)

def gps_velocity_callback(msg):
    global gpsVel
    gpsVel = msg.data

def velocity_callback(msg):
    global realVel
    realVel = msg.velocity

def one_lap_flag_callback(data):
    global is_one_lap_finished
    is_one_lap_finished = data.data

if __name__ == '__main__':
    rospy.init_node("pure_pursuit_lidar", anonymous=True)

    rospy.Subscriber("/gps_velocity", Float64, gps_velocity_callback)

    rospy.Subscriber("/local_path", Waypoint, path_callback) 
    rospy.Subscriber("/dynamic_velocity_lidar", Velocity, velocity_callback)
    rospy.Subscriber("/is_one_lap_finished", Bool, one_lap_flag_callback)

    motor_pub = rospy.Publisher("/pure_pursuit_lidar", Steering, queue_size = 1)
    target_pub = rospy.Publisher("/target_point", Marker, queue_size = 1)
    steeringMsg = Steering()

    rate = rospy.Rate(60)
    print("###################### LiDAR RUN ######################")
    # initial state
    if is_one_lap_finished == False:
        while not rospy.is_shutdown():
            # print("LiDAR RUN")

            state = State(x = -1.1, y = 0.0, yaw = 0.0, v = gpsVel)
            
            if len(path_x) != 0:
                # Calc control input
                target_course = TargetCourse(path_x, path_y)
                target_ind, _ = target_course.search_target_index(state)
                
                di, target_ind, target_x, target_y = pure_pursuit_steer_control(state, target_course, target_ind)

                #1006
                marker = Marker()
                marker.header.frame_id = "/velodyne"
                marker.id = 1004
                marker.type = marker.SPHERE
                marker.action = marker.ADD
                marker.scale.x = 1.0
                marker.scale.y = 1.0
                marker.scale.z = 1.0
                marker.color.a = 1.0
                marker.color.r = 1.0
                marker.color.g = 0.0
                marker.color.b = 1.0
                marker.pose.orientation.w = 1.0
                marker.pose.position.x = target_x + 1.1
                marker.pose.position.y = target_y
                marker.pose.position.z = 0.0

                marker.lifetime = rospy.Duration(0.1)

                target_pub.publish(marker)
            
                publishSteering(di)

                
                # print("Di: ", di)
                # print("LF :: ", _)

            if is_one_lap_finished == True:
                break

            rate.sleep()
