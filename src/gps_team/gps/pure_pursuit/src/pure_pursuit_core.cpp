#include <vector>
#include <pure_pursuit_core.h>
#include <fstream>
#include <cstdlib>
#include <unistd.h>
#include <time.h>
#include <chrono>
#include <algorithm>


#include <tf/transform_broadcaster.h>

namespace waypoint_follower
{
// Constructor
PurePursuitNode::PurePursuitNode()
  : private_nh_("~")
  , pp_()
  , LOOP_RATE_(30)
  , is_waypoint_set_(false)
  , is_pose_set_(false)
  , const_lookahead_distance_(4.0)
  , const_velocity_(3.0)
  , final_constant(1.0)
  , obs_is_left(1)
{
  initForROS();
}

// Destructor
PurePursuitNode::~PurePursuitNode() {}

// obstacle global variable
float tmp_yaw_rate = 0.0;

bool left_detected = false;
bool left_avoid = false;
bool right_detected = false;
bool right_avoid = false;

float target_dist = 3.0;
float min_dist = 1.0;

int obs_cnt = 0;
std::chrono::system_clock::time_point obs_start;

/* traffic Index manager */
int tf_idx_1 = 1000; // 1180
int tf_idx_2 = 1000; // 1455

bool tf_flag = false;
const float tf_coord1[2] = {935574.25, 1915924.125};
const float tf_coord2[2] = {935625.375, 1915922.75};

/*************************/

// float tmp_distance = 100.0;
///////////////////////////////

void PurePursuitNode::initForROS()
{
  // ros parameter settings
  private_nh_.param("const_lookahead_distance", const_lookahead_distance_, 4.0);
  private_nh_.param("const_velocity", const_velocity_, 3.0);
  private_nh_.param("final_constant", final_constant, 1.0);
  private_nh_.param("obs_is_left", obs_is_left, 1);

  nh_.param("vehicle_info/wheel_base", wheel_base_, 1.04);

  ROS_HOME = ros::package::getPath("pure_pursuit");

  // setup subscriber
  pose_sub = nh_.subscribe("current_pose", 1,
    &PurePursuitNode::callbackFromCurrentPose, this);

  // for main control
  obstacle_sub = nh_.subscribe("true_obs", 1,
    &PurePursuitNode::callbackFromObstacle, this);
  obstacle_sub2 = nh_.subscribe("detected_obs", 1,
    &PurePursuitNode::callbackFromObstacle2, this);
  traffic_light_sub = nh_.subscribe("darknet_ros/bounding_boxes",1,
    &PurePursuitNode::callbackFromTrafficLight, this);


  // setup publisher
  drive_msg_pub = nh_.advertise<race::drive_values>("control_value", 1);
  steering_vis_pub = nh_.advertise<geometry_msgs::PoseStamped>("steering_vis", 1);

  // for visualization
  target_point_pub = nh_.advertise<geometry_msgs::PointStamped>("target_point", 1);
  current_point_pub = nh_.advertise<geometry_msgs::PointStamped>("current_point", 1);
}

void PurePursuitNode::run(char** argv) {
  ROS_INFO_STREAM("pure pursuit start");

  // temp
  const_lookahead_distance_ = atof(argv[2]);
  const_velocity_ = atof(argv[3]);
  final_constant = atof(argv[4]);

  // 1이면 왼오(default), 0이면 오왼
  obs_is_left = atoi(argv[5]);
  //////////////////////////

  // 0이면 오왼이므로 callback 함수를 바꿔줌
  if(!obs_is_left){
    obstacle_sub2 = nh_.subscribe("detected_obs", 1, &PurePursuitNode::callbackFromObstacle3, this);
  }


  ros::Rate loop_rate(LOOP_RATE_);
  while (ros::ok()) {
    ros::spinOnce();

    if (!is_waypoint_set_) {
      setPath(argv);
      pp_.setWaypoints(global_path);
    }

    if (!is_pose_set_) {
      loop_rate.sleep();
      continue;
    }

    pp_.setLookaheadDistance(computeLookaheadDistance());

    double kappa = 0;
    bool can_get_curvature = pp_.canGetCurvature(&kappa);

    // target point visualization
    publishTargetPointVisualizationMsg();
    publishCurrentPointVisualizationMsg();

    if(!tf_flag){
      tf_flag = true;
      tf_idx_1 = pp_.getPosIndex(tf_coord1[0], tf_coord1[1]);
      tf_idx_2 = pp_.getPosIndex(tf_coord2[0], tf_coord2[1]);
    }

    // ROS_INFO("MODE: %d, CURRENT_INDEX: %d", pp_.mode, pp_.current_idx);


    // 마지막 waypoint 에 다다랐으면 멈추기
    if(pp_.is_finish){
      pulishControlMsg(0,0);
      // ROS_INFO_STREAM("Finish Pure Pursuit");
      continue;
    }

    // MODE 0 - Normal 직진구간
    if(pp_.mode == 0){
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 12;
      final_constant = 1.2;
    }

    // MODE 1 - Normal 커브구간
    if (pp_.mode == 1) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 4;
      const_velocity_ = 10;
      final_constant = 1.5;
    }

    // MODE 2 : 신호등 (직진구간)
    if (pp_.mode == 2) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 8;
      final_constant = 1.2;

      // 첫 신호등 인덱스 : tf_idx_1
      if(pp_.reachMissionIdx(tf_idx_1) && !pp_.straight_go_flag) {
        pulishControlMsg(0,0);
        continue;
      }
    }


