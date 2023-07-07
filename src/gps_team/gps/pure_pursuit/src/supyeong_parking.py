#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 19.2205085754	 1121.95605469	 0    214
# 16.806552887	 1117.64306641 	 0    260
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
import tf, time
from morai_msgs.msg import EgoVehicleStatus, CtrlCmd
from track_race.msg import Velocity, Steering

# def signal_handler(sig, frame):
#     os.system('killall -9 python rosout')
#     sys.exit(0)

# signal.signal(signal.SIGINT, signal_handler)

# Parameters
k = 0.2  # look forward gain
Lfc = 1.8 # [m] look-ahead distance
WB = 0.78  # [m] wheel base of vehicle

target_speed = 5
current_v = 5

present_x, present_y, present_yaw = 0, 0, 0

path_x = []
path_y = []

current_index = 0

txt_line_cnt = 0

MAX_VELOCITY = 5

isParkingRubberCone = True
# initial statecurrent_v
check_point_list = [95, 116, 138, 159]
check_point_index = 0
once_flag = True
parking_available = False

status_msg=EgoVehicleStatus()

def parkingRubberConeCallback(data):
    global isParkingRubberCone
    isParkingRubberCone = data.data

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
    min_dis = 99999999999999999

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


if __name__ == '__main__':
    rospy.init_node("pure_pursuit_gps_morai", anonymous=True)

    rospy.Subscriber("/Ego_topic", EgoVehicleStatus, statusCB)
    rospy.Subscriber("/is_parking_rubbercone", Bool, parkingRubberConeCallback)

    ctrl_pub = rospy.Publisher("ctrl_cmd", CtrlCmd, queue_size = 1)
   
    ctrl_msg = CtrlCmd()

    rate = rospy.Rate(60)

    # Path Setting
    f = open('/home/foscar/ISCC_2022/src/erp_ros/path/supyeong.txt' , mode = 'r')

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
    


    while not rospy.is_shutdown():
        state = State(x = status_msg.position.x, y = status_msg.position.y, yaw = status_msg.heading/180*math.pi, v = current_v)

        findLocalPath(path_x, path_y, state.x, state.y)

        # print(current_index)

        ctrl_msg.longlCmdType = 2
        print(check_point_list[check_point_index], current_index)
        if (check_point_list[check_point_index] == current_index):
            if (isParkingRubberCone == False):
                print("주차가능")
                parking_available = True
            elif (isParkingRubberCone == True and once_flag):
                print("주차불가능")
                once_flag = False
                parking_available = False
                check_point_index = (check_point_index + 1) % 4
        else:
            print("주차탐색")
            once_flag = True




        if (check_point_list[check_point_index + 1] == current_index and parking_available):
            ctrl_msg.velocity = 5
            ctrl_msg.steering = 15.0
            ctrl_msg.brake = 0.0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(0.4)    

            ctrl_msg.velocity = 0.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 1
            ctrl_pub.publish(ctrl_msg)
            time.sleep(5)

            ctrl_msg.velocity = 5.0
            ctrl_msg.steering = -30
            ctrl_msg.brake = 0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(3)
            
            ctrl_msg.velocity = 0.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 1
            ctrl_pub.publish(ctrl_msg)
            time.sleep(1)

            ctrl_msg.velocity = 5.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 0.0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(0.3)

            ctrl_msg.velocity = 5.0
            ctrl_msg.steering = 30
            ctrl_msg.brake = 0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(3)
            
            ctrl_msg.velocity = 0.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 1
            ctrl_pub.publish(ctrl_msg)
            time.sleep(10)

            #################################################

            ctrl_msg.velocity = 5.0
            ctrl_msg.steering = 30
            ctrl_msg.brake = 0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(3)
            
            ctrl_msg.velocity = 0.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 1
            ctrl_pub.publish(ctrl_msg)
            time.sleep(1)

            ctrl_msg.velocity = 5.0
            ctrl_msg.steering = -30
            ctrl_msg.brake = 0
            ctrl_pub.publish(ctrl_msg)
            time.sleep(3)
            
            ctrl_msg.velocity = 0.0
            ctrl_msg.steering = 0
            ctrl_msg.brake = 1
            ctrl_pub.publish(ctrl_msg)
            time.sleep(3)

        elif len(path_x) != 0:
            # Calc control input
            target_course = TargetCourse(path_x, path_y)
            target_ind, lf = target_course.search_target_index(state)

            di, target_ind, target_x, target_y = pure_pursuit_steer_control(state, target_course, target_ind)

            ctrl_msg.velocity = 7
            ctrl_msg.steering = di
            ctrl_msg.brake = 0
            ctrl_pub.publish(ctrl_msg)

        rate.sleep()

# import sys,os
# import rospy
# import rospkg
# import numpy as np
# from lidar_team_morai.msg import Waypoint
# from nav_msgs.msg import Path,Odometry
# from std_msgs.msg import Float64,Int16,Float32MultiArray
# from geometry_msgs.msg import PoseStamped,Point
# from morai_msgs.msg import EgoVehicleStatus,ObjectStatusList,CtrlCmd,GetTrafficLightStatus,SetTrafficLight
# import tf
# import time
# from math import cos, sin, sqrt, pow, atan2, pi

# class drive():
#     def __init__(self):
#         global angle
#         rospy.init_node('morai_drive', anonymous=True)
        
#         #publisher
#         ctrl_pub = rospy.Publisher('/ctrl_cmd',CtrlCmd, queue_size=1)

#         ctrl_msg= CtrlCmd()
      
#         #subscriber
#         rospy.Subscriber("/Ego_topic", EgoVehicleStatus, self.statusCB)

#         self.status_msg=EgoVehicleStatus()

#         rate = rospy.Rate(60)
#         ctrl_msg.longlCmdType = 2
#         while not rospy.is_shutdown():
            
#             time.sleep(3)

#             ctrl_msg.velocity = 5.0
#             ctrl_msg.steering = 30
#             ctrl_msg.brake = 0
#             ctrl_pub.publish(ctrl_msg)
#             time.sleep(3)
            
#             ctrl_msg.velocity = 0.0
#             ctrl_msg.steering = 0
#             ctrl_msg.brake = 1
#             ctrl_pub.publish(ctrl_msg)
#             time.sleep(1)

#             ctrl_msg.velocity = 5.0
#             ctrl_msg.steering = -30
#             ctrl_msg.brake = 0
#             ctrl_pub.publish(ctrl_msg)
#             time.sleep(3)
            
#             ctrl_msg.velocity = 0.0
#             ctrl_msg.steering = 0
#             ctrl_msg.brake = 1
#             ctrl_pub.publish(ctrl_msg)
#             time.sleep(100)

#             rate.sleep()
        
#     def statusCB(self,data):
#         self.status_msg=EgoVehicleStatus()
#         self.status_msg=data
#         br = tf.TransformBroadcaster()
#         br.sendTransform((self.status_msg.position.x, self.status_msg.position.y, self.status_msg.position.z),
#                         tf.transformations.quaternion_from_euler(0, 0, self.status_msg.heading/180*pi),
#                         rospy.Time.now(),
#                         "gps",
#                         "map")
#         self.is_status=True

# if __name__ == '__main__':
#     try:
#         drive = drive()
#     except rospy.ROSInterruptException:
#         pass
