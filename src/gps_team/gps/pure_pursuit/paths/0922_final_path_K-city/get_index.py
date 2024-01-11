#!/usr/bin/env python3
import os
import sys
import numpy as np
import rospy, rospkg

file_path = ''
path = ''
map_xs = []
map_ys = []

# def read_path(path):
#   n_data = []
#   f = open(path, "r")
#   data = f.read()
#   f.close()

#   data = data.strip().split('\n')
 
#   for line in data:
#     x = float(line.strip().split()[0])
#     y = float(line.strip().split()[1])

#     vec = line.split()
#     if len(vec) == 2:
#       vec += [0]
#     n_data.append(vec)


#     map_xs.append(x)
#     map_ys.append(y)

#   n_data = np.array(n_data, np.float64)

#   return n_data
def read_path(path,directory):
  n_data = []
  f = open(directory+'/'+path, "r")
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
  if len(sys.argv) < 2:
    print("사용법:  python3 get_index.py 파일명")
    sys.exit(1)
  file_path= sys.argv[1]
  python_path=os.path.abspath(__file__)
  current_directory= os.path.dirname(python_path)
  path= read_path(file_path,current_directory)
  while(True):
     print("실행을 그만하고 싶으면 1을 누르시오",end=' ')
     a=int(input())
     if a==1:
       break
     x,y=map(float, input('x,y 좌표를 입력하세요: ').split())
     idx=getWaypointIndex(x,y)
     print("해당 변수의 index는 {0}입니다.".format(idx+1))    
     
    


