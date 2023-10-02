#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import math
import rospy
import rospkg
import sys
import os
import signal
from geometry_msgs.msg import PoseStamped
from std_msgs.msg import Bool, Float64
from ar_track_alvar_msgs.msg import AlvarMarkers
from tf.transformations import euler_from_quaternion
from track_race.msg import Velocity, Steering

# 0824
# 최저 속도 10 최고 속도 15 -> k = 0.6 Lfc = -1.5

# 0823 equal to lidar
# k = 0.2875  # look forward gain // 0.25
# Lfc = 1.35 # [m] look-ahead distance     // 3.2
# WB = 1.04  # [m] wheel base of vehicle

# Parameters
# 최종값 k = 0.095 Lfc = 2.85
# k = 0.4  # look forward gain // 0.25 4.85 6.6
# Lfc = 1.0 # [m] look-ahead distance     // 3.2
# WB = 1.04  # [m] wheel base of vehicle

k = 0.3  # look forward gain // 0.25 4.85 6.6
Lfc = 1.5 # [m] look-ahead distance     // 3.2
WB = 1.04  # [m] wheel base of vehicle


# k = 0.35  # look forward gain // 0.25
# Lfc = 1.6 # [m] look-ahead distance     // 3.2
# WB = 1.04  # [m] wheel base of vehicle

target_speed = 10
dynamic_velocity = 7
MAX_VELOCITY = 13
current_velocity = 0
throttle = 0

present_x = 0
present_y = 0
present_yaw = 0

path_x = []
path_y = []

current_index = 0

txt_line_cnt = 0

arData = {"AX": 0.0, "AY": 0.0, "AZ": 0.0, "AW": 0.0}

is_one_lap_finished = False

class State:

    def __init__(self, x = present_x, y = present_y, yaw = present_yaw / 180 * math.pi, v = current_velocity):
        self.x = x #+ 0.42
        self.y = y #+ 0.08
        self.yaw = yaw
        self.v = v
        self.rear_x = self.x - ((WB / 2) * math.cos(self.yaw))
        self.rear_y = self.y - ((WB / 2) * math.sin(self.yaw))

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
        global txt_line_cnt
  
        # To speed up nearest point search, doing it at only first time.  
        if self.old_nearest_point_index is None:
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

        Lf = k * current_velocity + Lfc  # update look ahead distance


        # search look ahead target point index
        while Lf > state.calc_distance(self.cx[ind], self.cy[ind]):
            if (ind + 1) >= len(self.cx):
                break  # not exceed goal
            ind += 1

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

    delta = math.atan2(2.0 * WB * math.sin(alpha), Lf) * 1.0

    return delta, ind, tx, ty


def findLocalPath(path_x, path_y, state_x, state_y): ## global_path와 차량의 status_msg를 이용해 현재waypoint와 local_path를 생성 ##
    global current_index, previous_index, txt_line_cnt

    current_x = state_x
    current_y = state_y
    min_dis = float('inf')

    for i in range(txt_line_cnt) :
        dx = current_x - path_x[i]
        dy = current_y - path_y[i]
        dis = math.sqrt(dx*dx + dy*dy)
        if dis < min_dis :
            min_dis = dis
            current_index = i

    if current_index == txt_line_cnt:
        current_index = 0


def state_callback(data):
    global present_x, present_y, present_yaw, arData
    present_x = data.pose.position.x
    present_y = data.pose.position.y
  
    arData["AX"] = data.pose.orientation.x
    arData["AY"] = data.pose.orientation.y
    arData["AZ"] = data.pose.orientation.z
    arData["AW"] = data.pose.orientation.w


def one_lap_flag_callback(data):
    global is_one_lap_finished
    is_one_lap_finished = data.data

def dynamic_velocity_callback(msg):
    global dynamic_velocity
    dynamic_velocity = msg.velocity

def current_velocity_callback(msg):
    global current_velocity
    current_velocity = msg.data
    # state.v = msg.data


if __name__ == '__main__':
    rospy.init_node("pure_pursuit_gps", anonymous=True)

    rospy.Subscriber('current_pose', PoseStamped, state_callback)
    rospy.Subscriber("/is_one_lap_finished", Bool, one_lap_flag_callback)
    rospy.Subscriber("/dynamic_velocity_lidar", Velocity, dynamic_velocity_callback)
    rospy.Subscriber("/gps_velocity", Float64, current_velocity_callback)

    velocityPub = rospy.Publisher("dynamic_velocity_gps", Velocity, queue_size = 1)
    steeringPub = rospy.Publisher("pure_pursuit_gps", Steering, queue_size = 1)
    velocityMsg = Velocity()
    steeringMsg = Steering()

    rate = rospy.Rate(60)

    while is_one_lap_finished == False:
        continue

    # Path Setting
    f = open('/home/foscar/ISCC_2023/src/gps_team/gps/pure_pursuit/paths/gps_track_path.txt' , mode = 'r')

    line = f.readline()
    first_line = line.split()
    path_x.append(float(first_line[0]))
    path_y.append(float(first_line[1]))

    while line:
        line = f.readline()
        tmp = line.split()

        txt_line_cnt += 1

        if len(tmp) != 0:
            path_x.append(float(tmp[0]))
            path_y.append(float(tmp[1]))
    f.close()

    path_x *= 2
    path_y *= 2

    # initial state
    print("@@@@@@@@@@@@@@@@@@@@@@@ GPS RUN @@@@@@@@@@@@@@@@@@@@@@@")
    while not rospy.is_shutdown():
        # print("GPS RUN")

        (roll, pitch, yaw) = euler_from_quaternion((arData["AX"], arData["AY"], arData["AZ"], arData["AW"]))
        present_yaw = math.degrees(yaw)

        state = State(x = present_x, y = present_y, yaw = present_yaw / 180 * math.pi, v = current_velocity)

        findLocalPath(path_x, path_y, state.x, state.y)
        
        if len(path_x) != 0:
            # Calc control input
            target_course = TargetCourse(path_x, path_y)
            target_ind, _ = target_course.search_target_index(state)
            
            di, target_ind, target_x, target_y = pure_pursuit_steer_control(state, target_course, target_ind)
            
            # print("Lf = ", _)
            # print("di = ", di)

            throttle = dynamic_velocity * 2 - 9 # 현재 dynamic_velocity 속도 (최저: 9, 최대: 12) // 계산식 적용하면 (최저: 10, 최대: 15)
            if(throttle < 10.0):
                throttle = 10

            velocityMsg.velocity = throttle
            steeringMsg.steering = di * -100 #* MAX_VELOCITY / current_v  # 실제 차량은 - 곱해줘야 의도한 방향으로 차량이 조향함. 100은 스케일 때문에 곱한 값

            velocityPub.publish(velocityMsg)
            steeringPub.publish(steeringMsg)

        rate.sleep()