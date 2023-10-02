#!/usr/bin/env python
# -*- coding: utf-8 -*-
import tf
import sys,os
import rospy
import rospkg
import numpy as np
import math, time
from nav_msgs.msg import Path,Odometry
from geometry_msgs.msg import PoseStamped,Point
from std_msgs.msg import Float64,Int16,Float32MultiArray

from math import cos,sin,sqrt,pow,atan2,pi
from lidar_team_morai.msg import Waypoint
from nav_msgs.msg import Path,Odometry
from std_msgs.msg import Float64,Int16,Float32MultiArray
from geometry_msgs.msg import PoseStamped,Point
from visualization_msgs.msg import Marker
from visualization_msgs.msg import MarkerArray
from morai_msgs.msg import EgoVehicleStatus, CtrlCmd
from ar_track_alvar_msgs.msg import AlvarMarkers
from tf.transformations import euler_from_quaternion


from morai_msgs.msg import ObjectStatusList 
from utils import pathReader, latticePlanner

from std_msgs.msg import Bool

# Parameters
k = 0.1  # look forward gain
Lfc = 0.5
# Lfc = 5.0
# Lfc = 1.75
# Lfc = 1.25  # [m] look-ahead distance
Kp = 1.0  # speed proportional gain
dt = 0.1  # [s] time tick
WB = 0.78  # [m] wheel base of vehicle

target_speed = 10
speed = 10
current_v = 0

show_animation = True

# path_x = [0] * 100
# path_y = [0] * 100
path_x = []
path_y = []
count = 0
current_velocity = 0
status_msg = None
global_path = None

arData = {"DX":0.0, "DY":0.0, "DZ": 0.0, "AX": 0.0, "AY": 0.0, "AZ": 0.0, "AW": 0.0}

is_obs_detected_long = False
is_obs_detected = False

class State:

    def __init__(self, x = -0.39, y = 0.0, yaw = 0.0, v = 0.0):
        self.yaw = yaw
        self.v = v
        self.rear_x = x
        self.rear_y = y

    def update(self, a, delta):
        global current_v
        self.v += a * dt

    def calc_distance(self, point_x, point_y):
        dx = self.rear_x - point_x
        dy = self.rear_y - point_y
        # print(math.hypot(dx, dy))
        return math.hypot(dx, dy)


def proportional_control(target, current):
    a = Kp * (target - current)

    return a



class TargetCourse:

    def __init__(self, cx, cy):
        self.cx = cx
        self.cy = cy
        self.old_nearest_point_index = None
 

    def search_target_index(self, state):
  
        # To speed up nearest point search, doing it at only first time.  
        if self.old_nearest_point_index is None:
            # search nearest point index
            # print(path_x)
            dx = [state.rear_x - icx for icx in self.cx]
            dy = [state.rear_y - icy for icy in self.cy]
            # print(dx)
            # print(dy)
            d = np.hypot(dx, dy)

            ind = np.argmin(d)
            # print(ind)
            self.old_nearest_point_index = ind
        else:
            ind = self.old_nearest_point_index
            # print("ind:", ind)
            # print("CX!!!!!!!!!!!!!!!!!!: ", self.cx)
            distance_this_index = state.calc_distance(self.cx[ind], self.cy[ind])
            while True:
                distance_next_index = state.calc_distance(self.cx[ind + 1], self.cy[ind + 1])

                if distance_this_index < distance_next_index + 1:
                    break
                
                if (ind + 1) < len(self.cx):
                    ind = ind + 1
                else:
                    ind = ind 
                # ind = ind + 1 if (ind + 1) < len(self.cx) else ind
                distance_this_index = distance_next_index
            self.old_nearest_point_index = ind

        
        # print(state.v)
        # print(current_v)
        Lf = k * current_v + Lfc  # update look ahead distance
        # Lf = Lfc

        # search look ahead target point index
        while Lf > state.calc_distance(self.cx[ind], self.cy[ind]):
            if (ind + 1) >= len(self.cx):
                print("&&&&&&&&&&&&&&&&&&&&&&&&&")
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

    delta = math.atan2(2.0 * WB * math.sin(alpha) / Lf, 0.75) #/ Lf, 1.4)


    return delta, ind, tx, ty

def path_callback(data):
    global path_x, path_y
    path_x = data.x_arr
    path_y = data.y_arr

def statusCB(data):
    global status_msg
    status_msg=EgoVehicleStatus()
    status_msg=data
    # print(status_msg)
    br = tf.TransformBroadcaster()
    br.sendTransform((status_msg.position.x, status_msg.position.y, status_msg.position.z),
                    tf.transformations.quaternion_from_euler(0, 0, status_msg.heading/180*pi),
                    rospy.Time.now(),
                    "gps",
                    "map")
    is_status=True 

def st_long_callback(msg):
    global is_obs_detected_long
    is_obs_detected_long = msg.data

def st_callback(msg):
    global is_obs_detected
    is_obs_detected = msg.data

# class PathRead:
#     def __init__(self):
#         global global_path, path_x, path_y

#         # arg = rospy.myargv(argv=sys.argv)
#         # # self.path_name=arg[1]
#         # left_path_name = arg[1]
#         # right_path_name = arg[2]

#         arg = rospy.myargv(argv=sys.argv)

#         global_path=path_reader.read_txt(arg[1]+".txt")

