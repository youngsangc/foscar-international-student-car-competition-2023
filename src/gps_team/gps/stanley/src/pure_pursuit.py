#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import rospkg
from geometry_msgs.msg import PoseStamped
from tf.transformations import euler_from_quaternion

from race.msg import lane_info, drive_values

import sys
import numpy as np
import math
import time
import matplotlib.pyplot as plt


# Parameters
k = 0.1  # look forward gain
Lfc = 6.0  # [m] look-ahead distance
Kp = 1.0  # speed proportional gain
dt = 0.1  # [s] time tick
WB = 2.8  # [m] wheel base of vehicle (default=2.5)

# WB = 1.04


drive_pub = rospy.Publisher('control_value', drive_values, queue_size=1)
pose_data = None

def update_pose(pose):
    global pose_data

    x = pose.pose.position.x
    y = pose.pose.position.y

    orientation_list = [pose.pose.orientation.x, pose.pose.orientation.y, pose.pose.orientation.z,pose.pose.orientation.w]
    roll, pitch, yaw = euler_from_quaternion(orientation_list)

    pose_data = (x,y,yaw)


class VehicleModel:
    def __init__(self, x=0.0, y=0.0, yaw=0.0, v=0.0):
        self.x = x
        self.y = y
        self.yaw = yaw
        self.v = v
        self.rear_x = self.x - ((WB / 2) * math.cos(self.yaw))
        self.rear_y = self.y - ((WB / 2) * math.sin(self.yaw))

        self.max_steering = np.radians(40)


    def update_manual(self, a, delta):
        self.x += self.v * math.cos(self.yaw) * dt
        self.y += self.v * math.sin(self.yaw) * dt
        self.yaw += self.v / WB * math.tan(delta) * dt
        self.v += a * dt
        self.rear_x = self.x - ((WB / 2) * math.cos(self.yaw))
        self.rear_y = self.y - ((WB / 2) * math.sin(self.yaw))


    def update(self, pose):
        self.x = pose.pose.position.x
        self.y = pose.pose.position.y

        orientation_list = [pose.pose.orientation.x, pose.pose.orientation.y, pose.pose.orientation.z, pose.pose.orientation.w]
        roll, pitch, yaw = euler_from_quaternion(orientation_list)
        self.yaw = yaw

        self.rear_x = self.x - ((WB / 2) * math.cos(self.yaw))
        self.rear_y = self.y - ((WB / 2) * math.sin(self.yaw))

        self.init_flag = True

    def calc_distance(self, point_x, point_y):
        dx = self.rear_x - point_x
        dy = self.rear_y - point_y
        return math.hypot(dx, dy)


    def setPose(self, x, y, yaw):
        self.x = x
        self.y = y
        self.yaw = yaw


# for plot
class States:

    def __init__(self):
        self.x = []
        self.y = []
        self.yaw = []
        self.v = []
        self.t = []

    def append(self, t, state):
        self.x.append(state.x)
        self.y.append(state.y)
        self.yaw.append(state.yaw)
        self.v.append(state.v)
        self.t.append(t)


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
                if distance_this_index < distance_next_index:
                    break
                ind = ind + 1 if (ind + 1) < len(self.cx) else ind
                distance_this_index = distance_next_index
            self.old_nearest_point_index = ind

        Lf = k * state.v + Lfc  # update look ahead distance

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

    delta = math.atan2(2.0 * WB * math.sin(alpha) / Lf, 1.0)

    return delta, ind


def plot_arrow(x, y, yaw, length=1.0, width=0.5, fc="r", ec="k"):
    if not isinstance(x, float):
        for ix, iy, iyaw in zip(x, y, yaw):
            plot_arrow(ix, iy, iyaw)
    else:
        plt.arrow(x, y, length * math.cos(yaw), length * math.sin(yaw),
                  fc=fc, ec=ec, head_width=width, head_length=width)
        plt.plot(x, y)



