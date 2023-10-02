#!/usr/bin/env python3

from pyproj import Transformer, CRS, Proj
import rospy
from geometry_msgs.msg import Point
from sensor_msgs.msg import NavSatFix

pub = None

# def wgs84_to_utmk(data):
#     global pub
#     latitude = data.latitude
#     longitude = data.longitude
#     utmk_coordinate = Point() 

#     # UTM-K
#     proj_UTMK = CRS('EPSG:5179')

#     # WGS84
#     proj_WGS84 = CRS('EPSG:4326')

#     proj_UTM = Proj(proj='utm', zone = 52, elips='WGS84', preserve_units=False)


#     # 좌표계 변환 객체 생성
#     #transformer = Transformer.from_crs(proj_WGS84, proj_UTMK, always_xy=True)
#     xy_zone = proj_UTM(longitude, latitude)

    
#     # 좌표 변환
#     #x, y = transformer.transform(longitude, latitude)
#     x, y = xy_zone[0], xy_zone[1]

#     utmk_coordinate.x = x
#     utmk_coordinate.y = y
#     utmk_coordinate.z = 0

#     #print(utmk_coordinate.x, utmk_coordinate.y)

#     pub.publish(utmk_coordinate)
def wgs84_to_utmk(data):
    global pub
    latitude = data.latitude
    longitude = data.longitude
    utmk_coordinate = Point() 

    # UTM-K
    proj_UTMK = CRS('EPSG:5179')

    # WGS84
    proj_WGS84 = CRS('EPSG:4326')

    # 좌표계 변환 객체 생성
    transformer = Transformer.from_crs(proj_WGS84, proj_UTMK, always_xy=True)
    
    # 좌표 변환
    x, y = transformer.transform(longitude, latitude)
    
    utmk_coordinate.x = x
    utmk_coordinate.y = y
    utmk_coordinate.z = 0

    #print(utmk_coordinate.x, utmk_coordinate.y)

    pub.publish(utmk_coordinate)

if __name__ == "__main__":
    rospy.init_node("wgs84_to_utmk")
    rospy.Subscriber("/gps_front/fix", NavSatFix, wgs84_to_utmk)
    pub = rospy.Publisher("/utmk_coordinate", Point, queue_size = 1)

    while not rospy.is_shutdown():
        pass

