#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import rospy
import rospkg
from morai_msgs.msg  import EgoVehicleStatus
from math import pi,cos,sin,pi,sqrt,pow
from nav_msgs.msg import Path
import tf
from geometry_msgs.msg import PoseStamped
from pyproj import Proj, transform


class test :

    def __init__(self):
        rospy.init_node('path_maker', anonymous=True)

        arg = rospy.myargv(argv=sys.argv)
        self.path_folder_name=arg[1]
        self.make_path_name=arg[2]
        

        rospy.Subscriber("/Ego_topic",EgoVehicleStatus, self.status_callback)
        self.global_path_pub= rospy.Publisher('/global_path',Path, queue_size=1)

        self.is_status=False
        self.prev_x = 0
        self.prev_y = 0
        self.idx = 0

        rospack=rospkg.RosPack()
        pkg_path=rospack.get_path('erp_ros')
        full_path=pkg_path +'/'+ self.path_folder_name+'/'+self.make_path_name+'.txt'
        self.f=open(full_path, 'w')

        rate=rospy.Rate(30)
        while not rospy.is_shutdown():
            if self.is_status==True :
                self.path_make()
            rate.sleep()    

        self.f.close()
        

    def path_make(self):
        x=self.status_msg.position.x
        y=self.status_msg.position.y
        #z=self.status_msg.position.z
        z = 9
        distance=sqrt(pow(x-self.prev_x,2)+pow(y-self.prev_y,2))
        if distance > 0.2:
            self.prev_x=x
            self.prev_y=y

            x = float(x) + 302459.942
            y = float(y) + 4122635.537
            
            proj_UTMK = Proj(init='epsg:5179')
            proj_UTM52N = Proj(init='epsg:32652')

            x, y = transform(proj_UTM52N, proj_UTMK, x, y)

            data='{0} {1} {2}\n'.format(x,y,z)
            self.f.write(data)
            
            self.idx += 1
            print(self.idx, x,y)

    def status_callback(self,msg): ## Vehicl Status Subscriber 
        self.is_status=True
        self.status_msg=msg
        br = tf.TransformBroadcaster()
        br.sendTransform((self.status_msg.position.x, self.status_msg.position.y, self.status_msg.position.z),
                        tf.transformations.quaternion_from_euler(0, 0, (self.status_msg.heading)/180*pi),
                        rospy.Time.now(),
                        "gps",
                        "map")
        

if __name__ == '__main__':
    try:
        test_track=test()
    except rospy.ROSInterruptException:
        pass


