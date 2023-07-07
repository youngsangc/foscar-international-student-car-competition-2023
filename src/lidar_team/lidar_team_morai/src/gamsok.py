#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
from std_msgs.msg import Float64,Int16,Float32MultiArray
import rospy
import rospkg
import tf
import time
import threading

from morai_msgs.msg import EgoVehicleStatus, CtrlCmd

from lidar_team_morai.msg import Waypoint

from lidar_team_erp42.msg import Delivery

xx = 0.0
yy = 0.0
zz = 0.0
flag = True
v = 5
# count_up = 0
stop_time = 5
def startCallback():
    ctrl_msg.brake = 0
    ctrl_msg.velocity = 15

def printCallback():
    global count_up, stop_time
    for i in range(stop_time):
        print(str(i+1) + " seconds later")
        time.sleep(1)


    # count_up += 1
    # if count_up <= stop_time:
    #     print(count_up, " seconds later")
    # else:
    #     pass
    



def stopCallback():
    global stop_time
    print("stop")
    ctrl_msg.brake = 1.0
    ctrl_msg.velocity = 0
    timer = threading.Timer(stop_time, startCallback)
    timer.start()
    print_timer = threading.Timer(1, printCallback)
    print_timer.start()

def timerCallback(velocity, x):
    global flag
    if 0 < x < 5 and flag:
        print("distance = " + str(x) + "m")
        flag = False
        timer = threading.Timer((x + 0.55) * 18/(5 * velocity), stopCallback)
        timer.start()
            
def delivery_callback(msg):
    timerCallback(v - 0.2, msg.x)

    

if __name__ == '__main__':
    rospy.init_node('gamsok', anonymous=True)

    rate = rospy.Rate(60)

    rospy.Subscriber("/delivery_information", Delivery, delivery_callback)
    ctrl_pub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size = 1)

    ctrl_msg = CtrlCmd()
    ctrl_msg.longlCmdType = 2
    ctrl_msg.velocity = v
    ctrl_msg.steering = 0

    while not rospy.is_shutdown():
        ctrl_pub.publish(ctrl_msg)
        rate.sleep()
# import numpy as np
# from std_msgs.msg import Float64,Int16,Float32MultiArray
# import rospy
# import rospkg
# import tf
# import time
# import threading

# from morai_msgs.msg import EgoVehicleStatus, CtrlCmd

# from lidar_team_morai.msg import Waypoint

# from lidar_team_erp42.msg import Delivery

# xx = 0.0
# yy = 0.0
# zz = 0.0
# flag = True

# target_x = 0

# def callback(msg):
#     global target_x
#     target_x = msg.x
    

# if __name__ == '__main__':
#     rospy.init_node('gamsok', anonymous=True)

#     rate = rospy.Rate(60)

#     rospy.Subscriber("/delivery_information", Delivery, callback)
#     ctrl_pub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size = 1)

#     ctrl_msg = CtrlCmd()
#     ctrl_msg.longlCmdType = 2

#     while not rospy.is_shutdown():

#         if 0 < target_x < 5:
#             start = time.time()
#             while True:
#                 now = time.time()
#                 if (now - start > 18/25 * (target_x + 0.5)):
#                     ctrl_msg.brake = 1
#                     ctrl_msg.velocity = 0
#                     ctrl_msg.steering = 0
#                     ctrl_pub.publish(ctrl_msg)
#                     break
#                 else:
#                     ctrl_msg.velocity = 5
#                     ctrl_msg.steering = 0
#                     ctrl_pub.publish(ctrl_msg)
#         else:
#             ctrl_msg.velocity = 5
#             ctrl_msg.steering = 0
#             ctrl_pub.publish(ctrl_msg)

#         rate.sleep()