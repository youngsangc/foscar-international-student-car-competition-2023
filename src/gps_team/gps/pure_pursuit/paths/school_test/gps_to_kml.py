#!/usr/bin/env python

import sys
import numpy as np
import simplekml

from pyproj import Proj, transform

a = 0
b = 0
a_trig = False
b_trig = False
f_trig = False
file_name = ''
path = ''

def parse_txt(path):
    f = open(path, "r")
    data = f.read()
    f.close()

    data = data.rstrip().split('\n')
    data = [x.split(' ') for x in data]
    #print(data)
    data = np.array(data, np.float64)

    return data


if __name__ == "__main__":
    file_name = sys.argv[1]

    if len(file_name) == 0:
        print('The file is not exist')
        exit(-1)

    path = parse_txt(file_name)
    kml = simplekml.Kml()


    save_path = file_name.split('.')[0]+'.kml'

    # UTM-K
    proj_UTMK = Proj(init='epsg:5179')

    # WGS84
    proj_WGS84 = Proj(init='epsg:4326')



    # for point in path:
    #     longitude, latitude = transform(proj_UTMK, proj_WGS84, point[0], point[1])
    #     print(longitude, latitude)
    longitude, latitude = transform(proj_UTMK, proj_WGS84, path[:,0], path[:,1])
    for data in zip(longitude, latitude):
        print(data[0], data[1])
        kml.newpoint(name="(lat/long)", description="lt/longt", coords=[(data[0], data[1])])

    kml.save(save_path)
