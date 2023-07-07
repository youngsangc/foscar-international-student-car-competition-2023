#!/usr/bin/env python
from pyproj import Proj, transform

f = open("2022_final_global_path_a_s_p.txt", 'r')
data = f.read()
f.close()

data = data.rstrip().split('\n')
data = [x.split(' ') for x in data]
#print(data)

f2 = open("morai_asp.txt", 'w')
outstr = ''
for d in data:
    x = float(d[0])
    y = float(d[1])
    proj_UTMK = Proj(init='epsg:5179')
    proj_UTM52N = Proj(init='epsg:32652')

    x, y = transform(proj_UTMK, proj_UTM52N, x, y)
    
    x -= 302459.942
    y -= 4122635.537

    print(x, y) 
    outstr += str(x)+' '+str(y)+' 0\n'

f2.write(outstr)
f2.close()