    // MODE 3 : 동적 장애물 & 신호등
      if (pp_.mode == 3) {
        const_lookahead_distance_ = 6;
        final_constant = 1.2;

        if(pp_.mission_flag == 0) const_velocity_ = 6;

        // 장애물 멈추기
        if (pp_.mission_flag == 0 && pp_.is_obstacle_detected)
        {
          while(pp_.is_obstacle_detected) {

            pulishControlMsg(0, 0);

            std::cout << pp_.is_obstacle_detected << std::endl;
            ROS_INFO_STREAM("OBSTACLE DETECT");
            // 1초
            //usleep(1000000);
            ros::spinOnce();
            loop_rate.sleep();
          }
          pp_.mission_flag = 1;
          const_velocity_ = 8;
        }

        // 두번째 신호등 인덱스
        if(pp_.reachMissionIdx(tf_idx_2) && !pp_.straight_go_flag) {
          ROS_INFO_STREAM("TRAFFIC LIGTHS DETECT");
          pulishControlMsg(0,0);
          continue;
        }

      }

    // 정적장애물 전 직진
    if (pp_.mode == 6){
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 6;
      final_constant = 1.2;

    }


/*************************************************************************************************************/
    // // MODE 4 : 정적 장애물 구간(드럼통)
    if (pp_.mode == 4) {
      const_lookahead_distance_ = 3;
      const_velocity_ = 5;
      final_constant = 1.2;

      ROS_INFO("OBS_FLAG : %d", obs_is_left);

      // 왼 오
      if(obs_is_left){
        if(!pp_.static_obstacle_flag && left_detected)
        {
          ROS_INFO_STREAM("Detect First Obstacle & Change Flag to 1");
          pp_.static_obstacle_flag = 1;
          pulishControlMsg(3, 20);
        }
        else if(pp_.static_obstacle_flag == 1 && left_detected && tmp_yaw_rate > 5 && tmp_yaw_rate < 35)
        {
          ROS_INFO_STREAM("Avoid Left Obstacle");
          pulishControlMsg(3, 20);
        }
        else if(pp_.static_obstacle_flag == 1 && !left_detected && !left_avoid)
        {
          ROS_INFO_STREAM("Pass the First Obstacle & Change Flag to 2");
          left_avoid = true;
          pp_.static_obstacle_flag = 2;
          pulishControlMsg(3,-3);
        }
        else if(pp_.static_obstacle_flag == 2 && left_avoid && left_detected && tmp_yaw_rate >= 0 && tmp_yaw_rate < 60)
        {
          ROS_INFO_STREAM("Pass First Obstacle & Yaw to Straight");
          pulishControlMsg(3, -24);
        }
        else if(pp_.static_obstacle_flag == 2 && left_avoid && right_detected && tmp_yaw_rate < 0 && tmp_yaw_rate > -60)
        {
          ROS_INFO_STREAM("Change Flag to 3");
          pp_.static_obstacle_flag = 3;
          pulishControlMsg(3, -24);
        }
        else if(pp_.static_obstacle_flag == 3 && left_avoid && right_detected && tmp_yaw_rate < -5 && tmp_yaw_rate > -60)
        {
          ROS_INFO_STREAM("Avoid Right Obstacle");
          pulishControlMsg(3, -24);
        }
        else if(pp_.static_obstacle_flag == 3 && left_avoid && !right_detected)
        {
          ROS_INFO_STREAM("Finish the Static Obstacle 1");
          pp_.static_obstacle_flag = 4;
          pulishControlMsg(3,0);
        }

        if(pp_.static_obstacle_flag > 0 && pp_.static_obstacle_flag < 4)
          continue;
      }

      // 오 왼
      else{
        if(!pp_.static_obstacle_flag && right_detected)
        {
          ROS_INFO_STREAM("Detect First Obstacle & Change Flag to 1");
          pp_.static_obstacle_flag = 1;
          pulishControlMsg(3, -20);
        }
        else if(pp_.static_obstacle_flag == 1 && right_detected && tmp_yaw_rate < -5 && tmp_yaw_rate > -45)
        {
          ROS_INFO_STREAM("Avoid Right Obstacle");
          pulishControlMsg(3, -20);
        }
        else if(pp_.static_obstacle_flag == 1 && !right_detected && !right_avoid)
        {
          ROS_INFO_STREAM("Pass the First Obstacle & Change Flag to 2");
          right_avoid = true;
          pp_.static_obstacle_flag = 2;
          pulishControlMsg(3,5);
        }
        else if(pp_.static_obstacle_flag == 2 && right_avoid && right_detected && tmp_yaw_rate < 0 && tmp_yaw_rate > -45)
        {
          ROS_INFO_STREAM("Pass First Obstacle & Yaw to Straight");
          pulishControlMsg(3, 20);
        }
        else if(pp_.static_obstacle_flag == 2 && right_avoid && left_detected && tmp_yaw_rate >= 0 && tmp_yaw_rate < 50)
        {
          ROS_INFO_STREAM("Change Flag to 3");
          pp_.static_obstacle_flag = 3;
          pulishControlMsg(3, 24);
        }
        else if(pp_.static_obstacle_flag == 3 && right_avoid && left_detected && tmp_yaw_rate > 5 && tmp_yaw_rate < 50)
        {
          ROS_INFO_STREAM("Avoid Right Obstacle");
          pulishControlMsg(3, 24);
        }
        else if(pp_.static_obstacle_flag == 3 && right_avoid && !left_detected)
        {
          ROS_INFO_STREAM("Finish the Static Obstacle 1");
          pp_.static_obstacle_flag = 4;
          pulishControlMsg(3,0);

          const_lookahead_distance_ = 4;
          const_velocity_ = 4;
        }

        if(pp_.static_obstacle_flag > 0 && pp_.static_obstacle_flag < 4)
          continue;
      }
    }



