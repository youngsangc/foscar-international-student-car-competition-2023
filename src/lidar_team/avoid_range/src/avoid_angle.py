#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import math
from object_detector.msg import ObjectInfo
from morai_msgs.msg import CtrlCmd
from visualization_msgs.msg import Marker, MarkerArray
from std_msgs.msg import ColorRGBA
from geometry_msgs.msg import Point

class AvoidAngle:
    def __init__(self):
        # attribute
        self.objectTotal = 0
        self.x = [0.0 for _ in range(30)]
        self.y = [0.0 for _ in range(30)]
        self.r = [0.0 for _ in range(30)]
        self.distance = [0.0 for _ in range(30)]

        self.availableAngleTotal = 0
        self.inRangeObjectTotal = 0
        self.minAngle = 30.0
        self.maxAngle = 150.0
        self.objectMinAngle = [0.0 for _ in range(30)]
        self.objectMaxAngle = [0.0 for _ in range(30)]
        self.availableMinAngle = [0.0 for _ in range(30)]
        self.availableMaxAngle = [0.0 for _ in range(30)]

        self.padding = 0.58
        self.pivotX = 0.0
        self.pivotY = 0.0
        self.detectRange = 8.0

        # subscriber
        rospy.Subscriber("/object_info", ObjectInfo, self.mainCallback)

        # publisher
        self.testPub = rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size=1)
        self.visualizeAvoidRangePub = rospy.Publisher("/visualize_avoid_range", Marker, queue_size=1)
        self.visualizeObjectPub = rospy.Publisher("/visualize_object", MarkerArray, queue_size=1)

    # subscribe method
    def setObjectInfo(self, msg):
        self.objectTotal = msg.objectCounts
        for i in range(self.objectTotal):
            self.x[i] = msg.centerX[i]
            self.y[i] = msg.centerY[i]
            self.r[i] = math.sqrt(msg.lengthX[i] * msg.lengthX[i] + msg.lengthY[i] * msg.lengthY[i]) / 2 + self.padding
            self.distance[i] = math.sqrt( msg.centerX[i] * msg.centerX[i] + msg.centerY[i] * msg.centerY[i] )

    # calcAvoidRange Method
    def initAngle(self):
        self.objectMinAngle = []
        self.objectMaxAngle = []
        self.availableMinAngle = []
        self.availableMaxAngle = []

    def isInRange(self, idx):
        if self.distance[idx] < self.detectRange:
            return True
        return False
    
    def calcMinMaxAngle(self, idx):
        centerRadian = math.acos( self.y[idx] / self.distance[idx] )
        roundRadian = math.asin( self.r[idx] / self.distance[idx] )
        self.objectMinAngle[self.inRangeObjectTotal] = (centerRadian - roundRadian) * 180.0 / math.pi
        self.objectMaxAngle[self.inRangeObjectTotal] = (centerRadian + roundRadian) * 180.0 / math.pi
        self.inRangeObjectTotal += 1

    def calcAvoidAngle(self):
        tmpMinAngle = self.minAngle
        self.availableAngleTotal = 0

        for i in range(self.inRangeObjectTotal):
            if tmpMinAngle < self.objectMinAngle[i]:
                self.availableMinAngle[i] = tmpMinAngle
                self.availableMaxAngle[i] = self.objectMinAngle[i]
                tmpMinAngle = self.objectMaxAngle[i]
                
                self.availableAngleTotal += 1
            else:
                tmpMinAngle = self.objectMaxAngle[i] if self.objectMaxAngle[i] > tmpMinAngle else tmpMinAngle
            
            if self.objectMaxAngle[i] > self.maxAngle:
                break

        if tmpMinAngle < self.maxAngle:
            self.availableMinAngle[self.availableAngleTotal] = tmpMinAngle
            self.availableMaxAngle[self.availableAngleTotal] = self.maxAngle
            self.availableAngleTotal += 1

    def calcAvoidRange(self):
        self.inRangeObjectTotal = 0
        # calc MinMaxAngle
        for i in range(0, self.objectTotal):
            if self.isInRange(i):
                self.calcMinMaxAngle(i)

        # sort
        self.objectMinAngle.sort()
        self.objectMaxAngle.sort()
        # calc AvailableAngle
        self.calcAvoidAngle()

    # filter Method
    def getMeanAngle(self, min, max):
        return (min + max) / 2
    
    def getMaxAngleIndex():
        pass

    def test(self):
        if len(self.availableMinAngle) == 0:
            return 90
        return self.availableMinAngle[-1]

    def goRight(self):
        ctrlMsg = CtrlCmd()
        ctrlMsg.longlCmdType = 2
        ctrlMsg.steering = (self.test() - 90) * math.pi / -180
        ctrlMsg.velocity = 7
        self.testPub.publish(ctrlMsg)

    # visualize Method
    def visualizeAvoidRange(self):
        avoidRangeMarker = Marker()
        avoidRangeMarker.header.frame_id = "/velodyne"
        avoidRangeMarker.ns = "avoidRangeMarker"
        avoidRangeMarker.id = 10
        avoidRangeMarker.type = Marker.LINE_LIST
        avoidRangeMarker.action = Marker.ADD
        avoidRangeMarker.color = ColorRGBA(0, 1, 1, 0.5)
        avoidRangeMarker.scale.x = 0.1

        for i in range(self.availableAngleTotal):
            avoidRangeMarker.points.append(Point(0, 0, 0))
            avoidRangeMarker.points.append(Point(math.sin(self.availableMinAngle[i] * math.pi / 180.0) * 10, math.cos(self.availableMinAngle[i] * math.pi / 180.0) * 10, 0))
            avoidRangeMarker.points.append(Point(0, 0, 0))
            avoidRangeMarker.points.append(Point(math.sin(self.availableMaxAngle[i] * math.pi / 180.0) * 10, math.cos(self.availableMaxAngle[i] * math.pi / 180.0) * 10, 0))
        
        self.visualizeAvoidRangePub.publish(avoidRangeMarker)

    def visualizeObject(self):
        objecetCircleMarker = Marker()
        objecetCircleMarkerArray = MarkerArray()
        objecetCircleMarker.header.frame_id = "/velodyne"
        objecetCircleMarker.ns = "objecetCircleMarker"
        objecetCircleMarker.type = Marker.CYLINDER
        objecetCircleMarker.action = Marker.ADD
        objecetCircleMarker.id = 100
        objecetCircleMarker.color = ColorRGBA(1, 0.5, 1, 0.5)
        objecetCircleMarker.lifetime = rospy.Duration(0.1)
        
        for i in range(self.objectTotal):
            objecetCircleMarker.id = 100 + i
            objecetCircleMarker.pose.position.x = self.x[i]
            objecetCircleMarker.pose.position.y = self.y[i]
            objecetCircleMarker.pose.position.z = 0
            
            objecetCircleMarker.scale.x = self.r[i] * 2
            objecetCircleMarker.scale.y = self.r[i] * 2
            objecetCircleMarker.scale.z = 0.5
            objecetCircleMarkerArray.markers.append(objecetCircleMarker)



        self.visualizeObjectPub.publish(objecetCircleMarkerArray)



    def mainCallback(self, msg):
        self.setObjectInfo(msg)
        self.visualizeObject()
        self.calcAvoidRange()
        print(self.availableMinAngle)
        self.visualizeAvoidRange()
        # self.goRight()
        
        


if __name__ == '__main__':
    rospy.init_node("avoid_angle_node")
    avoidAngle = AvoidAngle()

    rate = rospy.Rate(60)
    while not rospy.is_shutdown():
        rate.sleep()