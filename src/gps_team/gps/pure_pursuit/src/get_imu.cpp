#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <geometry_msgs/Vector3.h>
#include <tf/tf.h>

ros::Publisher pub;

double prev_yaw = 0.0;
ros::Time prev_time;

void imuCallback(const sensor_msgs::Imu::ConstPtr& msg)
{
  // Transform the Quaternion to roll, pitch, yaw
  tf::Quaternion q(msg->orientation.x, msg->orientation.y, msg->orientation.z, msg->orientation.w);
  tf::Matrix3x3 m(q);
  double roll, pitch, yaw;
  m.getRPY(roll, pitch, yaw);

  // Convert from radians to degrees
  roll *= 180.0/M_PI;
  pitch *= 180.0/M_PI;
  yaw *= 180.0/M_PI;

  // Calculate yaw rate
  ros::Time current_time = ros::Time::now();
  double dt = (current_time - prev_time).toSec();
  double yaw_rate = (yaw - prev_yaw) / dt;

  // If the yaw rate is less than the threshold, subtract the delta yaw
  if (std::abs(yaw_rate) < 10)
  {
    yaw -= 50*yaw_rate * dt;
  }

  // Save the current yaw and time for the next callback
  prev_yaw = yaw;
  prev_time = current_time;


  ROS_INFO("Roll: %f, Pitch: %f, Yaw: %f, Yaw_RATE: %f", roll, pitch, yaw,std::abs(yaw_rate) );

  // Create and publish a Vector3 message
  geometry_msgs::Vector3 euler_msg;
  euler_msg.x = roll;
  euler_msg.y = pitch;
  euler_msg.z = yaw;

  pub.publish(euler_msg);
}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "get_imu");
  ros::NodeHandle nh;

  ros::Subscriber sub = nh.subscribe("/handsfree/imu", 1000, imuCallback);
  pub = nh.advertise<geometry_msgs::Vector3>("/euler_angles", 1000);

  ros::spin();

  return 0;
}
