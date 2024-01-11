#!/usr/bin/env python3
from itertools import count
import os
import sys
import numpy as np

file_path = ''
path = ''

def parse_txt(path,directory):
    real_path=directory+'/'+path
    f = open(real_path, "r")
    data = f.read()
    f.close()
    data = data.strip().split('\n')
    n_data = []
    for s in data:
        vec=s.split(' ')
        if len(vec) == 2:
            vec += [0]
        n_data.append(vec)
    data = n_data
    data = np.array(data, np.float64)
    return data


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("사용법:  python3 waypoint_modechanger.py 파일명")
        sys.exit(1)
    file_path= sys.argv[1]
    python_path=os.path.abspath(__file__)
    current_directory= os.path.dirname(python_path)
    print(current_directory)
    path= parse_txt(file_path,current_directory)
    while(True):
        print("수정을 그만하고 싶으면 1을 누르시오",end=' ')
        a=int(input())
        if a==1:
            break
        print("수정을 원하는 시작 인덱스를 정해주세요:",end=' ')
        start_idx=int(input())
        print("수정을 원하는 마지막 인덱스를 정해주세요:",end=' ')
        end_idx=int(input())
        print("수정을 원하는 모드를 정해주세요:",end=' ')
        mode=int(input())
        path[start_idx-1:end_idx,2]=mode
    f= open(file_path.split('.')[0]+'.md.txt','w')
    out_str = ''
    for point in path:
        print(point)
        out_str += str(point[0]) + ' ' + str(point[1]) + ' ' + str(int(point[2])) + '\n'
    f.write(out_str[:-1])
    f.close()
