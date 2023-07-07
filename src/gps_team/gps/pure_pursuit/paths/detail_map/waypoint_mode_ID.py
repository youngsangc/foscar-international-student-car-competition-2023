#!/usr/bin/env python

import sys
import numpy as np

mode = 0
m_trig = False
f_trig = False
file_name = ''
path = ''

def parse_txt(path):
    f = open(path, "r")
    data = f.read()
    f.close()

    data = data.rstrip().split('\n')
    data = [x.split(' ')[:3]+[mode] for x in data]
    print(data)
    return data


if __name__ == "__main__":
    for i in sys.argv:
        if i == '-m':
            m_trig = True
        elif i == '-p':
            f_trig = True
        elif m_trig == True:
            mode = int(i)
            m_trig = False
        elif f_trig == True:
            file_name = i
            f_trig = False

    if len(file_name) == 0:
        print('The file is not exist')
        exit(-1)

    path = parse_txt(file_name)

    print(len(path))
    f = open(file_name.split('.')[0]+'.md.txt','w')
    out_str = ''
    for point in path:
        print(point)
        out_str += str(point[0]) + ' ' + str(point[1]) + ' ' + point[2] + ' ' + str(int(point[3])) + '\n'
    f.write(out_str[:-1])
    f.close()
