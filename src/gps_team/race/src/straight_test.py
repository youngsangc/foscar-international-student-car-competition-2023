#!/usr/bin/env python3

import rospy
from race.msg import drive_values

rospy.init_node("go_straight")
drive_values_pub = rospy.Publisher('control_value', drive_values, queue_size=1)

max_speed = 3

def auto_drive():
    global max_speed

    drive_value = drive_values()

    drive_value.throttle = int(max_speed)
    drive_value.steering = 0.0

    drive_values_pub.publish(drive_value)

    print("steer : ", drive_value.steering)
    print("throttle : ", drive_value.throttle)


if __name__ == "__main__":
    while not rospy.is_shutdown():
        auto_drive()
        rospy.sleep(0.05)

    
