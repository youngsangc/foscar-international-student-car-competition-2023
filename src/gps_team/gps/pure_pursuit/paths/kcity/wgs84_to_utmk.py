#!/usr/bin/env python

import sys
import numpy as np

from pyproj import Proj, transform

mode = 0
file_name = ''
path = ''



if __name__ == "__main__":
  file1, longitude, latitude = sys.argv
  longitude = float(longitude)
  latitude = float(latitude)

  # UTM-K
  proj_UTMK = Proj(init='epsg:5179')

  # WGS84
  proj_WGS84 = Proj(init='epsg:4326')

  x, y = transform(proj_WGS84, proj_UTMK, longitude, latitude)
  print(x,y)
