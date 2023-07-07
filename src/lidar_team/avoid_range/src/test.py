#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import math
from object_detector.msg import ObjectInfo
from morai_msgs.msg import CtrlCmd

class Tracker:
    def __init__(self):
        # attribute
        self.objectTotal = 0
        self.x = [0.0 for _ in range(30)]
        self.y = [0.0 for _ in range(30)]
        self.r = [0.0 for _ in range(30)]
        self.distance = [0.0 for _ in range(30)]

        self.pivotX = 0.0
        self.pivotY = 0.0

        # subscriber
        rospy.Subscriber("/object_info", ObjectInfo, self.setObjectInfo)

        # publisher
        self.testPub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size=1)

    # subscribe method
    def setObjectInfo(self, msg):
        self.objectTotal = msg.objectCounts
        for i in range(self.objectTotal):
            self.x[i] = msg.centerX[i]
            self.y[i] = msg.centerY[i]
            self.r[i] = math.sqrt(msg.lengthX[i] * msg.lengthX[i] + msg.lengthY[i] * msg.lengthY[i])
            self.distance[i] = math.sqrt( msg.centerX[i] * msg.centerX[i] + msg.centerY[i] * msg.centerY[i] )
        
        self.mainCallback()

    def trackingCloseObject(self):
        rad = math.atan( self.y[self.objectTotal - 1] / self.x[self.objectTotal - 1] )
        print(rad * 180 / math.pi)
        return rad

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
    rospy.init_node("tracking_node")
    tracker = Tracker()

    rate = rospy.Rate(60)
    while not rospy.is_shutdown():
        rate.sleep()