////////////

#include <ros/ros.h>
#include <iostream>
#include <std_msgs/Int32.h>
#include <std_msgs/Float64.h>
// #include <serial/serial.h>
#include <std_msgs/String.h>
#include <std_msgs/Empty.h>
#include <std_msgs/Int32.h>
#include <race/drive_values.h>
#include <string>
#include <stdlib.h>
#include <cstdlib>
#include <cstring>
#include <sstream>
#include <time.h>

ros::Publisher drive_msg_pub;

double current_speed; // 받아온 현재 속도
unsigned int goal_throttle = 0; // 받아온 목표 throttle
double control_throttle = 0; // 제어하고자 하는 throttle

// PID Control
double KP = 0.6; // 임시값
double KI = 0.01; // 적분
double KD = 10.0; // 미분

double error_curr = -1;
double error_prev = -1;

double control;
double pterm;
double dterm;
double iterm = 0;

double goal_throttle_min; // +-2로 설정할 예정
double goal_throttle_max;
double throttle_chg_per_interval = 0.2; // 임의 설정

using namespace std;

void PIDCallback(const std_msgs::Float64& msg){

    current_speed = msg.data;
    
    if (goal_throttle != 0) {

        goal_throttle_min = goal_throttle - 1.0;
        goal_throttle_max = goal_throttle + 1.0;

        error_prev = error_curr;
        error_curr = goal_throttle - current_speed;

        pterm = KP * error_curr; 
        dterm = KD * (error_curr - error_prev);
        iterm += KI * error_curr;
        control = pterm + dterm + iterm;

        control_throttle = current_speed + control;
        control_throttle = min(max(control_throttle, goal_throttle_min), goal_throttle_max);

        if (goal_throttle > control_throttle) {
            control_throttle += throttle_chg_per_interval;

            if (goal_throttle < control_throttle){
                control_throttle = goal_throttle;
            } 
        }
        else {
            control_throttle -= throttle_chg_per_interval;

            if (goal_throttle < control_throttle){
                control_throttle = goal_throttle;
            } 
        }
        
        cout << "받아온 현재 speed: " << current_speed << endl; 
        cout << "pterm: " << pterm << " iterm: " << iterm << " dterm: " << dterm << endl;
        cout << " 목표 throttle: " << goal_throttle << "pid throttle" << control_throttle << endl;

        race::drive_values drive_msg;
        drive_msg.throttle = control_throttle;

        drive_msg_pub.publish(drive_msg);
    }
    usleep(100);
}

void serialCallback(const race::drive_values::ConstPtr& msg) {
    goal_throttle = msg->throttle;

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "pid_throttle");
  ros::NodeHandle nh;

  ros::Subscriber speed_sub = nh.subscribe("current_speed", 100, PIDCallback); // 1초에 20번만 PID제어 하도록 하고 싶음.
  ros::Subscriber control_value_sub = nh.subscribe("control_value", 100, serialCallback);
  drive_msg_pub = nh.advertise<race::drive_values>("pid_control_value", 1);
  

  while (ros::ok())
  {
    ros::spinOnce();
  }

}