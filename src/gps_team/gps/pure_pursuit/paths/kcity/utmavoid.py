from pyproj import Proj, transform
import numpy as np

f = open("avoid.txt", 'r')
data = f.read()
f.close()

data = data.rstrip().split('\n')
data = [x.split(' ') for x in data]
#print(data)

f2 = open("tr_avoid.txt", 'w')
outstr = ''
for d in data:
	print(d)
	x = float(d[0]) + 302459.942
	y = float(d[1]) + 4122635.537

	proj_UTMK = Proj(init='epsg:5179')
	proj_UTM52N = Proj(init='epsg:32652')

	x, y = transform(proj_UTM52N, proj_UTMK, x, y)
	print(x, y)
	outstr += str(x)+' '+str(y)+' 7\n'

f2.write(outstr)
f2.close()
