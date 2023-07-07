#!/usr/bin/env python
#-*- encoding: utf-8 -*-

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

def getWaypointIndex(dx, dy, mode=0):
  tmp_lst = []
  min_dist = 999999
  min_index = 0
  for i in range(len(map_xs)):
    dist = ((map_xs[i]-dx)**2 + (map_ys[i]-dy)**2) ** 0.5

    if dist < 1 and abs(min_index-i) > 100: tmp_lst.append(i)
    
    if min_dist > dist:
      min_dist = dist
      min_index = i

  index2 = -1
  min_dist = 999999
  for i in range(len(tmp_lst)):
    dist = ((map_xs[i]-dx)**2 + (map_ys[i]-dy)**2) ** 0.5
    if min_dist > dist:
      min_dist = dist
      index2 = tmp_lst[i]

  if index2 != -1:
    print("{}(mode={}) : {}".format(min_index, mode, tmp_lst))
    if mode == 0: return min(min_index, index2)
    elif mode == 1: return max(min_index, index2)
    

  return min_index


if __name__ == "__main__":
  rospy.init_node('waypoint_modifier')
  rospack = rospkg.RosPack()
  ROS_HOME = rospack.get_path('rviz_visualization')


  _, file1, file2 = sys.argv


  file_path1 = ROS_HOME + "/marker/" +file1 + ".txt"
  file_path2 = ROS_HOME + "/marker/" +file2 + ".txt"
   
  path_data = read_path(file_path1)
  print("PATH CNT : {}".format(len(path_data)))
  
  
        
  f = open(file_path2, "r")
  data = f.read()
  f.close()

  data = data.strip().split('\n')
  
  idx_list = []
  for line in data:
    x = float(line.strip().split()[0])
    y = float(line.strip().split()[1])
    mode = int(line.strip().split()[2])

    if len(idx_list) == 0:
      idx_list.append([0, mode])
      continue

    # 배달 겹치는 구간 예외처리
    if 17 <= mode <= 22:
      idx_list.append([getWaypointIndex(x, y, 1), mode])
    else:
      idx_list.append([getWaypointIndex(x, y), mode])

  print(idx_list)
  for i in range(len(idx_list)-1):
    if i == len(idx_list)-2:
      path_data[idx_list[i][0]-1 : , 2] = idx_list[i][1]
    else:
      path_data[idx_list[i][0]-1 : idx_list[i+1][0], 2] = idx_list[i][1]


  new_file = open(ROS_HOME + "/marker/" + file1.split('.')[0] + ".md.txt",'w')
  out_str = ''
  for point in path_data:
      out_str += str(point[0]) + ' ' + str(point[1]) + ' ' + str(int(point[2])) + '\n'
  new_file.write(out_str[:-1])
  new_file.close()