    // MODE 5 - 직선 구간 (부스터)
    if(pp_.mode == 5){
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 17;
      final_constant = 1.2;

      geometry_msgs::Point green_point = pp_.waypoints.at(pp_.current_idx).first;
      geometry_msgs::Point pink_point = pp_.waypoints.at(pp_.next_waypoint_number_).first;
      double yaw = atan2(2.0 * (pp_.current_pose_.orientation.x * pp_.current_pose_.orientation.w + pp_.current_pose_.orientation.y * pp_.current_pose_.orientation.z), 1.0 - 2.0 * (pp_.current_pose_.orientation.z * pp_.current_pose_.orientation.z + pp_.current_pose_.orientation.w * pp_.current_pose_.orientation.w));
      // double yaw = atan2(2.0 * (pp_.current_pose_.orientation.w * pp_.current_pose_.orientation.z + pp_.current_pose_.orientation.x * pp_.current_pose_.orientation.y), 1.0 - 2.0 * (pp_.current_pose_.orientation.y * pp_.current_pose_.orientation.y + pp_.current_pose_.orientation.z * pp_.current_pose_.orientation.z));
      double map_yaw = atan2(pink_point.y - green_point.y, pink_point.x - green_point.x);

      double map_diff = fabs(yaw - map_yaw);
      double distance = getPlaneDistance(pp_.current_pose_.position, green_point);
      // std::cout << map_diff << ", " << distance << std::endl;

    }



