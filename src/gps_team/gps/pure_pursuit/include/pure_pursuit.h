#ifndef PURE_PURSUIT_PURE_PURSUIT_H
#define PURE_PURSUIT_PURE_PURSUIT_H

// ROS includes
#include <ros/ros.h>

#include <geometry_msgs/PoseStamped.h>
#include <geometry_msgs/TwistStamped.h>
#include <tf/transform_datatypes.h>

// C++ includes
#include <vector>
#include <obstacles.h>
#include <darknet_ros_msgs/BoundingBox.h>
#include <darknet_ros_msgs/BoundingBoxes.h>
#include <vision_distance/DeliveryArray.h>

namespace waypoint_follower
{
class PurePursuit
{
public:
  PurePursuit();
  ~PurePursuit();

  // for setting data
  void setLookaheadDistance(const double& ld)
  {
    lookahead_distance_ = ld;
  }
  void setWaypoints(const std::vector<std::pair<geometry_msgs::Point, int>>& wps);

  void setCurrentPose(const geometry_msgs::PoseStampedConstPtr& msg)
  {
    current_pose_ = msg->pose;
  }

  // processing
  bool canGetCurvature(double* output_kappa);

  // for target point visualization
  geometry_msgs::Point getPoseOfNextTarget() const
  {
    return next_target_position_;
  }

  geometry_msgs::Point getCurrentPose() const
  {
    return current_position;
  }

// private:
  // variables
  int next_waypoint_number_;
  int current_idx;
  bool is_finish;

  geometry_msgs::Point next_target_position_;
  geometry_msgs::Point current_position;

  double lookahead_distance_;
  geometry_msgs::Pose current_pose_;
  std::vector<std::pair<geometry_msgs::Point, int>> waypoints;
  int mode;
  int mission_flag;
  //bool current_idx_flag;

  // for main control
  double gps_velocity;
  double gps_yaw;

  int is_obstacle_detected;
  bool is_dynamic_obstacle_detected_short;
  bool is_dynamic_obstacle_detected_long;
  bool is_static_obstacle_detected_short;
  bool is_static_obstacle_detected_long;
  bool is_parking_rubbercone_detected;

  int static_obstacle_flag;
  bool straight_go_flag;
  bool left_go_flag;
  int is_obstacle_detected_8m;
  int is_delivery_obs_stop_detected;
  int is_delivery_obs_calc_detected;
  

  // for delivery
  int delivery_angle; //표지판과 라이다 사이의 각도
  int delivery_x;     //표지판과 라이다 사이의 x 거리
  
  
  bool a1_flag = false;
  bool a2_flag = false;
  bool a3_flag = false;
  bool b1_flag = false;
  bool b2_flag = false;
  bool b3_flag = false;

  std::vector<int> a_cnt = std::vector<int>(3,0);
  std::vector<int> b_cnt = std::vector<int>(3,0);
  std::vector<int> a_flag= std::vector<int>(3,0);
  std::vector<int> b_flag= std::vector<int>(3,0);
  // int a1_cnt = 0;
  // int a2_cnt = 0;
  // int a3_cnt = 0;

  std::vector<Obstacle> obstacles;


  // functions
  double calcCurvature(geometry_msgs::Point target) const;
  void getNextWaypoint();
  int getPosIndex(float x, float y, int mode=0);

  bool reachMissionIdx(int target_idx);
};

// also from autoware
geometry_msgs::Point calcRelativeCoordinate(geometry_msgs::Point point_msg, geometry_msgs::Pose current_pose);
double getPlaneDistance(geometry_msgs::Point target1, geometry_msgs::Point target2);
tf::Vector3 point2vector(geometry_msgs::Point point);


}  // namespace waypoint_follower

#endif  // PURE_PURSUIT_PURE_PURSUIT_H
