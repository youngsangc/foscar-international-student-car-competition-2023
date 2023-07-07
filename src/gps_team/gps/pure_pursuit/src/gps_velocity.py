#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import rospy
from std_msgs.msg import Float64
from geometry_msgs.msg import TwistWithCovarianceStamped
from math import sqrt

class GpsVelocity:
    def __init__(self):
        self.xVelocity = 0.0
        self.yVelocity = 0.0
        self.zVelocity = 0.0
        self.speed = 0.0

        # Subscriber
        rospy.Subscriber("/gps_front/fix_velocity", TwistWithCovarianceStamped, self.mainCallback)

        # Publisher
        self.speedPublisher = rospy.Publisher("/gps_velocity", Float64, queue_size=1)

    def mainCallback(self, msg):
        self.setMsgData(msg)
        self.calcSpeed()
        self.speedPub()
    
    def setMsgData(self, msg):
        self.xVelocity = msg.twist.twist.linear.x
        self.yVelocity = msg.twist.twist.linear.y
        self.zVelocity = msg.twist.twist.linear.z

    def calcSpeed(self):
        self.speed = sqrt(self.xVelocity * self.xVelocity + self.yVelocity * self.yVelocity) * 3.6

    def speedPub(self):
        self.speedPublisher.publish(self.speed)


if __name__ == "__main__":
    rospy.init_node("gps_speed")

    gpsVelocity = GpsVelocity()

    rate = rospy.Rate(60)

    while not rospy.is_shutdown():

        rate.sleep()