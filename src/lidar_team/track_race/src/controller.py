#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# TODO currentSpeed 의존성ㅇ 재설정

from queue import Queue
from time import time
import rospy
import sys
from std_msgs.msg import Bool
from morai_msgs.msg import CtrlCmd
from track_race.msg import Velocity
from track_race.msg import Steering
from std_msgs.msg import Float64
from track_race.msg import Test
from race.msg import drive_values
import erp_info


class control:
    def __init__(self, flag = 1):
        self.mode = flag  # 0: morai, 1: real
        self.oneLapFlag = False
        self.steeringLidar = 0.0
        self.velocityLidar = 0.0
        self.steeringGps = 0.0
        self.velocityGps = 0.0
        self.erp42Car = erp_info.erp42()
        self.erp42CarMorai = erp_info.erp42morai()
        self.currentSpeed = 0
        self.coolTime = 3.0
        self.currentTime = time()
        self.brakeCoolTime = time()

        # Subscribe
        rospy.Subscriber("/is_one_lap_finished", Bool, self.oneLapFlagCallback)

        rospy.Subscriber("/dynamic_velocity_lidar", Velocity, self.velocityLidarCallback)
        rospy.Subscriber("/pure_pursuit_lidar", Steering, self.steeringLidarCallback)

        rospy.Subscriber("/dynamic_velocity_gps", Velocity, self.velocityGpsCallback)
        rospy.Subscriber("/pure_pursuit_gps", Steering, self.steeringGpsCallback)

        rospy.Subscriber("/gps_velocity", Float64, self.getCurrentSpeed)

        # Publisher
        self.erp42ControlPublisher = self.getPublisher(self.mode)
        self.test_steeringDeltaPublisher = rospy.Publisher("/delta", Test, queue_size=1)
        
    # 현재 사용
    def oneLapFlagCallback(self, msg):
        self.oneLapFlag = msg.data

    def velocityLidarCallback(self, msg):
        self.velocityLidar = msg.velocity

    def steeringLidarCallback(self, msg):
        # self.delta = self.steeringLidar - msg.steering #test
        # self.test_steeringDeltaPub() #test
        self.steeringLidar = msg.steering

    def velocityGpsCallback(self, msg):
        self.velocityGps = msg.velocity

    def steeringGpsCallback(self, msg):
        self.steeringGps = msg.steering

    def getPublisher(self, mode):
        if self.mode == 0:
            return rospy.Publisher("/ctrl_cmd", CtrlCmd, queue_size=1)
        else:
            return rospy.Publisher("/control_value", drive_values, queue_size=1)

    def getCurrentSpeed(self, msg):
        self.currentSpeed = msg.data

    def gapThrottleAndCurrentSpeed(self):
        if self.oneLapFlag:
            return self.velocityGps - self.currentSpeed
        else:
            return self.velocityLidar - self.currentSpeed
    
    def decelerate(self):
        # print("##############BRAKE##############")
        if self.oneLapFlag:
            ctrlMsg = drive_values()
            ctrlMsg.throttle = 0
            ctrlMsg.steering = self.steeringGps
            ctrlMsg.brake = 0.1 # 0.0245
        else:
            ctrlMsg = drive_values()
            ctrlMsg.throttle = 0
            ctrlMsg.steering = self.steeringLidar
            ctrlMsg.brake = 0.1 # 0.0245

        self.erp42ControlPublisher.publish(ctrlMsg)

    def accelerate(self):
        if self.oneLapFlag:
            ctrlMsg = drive_values()
            ctrlMsg.throttle = 20
            ctrlMsg.steering = self.steeringGps
            ctrlMsg.brake = 0.0
        else:
            ctrlMsg = drive_values()
            ctrlMsg.throttle = 20
            ctrlMsg.steering = self.steeringLidar
            ctrlMsg.brake = 0.0

        self.erp42ControlPublisher.publish(ctrlMsg)

    def isNotBrakeCoolTime(self):
        if (time() - self.brakeCoolTime) > self.coolTime:
            return True
        else:
            return False

    def controlERP42(self):
        # if self.gapThrottleAndCurrentSpeed() > 11 and self.isNotBrakeCoolTime():
        #     self.currentTime = time()
        #     while time() - self.currentTime < 0.1:
        #         self.decelerate()

        #     self.currentTime = time()
        #     while time() - self.currentTime < 0.3:
        #         self.accelerate()

        #     self.brakeCoolTime = time()

        if ( self.currentSpeed > 10 and abs(self.steeringGps) > 3 ) or (self.gapThrottleAndCurrentSpeed() < -3):
            self.decelerate()
            return

        # if self.oneLapFlag == True:
        #     if self.currentSpeed > 11 and abs(self.steeringGps) > 16 and self.isNotBrakeCoolTime:
        #         self.currentTime = time()
        #         while time() - self.currentTime < 0.1:
        #             self.decelerate()


        if self.oneLapFlag == False:
            if self.mode == 0:
                ctrlMsg = CtrlCmd()
                ctrlMsg.longlCmdType = 2
                ctrlMsg.velocity = self.velocityLidar + self.gapThrottleAndCurrentSpeed()
                ctrlMsg.steering = self.steeringLidar

                self.erp42ControlPublisher.publish(ctrlMsg)

            elif self.mode == 1:
                ctrlMsg = drive_values()
                ctrlMsg.throttle = int(self.velocityLidar + self.gapThrottleAndCurrentSpeed())
                ctrlMsg.steering = self.steeringLidar
                ctrlMsg.brake = 0

                self.erp42ControlPublisher.publish(ctrlMsg)

        elif self.oneLapFlag == True:
            if self.mode == 0:
                ctrlMsg = CtrlCmd()
                ctrlMsg.longlCmdType = 2
                ctrlMsg.velocity = self.velocityGps + self.gapThrottleAndCurrentSpeed()
                ctrlMsg.steering = self.steeringGps

                self.erp42ControlPublisher.publish(ctrlMsg)

            elif self.mode == 1:
                ctrlMsg = drive_values()
                ctrlMsg.throttle = int(self.velocityGps + self.gapThrottleAndCurrentSpeed())
                ctrlMsg.steering = self.steeringGps
                ctrlMsg.brake = 0

                self.erp42ControlPublisher.publish(ctrlMsg)
        

    # 현재 미사용

    def test_steeringDeltaPub(self):
        # print("test")
        testMsg = Test()
        testMsg.delta = self.delta
        self.test_steeringDeltaPublisher.publish(testMsg)


if __name__ == '__main__':
    rospy.init_node("controller_node")
    flag = int(sys.argv[1])
    controller = control(flag)

    rate = rospy.Rate(60)
    while not rospy.is_shutdown():
        controller.controlERP42()
        rate.sleep()