    publishPurePursuitDriveMsg(can_get_curvature, kappa);

    is_pose_set_ = false;
    loop_rate.sleep();
  }
}

// void PurePursuitNode::publishPurePursuitDriveMsg(const bool& can_get_curvature, const double& kappa){
//   double throttle_ = can_get_curvature ? const_velocity_ : 0;

//   double steering_radian = convertCurvatureToSteeringAngle(wheel_base_, kappa);
//   double steering_ = can_get_curvature ? (steering_radian * 180.0 / M_PI) * -1 * final_constant: 0;

//   // std::cout << "steering : " << steering_ << "\tkappa : " << kappa <<std::endl;
//   pulishControlMsg(throttle_, steering_);

//   // for steering visualization
//   publishSteeringVisualizationMsg(steering_radian);
// }

void PurePursuitNode::publishPurePursuitDriveMsg(const bool& can_get_curvature, const double& kappa, const double& brake) {
  double throttle_ = can_get_curvature ? const_velocity_ : 0;
  double steering_radian = convertCurvatureToSteeringAngle(wheel_base_, kappa);
  double steering_ = can_get_curvature ? (steering_radian * 180.0 / M_PI) * -1 * final_constant: 0;
  double brake_ = brake;
  pulishControlMsg(throttle_, steering_, brake_);

  // for steering visualization
  publishSteeringVisualizationMsg(steering_radian);
}

double PurePursuitNode::computeLookaheadDistance() const {
  if (true) {
    return const_lookahead_distance_;
  }
}

// void PurePursuitNode::pulishControlMsg(double throttle, double steering) const
// {
//   race::drive_values drive_msg;
//   drive_msg.throttle = throttle;
//   drive_msg.steering = steering;
//   drive_msg_pub.publish(drive_msg);
// }

void PurePursuitNode::pulishControlMsg(double throttle, double steering, double brake) const {
  race::drive_values drive_msg;
  drive_msg.throttle = throttle;
  drive_msg.steering = steering;
  drive_msg.brake = brake;
  drive_msg_pub.publish(drive_msg);
  // steering_memory = drive_msg.steering;
}

void PurePursuitNode::callbackFromCurrentPose(const geometry_msgs::PoseStampedConstPtr& msg) {
  pp_.setCurrentPose(msg);
  is_pose_set_ = true;
}

