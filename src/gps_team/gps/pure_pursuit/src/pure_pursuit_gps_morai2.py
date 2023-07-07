#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import math 
import rospy
import rospkg
import sys
import os
import signal
from nav_msgs.msg import Path,Odometry
from std_msgs.msg import Bool
from geometry_msgs.msg import PoseStamped,Point
import tf
from morai_msgs.msg import EgoVehicleStatus, CtrlCmd
from track_race.msg import Velocity, Steering

# def signal_handler(sig, frame):
#     os.system('killall -9 python rosout')
#     sys.exit(0)

# signal.signal(signal.SIGINT, signal_handler)

# Parameters
k = 0.2  # look forward gain
Lfc = 1.3 # [m] look-ahead distance
WB = 0.78  # [m] wheel base of vehicle

target_speed = 10
current_v = 6
dynamic_velocity = 7

present_x, present_y, present_yaw = 0, 0, 0

path_x = []
path_y = []

current_index = 0

txt_line_cnt = 0

MAX_VELOCITY = 18

is_one_lap_finished = False

status_msg=EgoVehicleStatus()

def statusCB(data):
    global status_msg
    status_msg=data
    # print(status_msg)
    br = tf.TransformBroadcaster()
    br.sendTransform((status_msg.position.x, status_msg.position.y, status_msg.position.z),
                    tf.transformations.quaternion_from_euler(0, 0, status_msg.heading/180*math.pi),
                    rospy.Time.now(),
                    "gps",
                    "map")
    is_status=True 

class State:

    def __init__(self, x = 0, y = 0, yaw = 0, v = current_v):
        self.x = x
        self.y = y
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

        Lf = k * current_v + Lfc  # update look ahead distance


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

    curvature = 2.0 * math.sin(alpha) / Lf

    # print("curvature = ", curvature)

    delta = math.atan2(2.0 * WB * math.sin(alpha), Lf)

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
    # previous_index = current_index

    if current_index == txt_line_cnt:
        current_index = 0

def one_lap_flag_callback(data):
    global is_one_lap_finished
    is_one_lap_finished = data.data

def dynamic_velocity_callback(msg):
    global dynamic_velocity
    dynamic_velocity = msg.velocity


if __name__ == '__main__':
    rospy.init_node("pure_pursuit_gps_morai", anonymous=True)

    rospy.Subscriber("/Ego_topic", EgoVehicleStatus, statusCB)
    rospy.Subscriber("/is_one_lap_finished", Bool, one_lap_flag_callback)
    rospy.Subscriber("/dynamic_velocity_lidar", Velocity, dynamic_velocity_callback)

    ctrlCmdPub = rospy.Publisher("ctrl_cmd", CtrlCmd, queue_size=1)
    velocityPub = rospy.Publisher("dynamic_velocity_gps", Velocity, queue_size = 1)
    steeringPub = rospy.Publisher("pure_pursuit_gps", Steering, queue_size = 1)
    velocityMsg = Velocity()
    steeringMsg = Steering()
    
    ctrl_cmd = CtrlCmd()

    rate = rospy.Rate(60)


    # Path Setting
    f = open('/home/youngsangcho/ISCC_2023/src/erp_ros/path/morai_asp.txt' , mode = 'r')

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
    
    # initial statecurrent_v

    while not rospy.is_shutdown():
        print("GPS RUN")
        state = State(x = status_msg.position.x, y = status_msg.position.y, yaw = status_msg.heading/180*math.pi, v = current_v)

        findLocalPath(path_x, path_y, state.x, state.y)

        print(current_index)

        if len(path_x) != 0:
            # Calc control input
            target_course = TargetCourse(path_x, path_y)
            target_ind, lf = target_course.search_target_index(state)

            di, target_ind, target_x, target_y = pure_pursuit_steer_control(state, target_course, target_ind)

            print("LF: ", lf)
            # print("di: ", di)

            
            current_v = dynamic_velocity * 2 # 현재 dynamic_velocity 속도 (최저: 9, 최대: 12) // 계산식 적용하면 (최저: 11, 최대: 17)
            #current_v = 0.118 * math.pow(dynamic_velocity , 2)
            # if(current_v < 10.0):
            #     current_v = 10
            print("vel : ",current_v)

            velocityMsg.velocity = current_v
            steeringMsg.steering = di * MAX_VELOCITY / current_v #* MAX_VELOCITY / current_v  # 실제 차량은 - 곱해줘야 의도한 방향으로 차량이 조향함. 100은 스케일 때문에 곱한 값

            ctrl_cmd.longlCmdType = 2
            ctrl_cmd.velocity = 6

            ctrl_cmd.steering = di * MAX_VELOCITY / current_v
            ctrlCmdPub.publish(ctrl_cmd)
            
            velocityPub.publish(velocityMsg)
            steeringPub.publish(steeringMsg)

        rate.sleep()