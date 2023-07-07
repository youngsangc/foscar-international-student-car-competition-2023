#!/usr/bin/env python

import sys
import numpy as np

mode = 0
f_trig = False
file_name = ''
path = ''

if __name__ == "__main__":
    for i in sys.argv:
        if i == '-p':
            f_trig = True
        elif f_trig == True:
            file_name = i
            f_trig = False

    if len(file_name) == 0:
        print('The file is not exist')
        exit(-1)

    f = open(file_name, "r")
    data = f.read()
    f.close()

    data = data.rstrip().split('\n')

    f = open(file_name.split('.')[0]+'_rmMode.txt','w')
    out_str = ''
    for line in data:
        line = line.split(' ')
        out_str += line[0] + ' ' + line[1] + '\n'
    f.write(out_str)
    f.close()
