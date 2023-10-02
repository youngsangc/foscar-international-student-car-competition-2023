#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import math
from jinho.msg import AvoidAngleArray
from track_race.msg import Steering, Velocity
from morai_msgs.msg import CtrlCmd

class Controller:
    def __init__(self):
        # attribute
        self.totalAvoidAngle = 0

        self.minAngle = [0.0 for _ in range(30)]
        self.maxAngle = [0.0 for _ in range(30)]

        self.steering = 0
        self.velocity = 0


        # subscriber
        rospy.Subscriber("/avoid_angles", AvoidAngleArray, self.avoidAngleCallback)
        rospy.Subscriber("/gps_steering", Steering, self.steeringCallback)
        rospy.Subscriber("/gps_velocity", Velocity, self.velocityCallback)

        # publisher
        self.testPub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size=1)

    def velocityCallback(self, msg):
        self.velocity = msg.velocity


    # subscribe method
    def avoidAngleCallback(self, msg):
        self.totalAvoidAngle = msg.total
        for i in range(self.totalAvoidAngle):
            self.minAngle[i] = msg.minAngle[i]
            self.maxAngle[i] = msg.maxAngle[i]

        self.avoidRace()

    def steeringCallback(self, msg):
        self.steering = msg.steering
        self.avoidRace()

    def avoidRace(self):
        realSteering = 0
        if self.compareGpsAndAvoidAngle():
            realSteering = self.steering
            print(realSteering, "True")
        else:
            realSteering = self.convertMoraiSteering(self.getRightAvoidAngle())
            print(realSteering, "False")

        self.controlERP42(realSteering, self.velocity)

    def getRightAvoidAngle(self):
        findGoodSteering = False
        for i in range(self.totalAvoidAngle):
            if 90 < self.minAngle[i]:
                findGoodSteering = True
                return (self.minAngle[i] + self.maxAngle[i]) / 2 # self.minAngle[i] + 5

        if findGoodSteering == False:
            return (self.minAngle[0] + self.maxAngle[0]) / 2

    def compareGpsAndAvoidAngle(self):
        for i in range(self.totalAvoidAngle):
            # print( self.minAngle[i] , self.steering * 180 / math.pi , self.maxAngle[i] )
            if self.minAngle[i] < self.steering * 180 / math.pi + 90 < self.maxAngle[i]:
                return True
        return False

    def convertMoraiSteering(self, angle):
        return (90 - angle) * math.pi / 180

    def controlERP42(self, steering, velocity):
        self.ctrlMsg = CtrlCmd()
        self.ctrlMsg.longlCmdType = 2
        self.ctrlMsg.steering = steering
        self.ctrlMsg.velocity = velocity


        self.testPub.publish(self.ctrlMsg)

    def mainCallback(self):
        steering = self.trackingCloseObject()
        self.controlERP42(steering, 5)
        


if __name__ == '__main__':
    rospy.init_node("avoid_race_node")
    controller = Controller()

    rate = rospy.Rate(60)
    while not rospy.is_shutdown():
        rate.sleep()