def drive(angle, speed):
    global drive_pub
    drive_value = drive_values()
    drive_value.throttle = speed
    drive_value.steering = angle

    drive_pub.publish(drive_value)




def main():
    rospy.init_node('purepursuit_controller')
    rospack = rospkg.RosPack()
    ROS_HOME = rospack.get_path('pure_pursuit')

    vel = 5.0
    path = None
    if len(sys.argv) > 2:
        path = ROS_HOME + "/paths/" + sys.argv[1].strip() + ".txt"
        vel = float(sys.argv[2].strip())

    if path == None:
        print("No Path Parameter")
        return


    mapx = []
    mapy = []
    with open(path) as f:
        for line in f.readlines():
            x = float(line.strip().split()[0])
            y = float(line.strip().split()[1])

            mapx.append(x)
            mapy.append(y)


    target_speed = vel  # [m/s]


    # initial state
    model = VehicleModel(v=vel)
    # model = VehicleModel(x=mapx[0], y=mapy[0], yaw=0, v=0.0)

    # first_point = (935547.536075, 1915874.83958)
    # model = VehicleModel(x=first_point[0], y=first_point[1], yaw=0.0, v=0.0)

    # ros
    rospy.Subscriber("current_pose", PoseStamped, update_pose)

    lastIndex = len(mapx) - 1
    target_course = TargetCourse(mapx, mapy)
    target_ind, _ = target_course.search_target_index(model)


    # for plot
    time_ = 0.0
    states = States()
    # states.append(time_, model)

    rate = rospy.Rate(10)
    start_time = time.time()
    while not rospy.is_shutdown():
        if pose_data == None: continue

        if time.time() - start_time <= 25:
            model.setPose(pose_data[0], pose_data[1], pose_data[2])


        if lastIndex <= target_ind:
            print('finish')
            break

        # Calc control input
        ai = proportional_control(target_speed, model.v)
        di, target_ind = pure_pursuit_steer_control(model, target_course, target_ind)

        # 처음부터 MAX Angle일경우, Yaw를 잘 못 잡은 것으로 판단.
        if di >= model.max_steering and time.time() - start_time <= 30:
            continue


        model.update_manual(ai, di)  # Control vehicle(speed, angle)

        steer_deg = -np.rad2deg(di)
        print("%d : %.2f" % (target_ind, steer_deg))

        # drive_pup
        # drive(steer_deg, vel)


        # plot test
        time_ += dt
        states.append(time_, model)
        plt.cla()
        # for stopping simulation with the esc key.
        plt.gcf().canvas.mpl_connect(
            'key_release_event',
            lambda event: [exit(0) if event.key == 'escape' else None])
        plot_arrow(model.x, model.y, model.yaw)
        plt.plot(mapx, mapy, "-r", label="course")
        plt.plot(states.x, states.y, "-b", label="trajectory")
        plt.plot(mapx[target_ind], mapy[target_ind], "xg", label="target")
        plt.axis("equal")
        plt.grid(True)
        plt.title("Speed[m/s]:" + str(model.v)[:4])
        plt.pause(0.001)


        rate.sleep()

    # Test
    assert lastIndex >= target_ind, "Cannot goal"

    # for plot (speed)
    plt.cla()
    plt.plot(mapx, mapy, ".r", label="course")
    plt.plot(states.x, states.y, "-b", label="trajectory")
    plt.legend()
    plt.xlabel("x[m]")
    plt.ylabel("y[m]")
    plt.axis("equal")
    plt.grid(True)
    plt.show()

    
    # plt.subplots(1)
    # plt.plot(states.t, [iv * 3.6 for iv in states.v], "-r")
    # plt.xlabel("Time[s]")
    # plt.ylabel("Speed[km/h]")
    # plt.grid(True)
    # plt.show()


if __name__ == '__main__':
    print("Pure pursuit path tracking simulation start")
    main()