#         # print(global_path.poses[1].pose.position.x)
#         for i in range(len(global_path.poses)):
#             path_x.append(global_path.poses[i].pose.position.x)
#             path_y.append(global_path.poses[i].pose.position.y)
#         path_x = tuple(path_x)
#         path_y = tuple(path_y)
#         # print(type(path_x))

def callback(msg):
    global arData

    for i in msg.markers:
        arData["DX"] = i.pose.pose.position.x
        arData["DY"] = i.pose.pose.position.y
        arData["DZ"] = i.pose.pose.position.z

        arData["AX"] = i.pose.pose.orientation.x
        arData["AY"] = i.pose.pose.orientation.y
        arData["AZ"] = i.pose.pose.orientation.z
        arData["AW"] = i.pose.pose.orientation.w

    # print(msg.pose)
    print("############")

if __name__ == '__main__':
    rospy.init_node('path_reader', anonymous=True)

    rospy.Subscriber("/Ego_topic", EgoVehicleStatus, statusCB)
    rospy.Subscriber("/static_obs_flag_long", Bool, st_long_callback)
    rospy.Subscriber("/static_obs_flag_short", Bool, st_callback)
    rospy.Subscriber("current_pose", AlvarMarkers, callback)
    

    global_path_pub= rospy.Publisher('/global_path', Path, queue_size = 1)
    target_pub = rospy.Publisher('target_point', Marker, queue_size = 1)
    ctrl_pub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size = 1)

    path_reader=pathReader('lidar_team_morai')

    # drive = PathRead()
    ctrl_msg = CtrlCmd()
    rate = rospy.Rate(60)
    state = State(x = -0.92, y = 0.0, yaw = 0.0, v = current_v)

    arg = rospy.myargv(argv=sys.argv)

    while not rospy.is_shutdown():

        (roll, pitch, yaw)=euler_from_quaternion((arData["AX"], arData["AY"], arData["AZ"], arData["AW"]))

        roll = math.degrees(roll)
        pitch = math.degrees(pitch)
        yaw = math.degrees(yaw)
        
        # print("roll: ", roll)
        # print("pitch: ", pitch)
        # print("yaw: ", yaw)

        if status_msg != None:
            
            if is_obs_detected_long and count == 0:
                count = 1
            
            if count == 1:
                global_path=path_reader.read_txt(arg[2]+".txt")
                start = time.time()
                while time.time() - start < 1:
                    # print("1")
                    ctrl_msg.steering = -0.3
                    ctrl_msg.velocity = 10
                    ctrl_pub.publish(ctrl_msg)

                start = time.time()
                while time.time() - start < 0.5:
                    # print("2")
                    ctrl_msg.steering = 0.15
                    ctrl_msg.velocity = 10
                    ctrl_pub.publish(ctrl_msg)
                    count = 2
                ctrl_msg.velocity = 10
                ctrl_pub.publish(ctrl_msg)
            elif count == 2 and is_obs_detected_long:
                global_path=path_reader.read_txt(arg[1]+".txt")
                start = time.time()
                while time.time() - start < 1:
                    # print("3")
                    ctrl_msg.steering = 0.3
                    ctrl_msg.velocity = 10
                    ctrl_pub.publish(ctrl_msg)

                start = time.time()
                while time.time() - start < 0.5:
                    # print("4")
                    ctrl_msg.steering = -0.15
                    ctrl_msg.velocity = 10
                    ctrl_pub.publish(ctrl_msg)
                    count = 3



            elif count == 0:
                global_path=path_reader.read_txt(arg[1]+".txt")

            # print(global_path.poses[1].pose.position.x)
            for i in range(len(global_path.poses)):
                path_x.append(global_path.poses[i].pose.position.x)
                path_y.append(global_path.poses[i].pose.position.y)
            # path_x = tuple(path_x)
            # path_y = tuple(path_y)

            global_path_pub.publish(global_path)

    
            state = State(x = status_msg.position.x, y = status_msg.position.y, yaw = (status_msg.heading)/180*pi, v = current_v)
            # count = 0
            # if count/300==1 :
            #     global_path_pub.publish(global_path)
            #     count=0
            # count+=1
            target_course = TargetCourse(path_x, path_y)
            target_ind, _ = target_course.search_target_index(state)
            di, target_ind, target_x, target_y = pure_pursuit_steer_control(state, target_course, target_ind)
            # print(target_x)
            # print(is_obs_detected_long)
            marker = Marker()
            marker.header.frame_id = "/map"
            marker.id = 1004
            marker.type = marker.SPHERE
            marker.action = marker.ADD
            marker.scale.x = 1.05
            marker.scale.y = 1.05
            marker.scale.z = 1.05
            marker.color.a = 1.0
            marker.color.r = 1.0
            marker.color.g = 0.0
            marker.color.b = 1.0
            marker.pose.orientation.w = 1.0
            marker.pose.position.x = target_x
            marker.pose.position.y = target_y
            marker.pose.position.z = 0.2

            marker.lifetime = rospy.Duration(0.1)

            target_pub.publish(marker)
            ctrl_msg.longlCmdType = 2
            # print(di)
            if abs(di) > 0.175:
                current_v = 7       #7
            elif abs(di) > 0.08:
                current_v = 12.5     #12.5
            elif abs(di) > 0.04:
                current_v = 15       #15
            else:
                current_v = 20

            ctrl_msg.steering = di
            ctrl_msg.velocity = current_v
            ctrl_pub.publish(ctrl_msg)
            # print(status_msg.position.x)

            ai = proportional_control(target_speed, current_v)
            state.update(ai, di)  # Control vehicle

        rate.sleep()