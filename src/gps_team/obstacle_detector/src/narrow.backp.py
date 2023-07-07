#!/usr/bin/env python

import rospy
import math, time

from std_msgs.msg import String
from obstacle_detector.msg import Obstacles
from obstacle_detector.msg import SegmentObstacle
from geometry_msgs.msg import Point
from race.msg import drive_values
from math import atan2, degrees
from vision_distance.msg import Colorcone_lidar, ColorconeArray_lidar 

drive_values_pub = rospy.Publisher('control_value', drive_values, queue_size=1)
yellow_cone=[]
blue_cone=[]
sorted_colorcone=[]

is_car_start=False
prev_steering=0.0
is_first_drive=True

def cal_distance(x,y):
	return (math.sqrt(x**2+y**2))

def liner_acceleration(flag):
		global drive_speed
		in_step=0.1
		de_step=0.2
		limit_speed=7
		bottom_speed=3
		if(flag):
			if (drive_speed>=limit_speed):
				return drive_speed
			else:
				drive_speed+=in_step
				return (drive_speed)
		else:
			if (drive_speed<=bottom_speed):
				return bottom_speed
			else:
				drive_speed-=de_step
				return (drive_speed)

def colorcone_callback(msg):
	global flag, dist_x, dist_y
	global yellow_cone, blue_cone,sorted_colorcone

	

	colorcone = msg.colorcone

	#print("len(colorcone) : ",len(colorcone))
	yellow_cone=[]
	blue_cone=[]


	sorted_colorcone = sorted(colorcone, key=lambda x:(x.dist_y,x.dist_x,x.flag))
	
	if len(sorted_colorcone) > 4:
		#print("len() > 4")
		sorted_colorcone = sorted_colorcone[:4]
	
	#print("in for")
	for cor_i in range (len(sorted_colorcone)):
		if sorted_colorcone[cor_i].flag==0:
			#print("test 1")
			yellow_cone.append(sorted_colorcone[cor_i])
		else:
			#print("test 2")
			blue_cone.append(sorted_colorcone[cor_i])
	#print("len(yello_cone) : ", len(yellow_cone))	
	#print("out for")


	


def drive(angle, speed):
	global drive_values_pub
        global drive_speed
	global is_car_start
	global is_first_drive
	global prev_steering
	drive_value = drive_values()
	drive_value.steering = angle
	standard_angle=18
	check_start=0.00000001
	if (is_first_drive):
		prev_steering=drive_value.steering
		is_first_drive=False
	
	

	if (drive_value.steering>standard_angle or flag==True):
		
		drive_value.throttle=liner_acceleration(False)

	elif (drive_value.steering<-standard_angle or flag==True):
		
		drive_value.throttle=liner_acceleration(False)

	else:
		
		drive_value.throttle=liner_acceleration(True)
	
	print("prev",int(prev_steering))
	print("steer",int(drive_value.steering))
	print(is_first_drive,is_car_start)
	if (not(is_car_start)):
		print("###############################################")
		if(abs(prev_steering-drive_value.steering)):
			drive_value.throttle=8
		else:
			drive_value.throttle=8
			is_car_start=True
	prev_steering=drive_value.steering

	drive_values_pub.publish(drive_value)

	print("steer : ", drive_value.steering)
	#print("throttle : ", drive_value.throttle)
