#!/usr/bin/env python

import sys
import numpy as np
import rospy, rospkg

mode = 0
file_name = ''
path = ''
map_xs = []
map_ys = []

def read_path(path):
  n_data = []
  f = open(path, "r")
  data = f.read()
  f.close()

  data = data.strip().split('\n')
 
  for line in data:
    x = float(line.strip().split()[0])
    y = float(line.strip().split()[1])

    vec = line.split()
    if len(vec) == 2:
      vec += [0]
    n_data.append(vec)


    map_xs.append(x)
    map_ys.append(y)

  n_data = np.array(n_data, np.float64)

  return n_data

def getWaypointIndex(dx, dy):
  min_dist = 999999
  min_index = 0
  for i in range(len(map_xs)):
    dist = ((map_xs[i]-dx)**2 + (map_ys[i]-dy)**2) ** 0.5
    
    if min_dist > dist:
      min_dist = dist
      min_index = i

  return min_index


if __name__ == "__main__":
  rospy.init_node('waypoint_modifier')
  rospack = rospkg.RosPack()
  ROS_HOME = rospack.get_path('rviz_visualization')

  print(sys.argv)
  _, file1, x, y = sys.argv
  x = float(x)
  y = float(y)

  file_path1 = ROS_HOME + "/marker/" +file1 + ".txt"
  path_data = read_path(file_path1)
  print("PATH CNT : {}".format(len(path_data)))

  print("index: {}".format(getWaypointIndex(x, y)))