void PurePursuitNode::setPath(char** argv) {
  std::vector<std::string> paths;
  path_split(argv[1], paths, ",");
  std::ifstream global_path_file(ROS_HOME + "/paths/" + paths[0] + ".txt");
  //std::cout << ROS_HOME + "/paths/" + argv[1] << std::endl;

  // path.txt
  // <x, y, mode>
  geometry_msgs::Point p;
  double x, y;
  int mode;

  while(global_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;
    //pp_.mode = mode;

    global_path.push_back(std::make_pair(p, mode));
    //std::cout << "global_path : " << global_path.back().x << ", " << global_path.back().y << std::endl;
  }
  if (paths.size() == 3) {
    std::ifstream parking_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
    while(parking_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      parking_path.push_back(std::make_pair(p, mode));
      //std::cout << "parking_path : " << parking_path.back().x << ", " << parking_path.back().y << std::endl;
    }

    std::ifstream avoidance_path_file(ROS_HOME + "/paths/" + paths[2] + ".txt");
    while(avoidance_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      avoidance_path.push_back(std::make_pair(p, mode));
      // std::cout << "avoidance_path : " << avoidance_path.back().x << ", " << parking_path.back().y << std::endl;
    }
  }
  else if (paths.size() == 2) {
    std::ifstream parking_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
    while(parking_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      parking_path.push_back(std::make_pair(p, mode));
      // std::cout << "parking_path : " << parking_path.back().x << ", " << parking_path.back().y << std::endl;
    }
  }

  is_waypoint_set_ = true;
}

void PurePursuitNode::publishTargetPointVisualizationMsg () {
  geometry_msgs::PointStamped target_point_msg;
  target_point_msg.header.frame_id = "/base_link";
  target_point_msg.header.stamp = ros::Time::now();
  target_point_msg.point = pp_.getPoseOfNextTarget();
  target_point_pub.publish(target_point_msg);
}

void PurePursuitNode::publishCurrentPointVisualizationMsg () {
  geometry_msgs::PointStamped current_point_msg;
  current_point_msg.header.frame_id = "/base_link";
  current_point_msg.header.stamp = ros::Time::now();
  current_point_msg.point = pp_.getCurrentPose();
  current_point_pub.publish(current_point_msg);
}

void PurePursuitNode::publishSteeringVisualizationMsg (const double& steering_radian) const {
  double yaw = atan2(2.0 * (pp_.current_pose_.orientation.w * pp_.current_pose_.orientation.z + pp_.current_pose_.orientation.x * pp_.current_pose_.orientation.y), 1.0 - 2.0 * (pp_.current_pose_.orientation.y * pp_.current_pose_.orientation.y + pp_.current_pose_.orientation.z * pp_.current_pose_.orientation.z));

  double steering_vis = yaw + steering_radian;
  geometry_msgs::Quaternion _quat = tf::createQuaternionMsgFromYaw(steering_vis);
  geometry_msgs::PoseStamped pose;
  pose.header.stamp = ros::Time::now();
  pose.header.frame_id = "/base_link";
  pose.pose.position = pp_.current_pose_.position;
  pose.pose.orientation = _quat;
  steering_vis_pub.publish(pose);
}

// for main control
void PurePursuitNode::callbackFromObstacle(const avoid_obstacle::TrueObstacles& msg) {
  pp_.is_obstacle_detected = msg.detected;
  //std::cout << "msg.detected : " << msg.detected << std::endl;
}

