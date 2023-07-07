#!/usr/bin/env python

import rospy
from obstacle_detector.msg import Obstacles
from avoid_obstacle.msg import PointObstacles, DetectedObstacles, TrueObstacles
from vision_distance.msg import Colorcone_lidar, ColorconeArray_lidar 

from race.msg import lane_info, drive_values

# drive_values_publisher
drive_values_pub = rospy.Publisher('control_value', drive_values, queue_size=1)
# obstacles publisher
obstacles_pub = rospy.Publisher('detected_obs', DetectedObstacles, queue_size=1)
# obstacle present publisher : yes or no
trueObs_pub = rospy.Publisher('true_obs', TrueObstacles, queue_size=1)
# obstacle present publisher : yes or no
trueObs_pub_long = rospy.Publisher('true_obs_long', TrueObstacles, queue_size=1)
# obstacle present publisher : yes or no
deliveryObsStop_pub = rospy.Publisher('delivery_obs_stop', TrueObstacles, queue_size=1)
deliveryObsCalc_pub = rospy.Publisher('delivery_obs_calc', TrueObstacles, queue_size=1)

sec = 0
yellow_cone=[]
blue_cone=[]


def colorcone_callback(msg):
	global flag, dist_x, dist_y
	global yellow_cone, blue_cone
	colorcone = msg.colorcone
	

	sorted_colorcone = sorted(colorcone, key=lambda x:(x.dist_y,x.dist_x,x.flag))
	sorted_colorcone = sorted_colorcone[:4]
	#print("colorcone_array" , sorted_colorcone)
	for i in range (len(sorted_colorcone)):
		if sorted_colorcone[i].flag==0:
			yellow_cone.append(sorted_colorcone[i])
		else:
			blue_cone.append(sorted_colorcone[i])



def callback(msg):
      global sec
      global yellow_cone, blue_cone
      center = []

      drive_value = drive_values()
      drive_value.throttle = int(10)
      drive_value.steering = (0)

      """
      if msg.header.stamp.secs == sec:
            pass
      else:
            sec = msg.header.stamp.secs
      """
      detected_obs = DetectedObstacles()
      true_obs = TrueObstacles()
      true_obs.detected = 0
      true_obs_long = TrueObstacles()
      true_obs_long.detected = 0

      # delivery_obstacle
      delivery_obs_stop = TrueObstacles()
      delivery_obs_stop.detected = 0

      delivery_obs_calc = TrueObstacles()
      delivery_obs_calc.detected = 0

      rospy.loginfo(len(msg.circles))

      for i in msg.circles:
        center.append([i.center.x, i.center.y])

        if i.center.x < 5 and (i.center.y > - 1.4 and i.center.y < 1.4):
            true_obs.detected = 1
            print("OBSTACLE) {}".format(i.radius))

        if i.center.x < 8 and (i.center.y > - 1.4 and i.center.y < 1.4):
            true_obs_long.detected = 1

        if i.center.x < 0.7 and -2.5 < i.center.y < -0.1:
            delivery_obs_stop.detected = 1

        if 1 < i.center.x < 4 and -2.5 < i.center.y < -0.1:
            delivery_obs_calc.detected = 1

        point_obs = PointObstacles()
        point_obs.x = i.center.x
        point_obs.y = i.center.y
        point_obs.radius = i.radius
        point_obs.true_radius = i.true_radius

        detected_obs.obstacles.append(point_obs)

      if true_obs.detected:
        drive_value.throttle = int(0)
        # print("Stop!! \n")

      obstacles_pub.publish(detected_obs)
      trueObs_pub.publish(true_obs)
      trueObs_pub_long.publish(true_obs_long)

      deliveryObsStop_pub.publish(delivery_obs_stop)
      deliveryObsCalc_pub.publish(delivery_obs_calc)

      # drive_values_pub.publish(drive_value)

      # rospy.loginfo(len(msg.circles))
      # rospy.loginfo(msg.circles)

def listener():
      rospy.init_node('dynamic_obstacles')
      rospy.Subscriber("raw_obstacles", Obstacles, callback)
      rospy.Subscriber("color_cone", ColorconeArray_lidar, colorcone_callback)

if __name__=='__main__':
      # global yellow_cone, blue_cone
      listener()
      rospy.spin()

"""
Structure of Obstacles.msg

<msgname>.header
std_msgs/Header header
  uint32 seq
  time stamp
  string frame_id

<msgname>.segments
obstacle_detector/SegmentObstacle[] segments
  geometry_msgs/Point first_point
    float64 x
    float64 y
    float64 z
  geometry_msgs/Point last_point
    float64 x
    float64 y
    float64 z

<msgname>.circles
obstacle_detector/CircleObstacle[] circles

<msgname>.circles.center.(x / y / z)
  geometry_msgs/Point center
    float64 x
    float64 y
    float64 z
<msgname>.circles.velocity.(x / y /z)
  geometry_msgs/Vector3 velocity
    float64 x
    float64 y
    float64 z
  float64 radius
  float64 true_radius
"""