class point:
	def __init__(self):
		self.distance_min=None
		self.obData = None
		self.center_x = None
		self.center_y = None
		self.xycar_angle = None
		self.xycar_angle_deg = None
		self.xycar_angle_deg_2 = None
		self.angle=None
		self.normal_speed=6
		self.slow_speed=3

	def cal_distance_two_circle(self,x1,y1,x2,y2):
		distance=math.sqrt((x2-x1)**2+(y2-y1)**2)
		return distance

	def avoid_collision(self,min_list):
		global sorted_colorcone
		#print("distance_min",distance_min)
		point=min_list[1]
		steer=self.xycar_angle_deg
		margin=8
		try:
			print("###############################################################",sorted_colorcone[0].flag)
			if(sorted_colorcone[0].flag):
				steer-=margin
				drive(steer,Truee)
				print("--Danger---left steering")
			
			
			else:
		
				steer+=margin
				drive(steer,True)
				print("--Danger---right steering")
		except: return
			

	def circles_4_center(self,sorted_list):
		sorted_2_list=None
		sorted_2_list=sorted(sorted_list,key= lambda circle:circle.center.y)
		return sorted_2_list

	def get_center(self, obstacles):
		self.obData = obstacles

	def calc_dismin(self,p1, p2, p3, p4):
		dis1=math.sqrt(p1.x**2+p1.y**2)
		dis2=math.sqrt(p2.x**2+p2.y**2)
		dis3=math.sqrt(p3.x**2+p3.y**2)
		dis4=math.sqrt(p4.x**2+p4.y**2)
		temp_list=[[dis1,p1],[dis2,p2],[dis3,p3],[dis4,p4]]
		sorted_list=sorted(temp_list,key=lambda sub_list:(sub_list[0]))
		min_list=sorted_list[0]
		return min_list

	def calcEquidistance(self,x1, x2, x3, y1, y2, y3): #triangle circumscribed circle
    		xmAB = (x1 + x2) / 2
		ymAB = (y1 + y2) / 2
		xmBC = (x3 + x2) / 2
	 	ymBC = (y3 + y2) / 2
		xmAC = (x3 + x1) / 2
		ymAC = (y3 + y1) / 2

	    	yDiffAB = y2 - y1
	    	xDiffAB = x2 - x1
	    	yDiffBC = y3 - y2
	    	xDiffBC = x3 - x2
	    	yDiffAC = y3 - y1
	    	xDiffAC = x3 - x1

    		if yDiffAB != 0 and xDiffAB != 0:
        		a = -1 / (yDiffAB / xDiffAB)
        		a1 = ymAB - (a*xmAB)

    		if yDiffBC != 0 and xDiffBC != 0:
        		b = -1 / (yDiffBC / xDiffBC)
        		b1 = ymBC - (b*xmBC)

    		if yDiffAC != 0 and xDiffAC != 0:
        		c = -1 / (yDiffAC / xDiffAC)
        		c1 = ymAC - (c*xmAC)

    		if yDiffAB != 0 and xDiffAB != 0 and yDiffBC != 0 and xDiffBC != 0 and yDiffAC != 0 and xDiffAC != 0:
        		self.center_x = -((a1 + (-b1)) / ((-b) + a))
        		self.center_y= (b * self.center_x) + b1
			print("x: ",self.center_x, "y: ", self.center_y)
			return self.center_x,self.center_y

    		elif yDiffAB != 0 and xDiffAB != 0 and yDiffBC != 0 and xDiffBC != 0:
        		self.center_x = -((a1 + (-b1)) / ((-b) + a))
        		self.center_y = (b * self.center_x) + b1
			print("x: ",self.center_x, "y: ", self.center_y)
			return self.center_x,self.center_y


    		elif yDiffBC != 0 and xDiffBC != 0 and yDiffAC != 0 and xDiffAC != 0:
        		self.center_x = -((b1 + (-c1)) / ((-c) + b))
        		self.center_y = (c * self.center_x) + c1
			print("x: ",self.center_x, "y: ", self.center_y)
			return self.center_x,self.center_y

    		elif yDiffAB != 0 and xDiffAB != 0 and yDiffAC != 0 and xDiffAC != 0:
        		self.center_x = -((c1 + (-a1)) / ((-a) + c))
        		self.center_y = (a * self.center_x) + a1
			print("x: ",self.center_x, "y: ", self.center_y)
			return self.center_x,self.center_y

	def angle_between(self,x1, x2, x3, y1, y2, y3): #x2 angle
		deg1=(360+degrees(atan2(x1-x2,y1-y2)))%360
		deg2=(360+degrees(atan2(x3-x2,y3-y2)))%360

		return deg2-deg1 if deg1<=deg2 else 360-(deg1-deg2)

	def calc_angle(self):
		self.xycar_angle = math.atan2(self.center_y,self.center_x)
		self.xycar_angle_deg = self.xycar_angle*180/math.pi
		self.xycar_angle_deg_2 = self.xycar_angle*180/math.pi
		if (self.xycar_angle_deg > 30): self.xycar_angle_deg = 30
		elif (self.xycar_angle_deg < -30): self.xycar_angle_deg = -30

		if (self.xycar_angle_deg_2 > 30): self.xycar_angle_deg_2 = 30
		elif (self.xycar_angle_deg_2 < -30): self.xycar_angle_deg_2 = -30
		#print("Angle deg : ", self.xycar_angle_deg)

	def circle(self):
		#global yellow_cone
		#global blue_cone
		

		#print("###################", len(yellow_cone))
		print("CNT:",len(self.obData.circles))
		if len(self.obData.circles) == 0:
			print("zero obstacle")
			drive(0,False)

		elif len(self.obData.circles) == 1:
			circles=self.obData.circles
			if len(yellow_cone)>=1 and len(blue_cone)==0 : 
			
				drive(25,True)
			 	print("one obstacle detected && right steering")
				print("yellow111",len(yellow_cone),"blue",len(blue_cone))
			else: 
				drive(-25,True)
				print("one obstacle detected && left steering")
				print("yellow222",len(yellow_cone),"blue",len(blue_cone))				




		else:
			print("yellow333",len(yellow_cone),"blue",len(blue_cone))
			circles=self.obData.circles # List of Circles Data
			#print("Circle:",self.obData.circles[0].center.x)
			left_circle=None
			right_circle=None
			sorted_list=[1,2,3,4]
			sorted_list_3=[1,2,3]
			a=1.4
	        	b=0.1
			'''
			if len(blue_cone) == 0:
				print("blue cone is not detected!!")
				drive(30,self.normal_speed)
			if len(yellow_cone) == 0:
				print("yellow cone is not detected!!")
				drive(-30,self.normal_speed)'''
 			if(len(circles)==2):
		
		
				if(circles[0].center.y<circles[1].center.y):  #judgement left & right
					left_circle=circles[0]
					right_circle=circles[1]

				else:
					left_circle=circles[1]
					right_circle=circles[0]
	
				self.two_circle_distance=self.cal_distance_two_circle(left_circle.center.x,left_circle.center.y,right_circle.center.x,right_circle.center.y)
				self.two_between = self.angle_between(right_circle.center.x,left_circle.center.x,0,right_circle.center.y,left_circle.center.y,0)


				if (len(yellow_cone)>=1) and len(blue_cone)==0 :
 #(self.two_circle_distance>3.0 and left_circle.center.x + 0.4 < right_circle.center.x and self.two_between > 90):
					print("two_obstacle_right")
					drive(30,False)
				else:	
					#print("left_circle:",left_circle.center.y,"right_circle:",right_circle.center.y)
					left_point=left_circle.center
					right_point=right_circle.center
					self.center_x=(left_point.x+right_point.x)/2
					self.center_y=(left_point.y+right_point.y)/2
					self.calc_angle()
					drive(self.xycar_angle_deg,True)


			elif (len(circles)==3):
				sorted_first_list=sorted(circles,key= lambda circle:circle.center.x)
				sorted_list_3[0]=sorted_first_list[0]
				sorted_list_3[1]=sorted_first_list[1]
				sorted_list_3[2]=sorted_first_list[2]

				sorted_2_list=self.circles_4_center(sorted_list_3)

				filter_point1=sorted_2_list[0].center
				filter_point2=sorted_2_list[1].center
				filter_point3=sorted_2_list[2].center

				self.center_x,self.center_y=self.calcEquidistance(filter_point1.x,filter_point2.x,filter_point3.x,filter_point1.y,filter_point2.y,filter_point3.y)
				self.calc_angle()
				if len(yellow_cone)>=2 and len(blue_cone)==0:
					self.xycar_angle_deg+=5
					drive(self.xycar_angle_deg,self.normal_speed)
					
				else:								#self.three_detected_obstacles=self.angle_between(filter_point1.x,filter_point2.x,filter_point3.x,filter_point1.y,filter_point2.y,filter_point3.y)
					drive(self.xycar_angle_deg,self.normal_speed)
					#print("angle: ",self.three_detected_obstacles)

			else:
				sorted_first_list=sorted(circles,key= lambda circle:circle.center.x)
				sorted_list[0]=sorted_first_list[0]
				sorted_list[1]=sorted_first_list[1]
				sorted_list[2]=sorted_first_list[2]
				sorted_list[3]=sorted_first_list[3]

				sorted_2_list=self.circles_4_center(sorted_list)

				left_circle_1=sorted_2_list[0]
				left_circle_2=sorted_2_list[1]
				right_circle_1=sorted_2_list[2]
				right_circle_2=sorted_2_list[3]
				left_point1=left_circle_1.center
				left_point2=left_circle_2.center
				right_point1=right_circle_1.center
				right_point2=right_circle_2.center

				self.center_x=(left_point1.x+left_point2.x+right_point1.x+right_point2.x)/4
				self.center_y=(left_point1.y+left_point2.y+right_point1.y+right_point2.y)/4
				print("x: ", self.center_x, "y : ", self.center_y)
				self.calc_angle()
				if len(yellow_cone)>=2 and len(blue_cone)==0:

					self.xycar_angle_deg=self.xycar_angle_deg_2
					self.xycar_angle_deg_2+=5
					drive(self.xycar_angle_deg_2,self.slow_speed)
					#print(" xycar_deg_2: ", self.xycar_angle_deg_2)
					
					min_list=self.calc_dismin(left_point1,left_point2,right_point1,right_point2)
					
					#print('center_y:' ,self.center_y)
					if(min_list[0]<1.5 and abs(min_list[1].y)<1.1):
						self.avoid_collision(min_list)
						
					else:
						drive(self.xycar_angle_deg,self.normal_speed)
						
						return
				else:
					min_list=self.calc_dismin(left_point1,left_point2,right_point1,right_point2)
					
					#print('center_y:' ,self.center_y)
					if(min_list[0]<1.5 and abs(min_list[1].y)<1.1):
						self.avoid_collision(min_list)
						

				
					else:
						drive(self.xycar_angle_deg,self.normal_speed)
						
						return



if __name__=='__main__':
	global yellow_cone, blue_cone
	ob=point()
	rospy.Subscriber("/obstacles",Obstacles, ob.get_center, queue_size=1)
	rospy.Subscriber("color_cone", ColorconeArray_lidar, colorcone_callback)
	rospy.init_node('test3')
	time.sleep(1)
	while not rospy.is_shutdown():
		time.sleep(0.1)
		ob.circle()
		yellow_cone = []
		blue_cone = []

	print('Done')