// 왼오
void PurePursuitNode::callbackFromObstacle2(const avoid_obstacle::DetectedObstacles& msg) {
  // 전역 변수 tmp_yaw_rate
  tmp_yaw_rate = 0.0;

  left_detected = false;
  right_detected = false;
  pp_.obstacles.clear();

  // 모든 장애물 데이터 벡터에 저장
  for(unsigned int i = 0; i < msg.obstacles.size(); i++) {
      Obstacle obs = Obstacle(msg.obstacles[i].x, msg.obstacles[i].y, msg.obstacles[i].radius, msg.obstacles[i].true_radius);
      pp_.obstacles.push_back(obs);
  }

  // left avoid flag가 true 이면 인식 범위를 5로 늘림.
  if(left_avoid){
    target_dist = 5.0;
  }

  for(unsigned int i = 0; i < pp_.obstacles.size(); i++)
  {
      // 전방 0도 ~ 50도 확인
      if(pp_.obstacles[i].yaw_rate > 0 && pp_.obstacles[i].yaw_rate < 50.0)
      {
          // 전방 1m ~ target_distance 확인
          if (pp_.obstacles[i].dist < target_dist && pp_.obstacles[i].dist > min_dist){
              // ROS_INFO("Point [X,Y] : [%f, %f]", obstacles[i].x, obstacles[i].y);
              // ROS_INFO("Distance : [%f]     Yaw_Rate : [%f]", obstacles[i].dist, obstacles[i].yaw_rate);
              left_detected = true;
              tmp_yaw_rate = pp_.obstacles[i].yaw_rate;
              //tmp_distance = pp_.obstacles[i].dist;
          }
      }

      // 첫 장애물 통과후, 오른쪽 장애물 인식  => 전방 -60~0도 확인
      if(left_avoid && pp_.obstacles[i].yaw_rate > -60.0 && pp_.obstacles[i].yaw_rate <= 0)
      {
          if(pp_.obstacles[i].dist < target_dist)
          {
              // ROS_INFO("Point [X,Y] : [%f, %f]", obstacles[i].x, obstacles[i].y);
              // ROS_INFO("Distance : [%f]     Yaw_Rate : [%f]", obstacles[i].dist, obstacles[i].yaw_rate);
              right_detected = true;
              tmp_yaw_rate = pp_.obstacles[i].yaw_rate;
          }
      }

      // if(pp_.mission_flag == 4 && !right_detected) {
      //   right_avoid = true;
      // }
  }
}
/*************************************************************************************************************/
// 오왼
void PurePursuitNode::callbackFromObstacle3(const avoid_obstacle::DetectedObstacles& msg) {
  // 전역 변수 tmp_yaw_rate
  tmp_yaw_rate = 0.0;

  left_detected = false;
  right_detected = false;
  pp_.obstacles.clear();

  // 모든 장애물 데이터 벡터에 저장
  for(unsigned int i = 0; i < msg.obstacles.size(); i++) {
      Obstacle obs = Obstacle(msg.obstacles[i].x, msg.obstacles[i].y, msg.obstacles[i].radius, msg.obstacles[i].true_radius);
      pp_.obstacles.push_back(obs);
  }

  //Rigt -> left Static obs sub
  //left avoid flag가 true 이면 인식 범위를 5로 늘림.
  if(right_avoid){
    target_dist = 5.0;
  }

  for(unsigned int i = 0; i < pp_.obstacles.size(); i++)
  {
      // 전방 0도 ~ 50도 확인
      if(pp_.obstacles[i].yaw_rate <= 0 && pp_.obstacles[i].yaw_rate > -50.0)
      {
          // 전방 1m ~ target_distance 확인
          if (pp_.obstacles[i].dist < target_dist && pp_.obstacles[i].dist > min_dist){
              // ROS_INFO("Point [X,Y] : [%f, %f]", obstacles[i].x, obstacles[i].y);
              // ROS_INFO("Distance : [%f]     Yaw_Rate : [%f]", obstacles[i].dist, obstacles[i].yaw_rate);
              right_detected = true;
              tmp_yaw_rate = pp_.obstacles[i].yaw_rate;
              //tmp_distance = pp_.obstacles[i].dist;
          }
      }

      // 첫 장애물 통과후, 오른쪽 장애물 인식
      if(right_avoid && pp_.obstacles[i].yaw_rate < 60.0 && pp_.obstacles[i].yaw_rate > 0)
      {
          if(pp_.obstacles[i].dist < target_dist)
          {
              // ROS_INFO("Point [X,Y] : [%f, %f]", obstacles[i].x, obstacles[i].y);
              // ROS_INFO("Distance : [%f]     Yaw_Rate : [%f]", obstacles[i].dist, obstacles[i].yaw_rate);
              left_detected = true;
              tmp_yaw_rate = pp_.obstacles[i].yaw_rate;
          }
      }

      // if(pp_.mission_flag == 4 && !right_detected) {
      //   right_avoid = true;
      // }
  }
}


