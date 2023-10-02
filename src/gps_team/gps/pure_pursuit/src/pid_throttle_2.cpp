#include <ros/ros.h>
#include <std_msgs/Float64.h>
#include <race/drive_values.h>
#include <message_filters/subscriber.h>
#include <message_filters/sync_policies/approximate_time.h>

ros::Publisher drive_msg_pub;

class PIDImpl {
public:
    PIDImpl(double dt, double max, double min, double Kp, double Ki, double Kd)
    : _dt(dt), _max(max), _min(min), _Kp(Kp), _Ki(Ki), _Kd(Kd), _pre_error(0), _integral(0) {}

    double calculate(double setpoint, double pv) {
        // Calculate error
        double error = setpoint - pv;

        // Proportional term
        double Pout = _Kp * error;

        // Integral term
        _integral += error * _dt;
        double Iout = _Ki * _integral;

        // Derivative term
        double derivative = (error - _pre_error) / _dt;
        double Dout = _Kd * derivative;

        // Calculate total output
        double output = Pout + Iout + Dout;

        // Restrict to max/min
        if (output > _max) output = _max;
        else if (output < _min) output = _min;

        // Save error to previous error
        _pre_error = error;

        return output;
    }

private:
    double _dt;
    double _max;
    double _min;
    double _Kp;
    double _Ki;
    double _Kd;
    double _pre_error;
    double _integral;
};

double current_speed = 0;
double goal_throttle = 0;
double control_throttle = 0;
double prev_speed = 0;

double max_limit_throttle = 0;
double min_limit_throttle = 0;

PIDImpl pid(0.05, 255, 0, 1.0, 0.05, 0.1);
// PIDImpl pid(0.05, 255, 0, 0.6, 0.2, 0.01);
// PIDImpl pid(0.05, 255, 0, 0.2, 0.15, 0.1); // Here the dt is set to 0.05 assuming a 20Hz loop rate

// void syncCallback(const std_msgs::Float64ConstPtr& speed_msg, const race::drive_values::ConstPtr& control_msg) {
//     current_speed = speed_msg->data;
//     goal_throttle = control_msg->throttle;

//     control_throttle = pid.calculate(goal_throttle, current_speed);

//     race::drive_values drive_msg;
//     drive_msg.throttle = control_throttle;
   
//     drive_msg_pub.publish(drive_msg);
   

//     // Here you might want to publish the control_throttle to actuate your system
// }

void PIDCallback(const std_msgs::Float64& msg){

    current_speed = msg.data;
    if (current_speed == 0){
        current_speed = prev_speed;
    } else{
        prev_speed = current_speed;
    }

    control_throttle = pid.calculate(goal_throttle, current_speed);

    // if (pid.calculate(goal_throttle, current_speed) >= max_limit_throttle){
    //     control_throttle = max_limit_throttle;
    // } else{
    //     control_throttle = pid.calculate(goal_throttle, current_speed);
    // }



    // if (control_throttle > max_limit_throttle) {
    //     control_throttle = max_limit_throttle;
    // } else{
    //     control_throttle = pid.calculate(goal_throttle, current_speed);
    // }

    std::cout<<"goal_throttle : "<< goal_throttle <<std::endl;

    std::cout<<"control_throttle : "<< control_throttle <<std::endl;

    race::drive_values drive_msg;
    drive_msg.throttle = control_throttle;
   
    drive_msg_pub.publish(drive_msg);
}

void serialCallback(const race::drive_values::ConstPtr& msg) {
    goal_throttle = msg->throttle;
    max_limit_throttle = goal_throttle + 5;
}



int main(int argc, char** argv) {
    ros::init(argc, argv, "pid_throttle_2");
    ros::NodeHandle nh;

    // message_filters::Subscriber<std_msgs::Float64> speed_sub(nh, "current_speed", 1);
    // message_filters::Subscriber<race::drive_values> control_value_sub(nh, "control_value", 1);

    ros::Subscriber speed_sub = nh.subscribe("current_speed", 100, PIDCallback); // 1초에 20번만 PID제어 하도록 하고 싶음.
    ros::Subscriber control_value_sub = nh.subscribe("control_value", 10, serialCallback);





    drive_msg_pub = nh.advertise<race::drive_values>("pid_control_value", 1);

    // typedef message_filters::sync_policies::ApproximateTime<std_msgs::Float64, race::drive_values> MySyncPolicy;
    // message_filters::Synchronizer<MySyncPolicy> sync(MySyncPolicy(10), speed_sub, control_value_sub);
    // sync.registerCallback(boost::bind(&syncCallback, _1, _2));

    ros::spin();

    return 0;
}