/*************************************************************************************************************/
void PurePursuitNode::callbackFromTrafficLight(const darknet_ros_msgs::BoundingBoxes& msg) {
  // std::vector<darknet_ros_msgs::BoundingBox> traffic_lights = msg.bounding_boxes;
  // std::sort(traffic_lights.begin(), traffic_lights.end(), compare);

  std::vector<darknet_ros_msgs::BoundingBox> yoloObjects = msg.bounding_boxes;

  // 신호등 객체만 따로 검출함 (원근법 알고리즘 적용위함)
  std::vector<darknet_ros_msgs::BoundingBox> traffic_lights;
  for(int i=0; i<yoloObjects.size(); i++){
    if(yoloObjects[i].Class == "3 red" || yoloObjects[i].Class == "3 yellow" || yoloObjects[i].Class == "3 green" || yoloObjects[i].Class == "3 left"
      || yoloObjects[i].Class == "4 red" || yoloObjects[i].Class == "4 yellow" || yoloObjects[i].Class == "4 green"
      || yoloObjects[i].Class == "4 redleft" || yoloObjects[i].Class == "4 greenleft"  || yoloObjects[i].Class == "4 redyellow"){

        traffic_lights.push_back(yoloObjects[i]);

      }
  }
  std::sort(traffic_lights.begin(), traffic_lights.end(), compare);


  int index = 0;

  if(traffic_lights.size() > 0){
    if(traffic_lights[0].Class == "4 green" || traffic_lights[0].Class == "3 green" || traffic_lights[0].Class == "4 greenleft")
      ROS_INFO_STREAM("GREEN LIGHT");
  }

  if(pp_.mode == 2 || pp_.mode == 3){
    

    if(traffic_lights.size() > 0){
      if (traffic_lights[index].Class == "3 red" || traffic_lights[index].Class == "3 yellow" || traffic_lights[index].Class == "4 red" ||
          traffic_lights[index].Class == "4 yellow" || traffic_lights[index].Class == "4 redyellow")
      {
        pp_.straight_go_flag = false;
        pp_.left_go_flag = false;
      }
      else if (traffic_lights[index].Class == "3 green" || traffic_lights[index].Class == "4 green")
      {
        pp_.straight_go_flag = true;
        pp_.left_go_flag = false;
      }
      else if (traffic_lights[index].Class == "3 left" || traffic_lights[index].Class == "4 redleft")
      {
        pp_.straight_go_flag = false;
        pp_.left_go_flag = true;
      }
      else if (traffic_lights[index].Class == "4 greenleft")
      {
        pp_.straight_go_flag = true;
        pp_.left_go_flag = true;
      }
    }
  }

}
// void callbackFromLane(const {msg_type}& msg)

double convertCurvatureToSteeringAngle(const double& wheel_base, const double& kappa) {
  return atan(wheel_base * kappa);
}

void path_split(const std::string& str, std::vector<std::string>& cont,
		const std::string& delim)
{
    size_t prev = 0, pos = 0;
    do
    {
        pos = str.find(delim, prev);
        if (pos == std::string::npos) pos = str.length();
        std::string token = str.substr(prev, pos-prev);
        if (!token.empty()) cont.push_back(token);
        prev = pos + delim.length();
    }
    while (pos < str.length() && prev < str.length());
}

bool compare(darknet_ros_msgs::BoundingBox a, darknet_ros_msgs::BoundingBox b) {
  int a_area = (a.ymax - a.ymin) * (a.xmax - a.xmin);
  int b_area = (b.ymax - b.ymin) * (b.xmax - b.xmin);

  return a_area > b_area ? true : false;
}

}  // namespace waypoint_follower