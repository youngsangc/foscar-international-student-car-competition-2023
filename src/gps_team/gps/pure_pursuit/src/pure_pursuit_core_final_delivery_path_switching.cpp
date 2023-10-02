#include <vector>
#include <cmath>
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
  , parking_num(1)
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

bool start_of_mode7_flag = true;

bool first_cw = false;
bool second_cw = false;

bool get_x_distance = false;
double delivery_x_distance = 0.0;
bool isPresentYaw = false;
double present_yaw = 0.0;

float target_dist = 3.0;
float min_dist = 1.0;

int obs_cnt = 0;
std::chrono::system_clock::time_point obs_start;

float steering_memory = 0;

bool index_flag = false;

double secDelta = 0.0;
double nsecDelta = 0.0;
double sec = 0.0;
double nsec = 0.0;
double timeDelta = 0.0;
double velocity = 0.0;
double move_distance = 0.0;

/* traffic Index manager */
int tf_idx_1 = 1000;
int tf_idx_2 = 1000;
int tf_idx_3 = 1000;
int tf_idx_4 = 1000;
int tf_idx_5 = 1000;
int tf_idx_6 = 1000;
int tf_idx_7 = 1000;

const float tf_coord1[2] = {935572.7866943456, 1915921.7229049096};
const float tf_coord2[2] = {935599.0200777216, 1915970.5752066486};
const float tf_coord3[2] = {935650.1138944523, 1916094.6092048017};
const float tf_coord4[2] = {935649.1305419456, 1916200.0175518915};
const float tf_coord5[2] = {935643.0140080056, 1916136.5762911178};
const float tf_coord6[2] = {935611.8857807938, 1916009.8203957416};
const float tf_coord7[2] = {935591.7437816989, 1915967.635527344};

int slow_down_tf_idx_1 = 1000;
int slow_down_tf_idx_2 = 1000;
int slow_down_tf_idx_3 = 1000;
int slow_down_tf_idx_4 = 1000;
int slow_down_tf_idx_5 = 1000;
int slow_down_tf_idx_6 = 1000;
int slow_down_tf_idx_7 = 1000;

// Positions where car should slow down before traffic lights
const float slow_down_tf_coord1[2] = {935565.651362, 1915908.85769};
const float slow_down_tf_coord2[2] = {935593.442645, 1915959.50356};
const float slow_down_tf_coord3[2] = {935649.220924, 1916082.9449};
const float slow_down_tf_coord4[2] = {935656.505503, 1916191.74199};
const float slow_down_tf_coord5[2] = {935642.692369, 1916147.18467};
const float slow_down_tf_coord6[2] = {935616.622802, 1916018.72386};
const float slow_down_tf_coord7[2] = {935595.685842, 1915975.14741};


// U-turn index
int ut_idx = 1000;
// K-city 
const float ut_coord[2] = {935612.453921, 1916237.69527};

// cross walk index
int cw_idx_1 = 1000;
int cw_idx_2 = 1000;

// K-city
const float cw_coord_1[2] = {935623.59424, 1916230.0299};
const float cw_coord_2[2] = {935640.993628, 1916218.80811};

/* Parking index */
int pk_idx1 = 1000;
int pk_idx2 = 1000;
int pk_idx3 = 1000;
int pk_idx4 = 1000;
int pk_idx5 = 1000;

const float pk_coord1[2] = {955454.673469, 1956997.3354};

// const float pk_coord1[2] = {935537.101828, 1915867.54744};
const float pk_coord2[2] = {935534.641037, 1915863.05751};
const float pk_coord3[2] = {935525.445681, 1915845.94072};
const float pk_coord4[2] = {935520.003677, 1915835.89874};
const float pk_coord5[2] = {935517.529914, 1915831.50221};

bool is_parked = false;

int slow_down_before_delivery_idx = 1000;

const float slow_down_coord[2] = {935650.983648, 1916121.33595};

// Delivery Distance
double min_a_dist = 9999999;
double min_b_dist = 9999999;

// Delivery var
double delivery_x_dist;
double delivery_angle;

// max index of pp_.a_cnt array
int a_max_index = -1;
int b_max_index = -1;
// calc max index flag
bool a_cnt_flag = false;
bool b_cnt_flag = false;

bool delivery_A_brake_flag = false;
bool delivery_B_brake_flag = false;

bool delivery_distance_init_flag = true;

int b_idx_cnt = 0;

std::vector<int> passed_index;

void PurePursuitNode::initForROS() {
  // ros parameter settings
  private_nh_.param("const_lookahead_distance", const_lookahead_distance_, 4.0);
  private_nh_.param("const_velocity", const_velocity_, 3.0);
  private_nh_.param("final_constant", final_constant, 1.0);

  nh_.param("vehicle_info/wheel_base", wheel_base_, 1.04);

  ROS_HOME = ros::package::getPath("pure_pursuit");

  // setup subscriber
  pose_sub = nh_.subscribe("current_pose", 1, &PurePursuitNode::callbackFromCurrentPose, this);

  // for main control
  gps_velocity_sub = nh_.subscribe("/gps_velocity", 1, &PurePursuitNode::callbackFromGpsVelocity, this);
  gps_yaw_sub = nh_.subscribe("/gps_yaw", 1, &PurePursuitNode::callbackFromYaw, this);
  static_obstacle_short_sub = nh_.subscribe("/static_obs_flag_short", 1, &PurePursuitNode::callbackFromStaticObstacleShort, this);
  static_obstacle_long_sub = nh_.subscribe("/static_obs_flag_long", 1, &PurePursuitNode::callbackFromStaticObstacleLong, this);
  dynamic_obstacle_short_sub = nh_.subscribe("/dynamic_obs_flag_short", 1, &PurePursuitNode::callbackFromDynamicObstacleShort, this);
  dynamic_obstacle_long_sub = nh_.subscribe("/dynamic_obs_flag_long", 1, &PurePursuitNode::callbackFromDynamicObstacleLong, this);
  gps_velocity_raw_sub = nh_.subscribe("/gps_front/fix_velocity", 1, &PurePursuitNode::callbackFromGpsVelocityRawdata, this);

  traffic_light_sub = nh_.subscribe("darknet_ros/bounding_boxes",1, &PurePursuitNode::callbackFromTrafficLight, this);

  delivery_obs_sub1 = nh_.subscribe("delivery_information", 1, &PurePursuitNode::callbackFromDeliveryObstacleStop, this);

  //delivery subscriber
  delivery_sub = nh_.subscribe("delivery", 1, &PurePursuitNode::callbackFromDelivery, this);

  // setup publisher
  drive_msg_pub = nh_.advertise<race::drive_values>("control_value", 1);
  steering_vis_pub = nh_.advertise<geometry_msgs::PoseStamped>("steering_vis", 1);

  // for visualization
  target_point_pub = nh_.advertise<geometry_msgs::PointStamped>("target_point", 1);
  current_point_pub = nh_.advertise<geometry_msgs::PointStamped>("current_point", 1);
}

void PurePursuitNode::run(char** argv) {
  ROS_INFO_STREAM("pure pursuit2 start");
  parking_num = atoi(argv[2]);

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

    // Traffic Light Index 한번만 초기화 , 신호등 각각 좌표
    if (!index_flag) {
      index_flag = true;
      tf_idx_1 = pp_.getPosIndex(tf_coord1[0], tf_coord1[1]);
      tf_idx_2 = pp_.getPosIndex(tf_coord2[0], tf_coord2[1]);
      tf_idx_3 = pp_.getPosIndex(tf_coord3[0], tf_coord3[1]);
      tf_idx_4 = pp_.getPosIndex(tf_coord4[0], tf_coord4[1], 1); // 혹시나 배달구간 겹칠 수 있기때문에..
      tf_idx_5 = pp_.getPosIndex(tf_coord5[0], tf_coord5[1]);
      tf_idx_6 = pp_.getPosIndex(tf_coord6[0], tf_coord6[1]);
      tf_idx_7 = pp_.getPosIndex(tf_coord7[0], tf_coord7[1]);

      slow_down_tf_idx_1 = pp_.getPosIndex(slow_down_tf_coord1[0] , slow_down_tf_coord1[1]);
      slow_down_tf_idx_2 = pp_.getPosIndex(slow_down_tf_coord2[0] , slow_down_tf_coord2[1]);
      slow_down_tf_idx_3 = pp_.getPosIndex(slow_down_tf_coord3[0] , slow_down_tf_coord3[1]);
      slow_down_tf_idx_4 = pp_.getPosIndex(slow_down_tf_coord4[0] , slow_down_tf_coord4[1], 1);
      slow_down_tf_idx_5 = pp_.getPosIndex(slow_down_tf_coord5[0] , slow_down_tf_coord5[1]);
      slow_down_tf_idx_6 = pp_.getPosIndex(slow_down_tf_coord6[0] , slow_down_tf_coord6[1]);
      slow_down_tf_idx_7 = pp_.getPosIndex(slow_down_tf_coord7[0] , slow_down_tf_coord7[1]);

      ut_idx = pp_.getPosIndex(ut_coord[0], ut_coord[1]);

      cw_idx_1 = pp_.getPosIndex(cw_coord_1[0], cw_coord_1[1]);
      cw_idx_2 = pp_.getPosIndex(cw_coord_2[0], cw_coord_2[1]);

      pk_idx1 = pp_.getPosIndex(pk_coord1[0] , pk_coord1[1]);
      pk_idx2 = pp_.getPosIndex(pk_coord2[0] , pk_coord2[1]);
      pk_idx3 = pp_.getPosIndex(pk_coord3[0] , pk_coord3[1]);
      pk_idx4 = pp_.getPosIndex(pk_coord4[0] , pk_coord4[1]);
      pk_idx5 = pp_.getPosIndex(pk_coord5[0] , pk_coord5[1]);

      slow_down_before_delivery_idx = pp_.getPosIndex(slow_down_coord[0], slow_down_coord[1]);
    }

    ROS_INFO("MODE=%d, MISSION_FLAG=%d", pp_.mode, pp_.mission_flag);

    // MODE 0 - 직진
    // MODE 1 - 신호등(직진)
    // MODE 2 - 정적장애물
    // MODE 3 - 배달 A
    // MODE 4 - 신호등(커브) 
    // MODE 5 - 유턴구간(STOP 존재)
    // MODE 6 - 비보호 우회전 및 횡단보도 정차
    // MODE 7 - 배달 B
    // MODE 8 - Semi - Booster (속도 빠름)
    // MODE 9 - 수평주차

    // MODE  0 : 직진
    if (pp_.mode == 0) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 10;
      final_constant = 1.0;
    }

    // MODE 1 : 신호등(직진)
    if (pp_.mode == 1) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 10;
      final_constant = 1.0;

      // When traffic lights are RED at slow_down_point -> SLOWNIG DOWN
      if((pp_.reachMissionIdx(slow_down_tf_idx_1) || pp_.reachMissionIdx(slow_down_tf_idx_2) || pp_.reachMissionIdx(slow_down_tf_idx_3) || pp_.reachMissionIdx(slow_down_tf_idx_5) || pp_.reachMissionIdx(slow_down_tf_idx_6) || pp_.reachMissionIdx(slow_down_tf_idx_7)) && !pp_.straight_go_flag){
        can_get_curvature = pp_.canGetCurvature(&kappa);
        publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.2);
        ROS_INFO_STREAM("*****RED LIGHT SLOWING DOWN*****");
      } 
      // When traffic lights are GREEN at slow_down_point -> SPEEDING UP
      else if((pp_.reachMissionIdx(slow_down_tf_idx_1) || pp_.reachMissionIdx(slow_down_tf_idx_2) || pp_.reachMissionIdx(slow_down_tf_idx_3) || pp_.reachMissionIdx(slow_down_tf_idx_5) || pp_.reachMissionIdx(slow_down_tf_idx_6) || pp_.reachMissionIdx(slow_down_tf_idx_7)) && pp_.straight_go_flag){
        while(const_velocity_ < 10){
            const_velocity_ += 0.1;
            // pulishControlMsg(const_velocity_ , 0);
            can_get_curvature = pp_.canGetCurvature(&kappa);
            publishPurePursuitDriveMsg(can_get_curvature, kappa);
            ROS_INFO_STREAM("*****GREEN LIGHT SPEEDING UP*****");
        }
      }
      // 1,2,3,5,6,7번 직진신호등 멈춤
      if ((pp_.reachMissionIdx(tf_idx_1) || pp_.reachMissionIdx(tf_idx_2) || pp_.reachMissionIdx(tf_idx_3) || pp_.reachMissionIdx(tf_idx_5) || pp_.reachMissionIdx(tf_idx_6) || pp_.reachMissionIdx(tf_idx_7)) && !pp_.straight_go_flag) {
        pulishControlMsg(0,0);
        continue;
      }
    }

    //  MODE 2 : 정적장애물 감지되면 avoidance path로 진로변경 후 원래 global path로 복귀
    if (pp_.mode == 2) {
      if (pp_.mission_flag == 0 || pp_.mission_flag == 2) {
        const_lookahead_distance_ = 6;
        const_velocity_ = 12;
      }

      if (pp_.mission_flag == 0 && pp_.is_static_obstacle_detected_long) {
        for (int i = 0; i < 5; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.3);
          usleep(100000);
        }
        const_lookahead_distance_ = 4;

        if (!isPresentYaw) {
          present_yaw = pp_.gps_yaw;
          isPresentYaw = true;
        }

        for (int i = 0; i < 130/(velocity*3.6); i++) {
          pp_.mission_flag = 11;  
          pulishControlMsg(6, 22);
          usleep(100000);
        }
        continue;
      }

      else if (pp_.mission_flag == 11 && pp_.gps_yaw <= present_yaw - 10) {
        pulishControlMsg(4, -22);
        continue;
      }

      else if (pp_.mission_flag == 11 && pp_.gps_yaw > present_yaw - 10) {
        const_lookahead_distance_ = 4;
        const_velocity_ = 7;
        pp_.setWaypoints(avoidance_path);
        ROS_INFO("************************ AVOID PATH SWITCHNG **************************************");
        pp_.mission_flag = 1; 
        isPresentYaw = false;
      }

      else if (pp_.mission_flag == 1 && pp_.is_static_obstacle_detected_short) {
        const_lookahead_distance_ = 6;
        const_velocity_ = 7;

        if (!isPresentYaw) {
          present_yaw = pp_.gps_yaw;
          isPresentYaw = true;
        }

        for (int i = 0; i < 100/(velocity*3.6); i++) {
          pp_.mission_flag = 22;
          std::cout << 120/(velocity*3.6) << '\n';
          pulishControlMsg(7, -22);
          usleep(100000);
        }
        continue;
      }

      else if (pp_.mission_flag == 22 && pp_.gps_yaw >= present_yaw + 10) {
        pulishControlMsg(4, 22);
        continue;
      }

      else if (pp_.mission_flag == 22 && pp_.gps_yaw < present_yaw + 10) {
        const_lookahead_distance_ = 4;
        const_velocity_ = 7;
        pp_.setWaypoints(global_path);
        ROS_INFO("************************ GLOBAL PATH SWITCHNG **************************************");
        pp_.mission_flag = 2;
      }
    }

    // MODE 3 : 배달 PICK A
    if (pp_.mode == 3) {
      const_lookahead_distance_ = 6;
      const_velocity_ = 7;
      final_constant = 1.0;

      if (delivery_A_brake_flag == false) {
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
        delivery_A_brake_flag = true;
      }
      if (pp_.mission_flag == 0 && pp_.is_delivery_obs_stop_detected == 1) { 
        if (delivery_distance_init_flag) {
          delivery_distance_init_flag = false;
          move_distance = 0.0;
        }
        
        if (move_distance > delivery_x_distance + 0.5 - (velocity * 0.55)) {
          for (int i = 0; i < 5500; i++) {
            pulishControlMsg(0, 0, 1);
            usleep(1000);
          }
          delivery_distance_init_flag = true;
          pp_.mission_flag = 1;
        }
      }

      if (pp_.mission_flag == 1 && !a_cnt_flag) {
        // if not calculated a_max_index
        // Calc max_index
        a_max_index = max_element(pp_.a_cnt.begin(), pp_.a_cnt.end()) - pp_.a_cnt.begin();

        // Lock the a_cnt_flag
        a_cnt_flag = true;
      }
    }

    // MODE 4 : 신호등(커브)
    if (pp_.mode == 4) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 7;
      final_constant = 1.0;

      // When traffic lights are RED at slow_down_point -> SLOWNIG DOWN
      if((pp_.reachMissionIdx(slow_down_tf_idx_4)) && !pp_.left_go_flag){
        publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.2);
        ROS_INFO_STREAM("*****RED LIGHT SLOWING DOWN*****");
      } 
      // When traffic lights are GREEN at slow_down_point -> SPEEDING UP
      else if((pp_.reachMissionIdx(slow_down_tf_idx_4)) && pp_.left_go_flag){
        while(const_velocity_ < 10){
          const_velocity_ += 0.1;
          publishPurePursuitDriveMsg(can_get_curvature, kappa);
          ROS_INFO_STREAM("*****GREEN LIGHT SPEEDING UP*****");
        }
      }
      if ((pp_.reachMissionIdx(tf_idx_4)) && !pp_.left_go_flag) { 
        pulishControlMsg(0,0);
        continue;
      }
    }

    // MODE 5 : 유턴구간 (STOP 존재)
    if (pp_.mode == 5) {
      const_lookahead_distance_ = 2;
      const_velocity_ = 5;
      final_constant = 1.0;
      if (pp_.reachMissionIdx(ut_idx) && pp_.mission_flag == 0) {
        for (int i = 0; i < 15; i++) {
          pulishControlMsg(0, 0); 
          usleep(100000);  // 0.1초
        }
        pp_.mission_flag = 1;
      }

      if (pp_.mission_flag == 1) {
        const_lookahead_distance_ = 1.25;
        for (int i = 0; i < 100; i++) {
          ROS_INFO_STREAM("-----Turning-----");
          ROS_INFO_STREAM(i);
          pulishControlMsg(7, -30);
          usleep(100000);  // 0.1초
          pp_.mission_flag = 2;
        }
        continue;
      }

      else if (pp_.mission_flag == 2) {
        for(int i = 0; i < 22; i++) {
          ROS_INFO_STREAM("STRAIGHT");
          pulishControlMsg(5, 0);
        }
        pp_.setWaypoints(global_path);
        pp_.mission_flag = 3;
      }
    }

    // MODE 6 : 비보호 우회전 및 횡단보도 정지
    if (pp_.mode == 6) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 7.5;
      final_constant = 1.0;

      if(pp_.reachMissionIdx(cw_idx_1) && !first_cw){
        for(int i = 0; i < 55; i++){
          pulishControlMsg(0, 0);
          usleep(100000);
        }
        first_cw = true;
      }

      if(pp_.reachMissionIdx(cw_idx_2) && !second_cw){
        for(int i = 0; i < 55; i++){
          pulishControlMsg(0, 0);
          usleep(100000);
        }
        second_cw = true;
      }
    }

    // MODE 7 : 배달 B
    if (pp_.mode == 7) {
      const_lookahead_distance_ = 6;
      const_velocity_ = 7;
      final_constant = 1.0;

      if(start_of_mode7_flag) {
        pp_.setWaypoints(delivery_path);
        start_of_mode7_flag = false;
      }

      if (delivery_B_brake_flag == false) {
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
        delivery_B_brake_flag = true;
      }
      
      ROS_INFO("MISSION_FLAG=(%d) A_INDEX(%d)  B_INDEX(%d)", pp_.mission_flag, a_max_index, b_max_index);
      ROS_INFO("B1=%d, B2=%d, B3=%d", pp_.b_cnt[0], pp_.b_cnt[1], pp_.b_cnt[2]);
      
      // case 2) vision_distance + gps 로직
      if (pp_.mission_flag == 0) {
        pp_.mission_flag = 1;
      }

      else if (pp_.mission_flag == 22 && pp_.is_delivery_obs_stop_detected == 0) {
        pp_.mission_flag = 2;
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
      }

      else if (pp_.mission_flag == 33 && pp_.is_delivery_obs_stop_detected == 0) {
        pp_.mission_flag = 3;
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
      }
      
      if ((pp_.mission_flag == 1 || pp_.mission_flag == 2 || pp_.mission_flag == 3) && pp_.is_delivery_obs_stop_detected == 1) {
        b_max_index = max_element(pp_.b_cnt.begin(), pp_.b_cnt.end()) - pp_.b_cnt.begin();
       
        if (a_max_index == b_max_index) {
          if (delivery_distance_init_flag) {
            delivery_distance_init_flag = false;
            move_distance = 0.0;
          }
          
          if ( move_distance > delivery_x_distance + 0.5 - (velocity * 0.55)) {
            for (int i = 0; i < 5500; i++) {
              pulishControlMsg(0, 0, 1);
              usleep(1000);
            }
            delivery_distance_init_flag = true;
            pp_.mission_flag = 100;
          }
        } 

        else {
          pp_.b_cnt = {0, 0, 0};
          if (pp_.mission_flag == 1) { pp_.mission_flag = 22; }
          else if (pp_.mission_flag == 2) { pp_.mission_flag = 33; }
        }
      }

      if (pp_.mission_flag == 100) {
        const_lookahead_distance_ = 4;
        const_velocity_ = 10;
        final_constant = 1.0;
        pp_.setWaypoints(global_path);
      }
    }

    // MODE 8 : Semi-Booster
    if (pp_.mode == 8) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 12;
      final_constant = 1.0;
    }

    // MODE 9 : 수평주차
    if (pp_.mode == 9) {
      pp_.is_finish = false;

      if (pp_.mission_flag == 0)  {
        const_lookahead_distance_ = 6;
        const_velocity_ = 6;
      }
      
      if (pp_.mission_flag == 4)  {
        const_lookahead_distance_ = 5;
        const_velocity_ = 10;
      }

      if (!is_parked) {
        // first
        if (parking_num == 1) {
          if (pp_.reachMissionIdx(pk_idx1)) {
            for(int i = 0; i < 12; i++) {
              pulishControlMsg(7, -20); 
              usleep(100000);
            }

            for(int i = 0; i < 10; i++) {
              pulishControlMsg(0, 0); 
              usleep(100000);
            }
            pp_.mission_flag = 1;
          }
        }

        // second
        else if (parking_num == 2) {
          if (pp_.reachMissionIdx(pk_idx2)) {
            for(int i = 0; i < 12; i++) {
              pulishControlMsg(7, -20); 
              usleep(100000);
            }

            for(int i = 0; i < 10; i++) {
              pulishControlMsg(0, 0); 
              usleep(100000);
            }
            pp_.mission_flag = 1;
          }
        }

        // third
        else if (parking_num == 3) {
          if (pp_.reachMissionIdx(pk_idx3)) {
            for(int i = 0; i < 12; i++) {
              pulishControlMsg(7, -20); 
              usleep(100000);
            }

            for(int i = 0; i < 10; i++) {
              pulishControlMsg(0, 0); 
              usleep(100000);
            }
            pp_.mission_flag = 1;
          }
        }  

        // forth
        else if (parking_num == 4) {     
          if (pp_.reachMissionIdx(pk_idx4)) {
            for(int i = 0; i < 12; i++) {
              pulishControlMsg(7, -20); 
              usleep(100000);
            }

            for(int i = 0; i < 10; i++) {
              pulishControlMsg(0, 0); 
              usleep(100000);
            }
            pp_.mission_flag = 1;
          }
        }

        // fifth
        else if (parking_num == 5) {
          if (pp_.reachMissionIdx(pk_idx5)) {
            for(int i = 0; i < 12; i++) {
              pulishControlMsg(7, -20); 
              usleep(100000);
            }

            for(int i = 0; i < 10; i++) {
              pulishControlMsg(0, 0); 
              usleep(100000);
            }
            pp_.mission_flag = 1;
          }
        }
      }

      if (pp_.mission_flag == 1) {
        // 우측 후진
        for (int i = 0; i < 37; i++) {
          pulishControlMsg(-7, 27);
          usleep(100000);
        }
        // 평행 후진
        for (int i = 0; i < 10; i++) {
          pulishControlMsg(-7, 0);
          usleep(100000);
        }
        // 좌측 후진
        for (int i = 0; i < 27; i++) {
          pulishControlMsg(-7, -30);
          usleep(100000);
        }
        pp_.mission_flag = 2;
      }

      // 10초 정지
      else if (pp_.mission_flag == 2) {
        for (int i = 0; i < 110; i++) {
          pulishControlMsg(0, 0);
          usleep(100000);
        }
        pp_.mission_flag = 3;
      }

      else if (pp_.mission_flag == 3) {
        // 좌측 전진
        for (int i = 0; i < 46; i++) {
          pulishControlMsg(7, -30);
          usleep(100000);
        }
        // 평행 전진
        for (int i = 0; i < 8; i++) {
          pulishControlMsg(7, 0);
          usleep(100000);
        }
        // 우측 전진
        for (int i = 0; i < 35; i++) {
          pulishControlMsg(7, 30);
          usleep(100000);
        }

        pp_.mission_flag = 4;
        is_parked = true;
      }

      ROS_INFO_STREAM(is_parked);
      if (is_parked) {
        pp_.setWaypoints(global_path);
        ROS_INFO_STREAM("******* Parking Ended *******");
      }
    }

    // 마지막 waypoint 에 다다랐으면 점차 속도를 줄이기
    if (pp_.is_finish && pp_.mode == 8) {
      while(const_velocity_ > 0) {
        const_velocity_ -= 1;
        pulishControlMsg(const_velocity_,0);
      }
      ROS_INFO_STREAM("Finish Pure Pursuit");
      //마지막 waypoint라면 코드를 종료하기 위함 안될시 삭제요망
      ros::shutdown(); 
      continue;
    }

    publishPurePursuitDriveMsg(can_get_curvature, kappa);

    is_pose_set_ = false;
    loop_rate.sleep();
  }
}


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

void PurePursuitNode::pulishControlMsg(double throttle, double steering, double brake) const {
  race::drive_values drive_msg;
  drive_msg.throttle = throttle;
  drive_msg.steering = steering;
  drive_msg.brake = brake;
  drive_msg_pub.publish(drive_msg);
  steering_memory = drive_msg.steering;
}

void PurePursuitNode::callbackFromCurrentPose(const geometry_msgs::PoseStampedConstPtr& msg) {
  pp_.setCurrentPose(msg);
  is_pose_set_ = true;
}

void PurePursuitNode::setPath(char** argv) {
  std::vector<std::string> paths;
  path_split(argv[1], paths, ",");
  std::ifstream global_path_file(ROS_HOME + "/paths/" + paths[0] + ".txt");

  // path.txt
  // <x, y, mode>
  geometry_msgs::Point p;
  double x, y;
  int mode;

  while(global_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;

    global_path.push_back(std::make_pair(p, mode));
  }

  if (paths.size() == 3) {
    std::ifstream avoidance_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
    while(avoidance_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      avoidance_path.push_back(std::make_pair(p, mode));
    }

    std::ifstream delivery_path_file(ROS_HOME + "/paths/" + paths[2] + ".txt");
    while(delivery_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      delivery_path.push_back(std::make_pair(p, mode));
    }
  }
  is_waypoint_set_ = true;
}

void PurePursuitNode::publishTargetPointVisualizationMsg() {
  geometry_msgs::PointStamped target_point_msg;
  target_point_msg.header.frame_id = "/base_link";
  target_point_msg.header.stamp = ros::Time::now();
  target_point_msg.point = pp_.getPoseOfNextTarget();
  target_point_pub.publish(target_point_msg);
}

void PurePursuitNode::publishCurrentPointVisualizationMsg() {
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

void PurePursuitNode::callbackFromGpsVelocity(const std_msgs::Float64& msg) {
  pp_.gps_velocity = msg.data;
}

void PurePursuitNode::callbackFromYaw(const std_msgs::Float64& msg) {
  pp_.gps_yaw = msg.data;
}

void PurePursuitNode::callbackFromDynamicObstacleShort(const std_msgs::Bool& msg) {
  pp_.is_dynamic_obstacle_detected_short = msg.data;
}

void PurePursuitNode::callbackFromDynamicObstacleLong(const std_msgs::Bool& msg) {
  pp_.is_dynamic_obstacle_detected_long = msg.data;
}

void PurePursuitNode::callbackFromStaticObstacleShort(const std_msgs::Bool& msg) {
  pp_.is_static_obstacle_detected_short = msg.data;
}

void PurePursuitNode::callbackFromStaticObstacleLong(const std_msgs::Bool& msg) {
  pp_.is_static_obstacle_detected_long = msg.data;
}

// for delivery obstacle (stop) - 멈추는 로직
void PurePursuitNode::callbackFromDeliveryObstacleStop(const lidar_team_erp42::Delivery& msg) {
  double delivery_sign_cutline = 1.5;

  if (msg.x != 0 && (pp_.mode == 3 || pp_.mode == 7)) {
    if (msg.x < delivery_sign_cutline && get_x_distance == false) {
      pp_.is_delivery_obs_stop_detected = 1;

      delivery_x_distance = msg.x;
      get_x_distance = true;
    }
    else if (msg.x >= delivery_sign_cutline && get_x_distance == true && (a_max_index != b_max_index)) {
      pp_.is_delivery_obs_stop_detected = 0;
      
      delivery_x_distance = 0.0;
      get_x_distance = false;
    }
  }
  else if (msg.x == 0 && (a_max_index != b_max_index)) {
    pp_.is_delivery_obs_stop_detected = 0;
    get_x_distance = false;
  }
}

void PurePursuitNode::callbackFromDelivery(const vision_distance::DeliveryArray& msg) {
  std::vector<vision_distance::Delivery> deliverySign = msg.visions;

  // B Area
  if (pp_.mode == 7 && (pp_.mission_flag == 1 || pp_.mission_flag == 2 || pp_.mission_flag == 3)) {
    sort(deliverySign.begin(), deliverySign.end(), compare2);
    
    if (deliverySign.size() > 0) {
      if (deliverySign[0].flag < 4) {
        pp_.b_cnt[deliverySign[0].flag-1] += 1;
      }
    }
  }

  // A Area
  if (pp_.mode == 3 && pp_.mission_flag == 0) {
    sort(deliverySign.begin(), deliverySign.end(), compare2);
    
    if (deliverySign.size() > 0) {
      if (deliverySign[0].flag >= 4) {
        pp_.a_cnt[deliverySign[0].flag-4] += 1;
      }
    }
  }
}

void PurePursuitNode::callbackFromGpsVelocityRawdata(const geometry_msgs::TwistWithCovarianceStamped& msg) {
  if (sec == 0.0) {
    sec = msg.header.stamp.sec;
    nsec = msg.header.stamp.nsec;
  } 
  else {
    secDelta = msg.header.stamp.sec - sec;
    nsecDelta = (msg.header.stamp.nsec - nsec) / 1000000000.0;
    timeDelta = secDelta + nsecDelta;
    sec = msg.header.stamp.sec;
    nsec = msg.header.stamp.nsec;
  }
  velocity = sqrt(msg.twist.twist.linear.x * msg.twist.twist.linear.x + msg.twist.twist.linear.y * msg.twist.twist.linear.y + msg.twist.twist.linear.z * msg.twist.twist.linear.z);
  move_distance += velocity * timeDelta;

  if (move_distance > 10000)
    move_distance = 0.0;
}

void PurePursuitNode::callbackFromTrafficLight(const darknet_ros_msgs::BoundingBoxes& msg) {
  std::vector<darknet_ros_msgs::BoundingBox> yoloObjects = msg.bounding_boxes;
  std::vector<darknet_ros_msgs::BoundingBox> deliveryObjectsA, deliveryObjectsB;

  // 신호등 객체만 따로 검출함 (원근법 알고리즘 적용위함)
  std::vector<darknet_ros_msgs::BoundingBox> traffic_lights;
  for(int i=0; i<yoloObjects.size(); i++) {
    if (yoloObjects[i].Class == "3 red" || yoloObjects[i].Class == "3 yellow" || yoloObjects[i].Class == "3 green" || yoloObjects[i].Class == "3 left"
      || yoloObjects[i].Class == "4 red" || yoloObjects[i].Class == "4 yellow" || yoloObjects[i].Class == "4 green"
      || yoloObjects[i].Class == "4 redleft" || yoloObjects[i].Class == "4 greenleft" || yoloObjects[i].Class == "4 redyellow") {

      traffic_lights.push_back(yoloObjects[i]);
    }
  }

  std::sort(traffic_lights.begin(), traffic_lights.end(), compare);
 
  if (traffic_lights.size() > 1) {

      int first_traffic = (traffic_lights[0].xmax - traffic_lights[0].xmin) * (traffic_lights[0].ymax - traffic_lights[0].ymin);
      int second_traffic = (traffic_lights[1].xmax - traffic_lights[1].xmin) * (traffic_lights[1].ymax - traffic_lights[1].ymin);

      if (first_traffic * 0.6 < second_traffic) {
        if (traffic_lights[0].Class == "3 left" || traffic_lights[0].Class == "4 redleft" || traffic_lights[0].Class == "4 greenleft" ||
          traffic_lights[1].Class == "3 left" || traffic_lights[1].Class == "4 redleft" || traffic_lights[1].Class == "4 greenleft") {
            pp_.left_go_flag = true;
        }
        else {
          pp_.left_go_flag = false;
        }

        if (pp_.left_go_flag) {
          std::cout << "left go" << '\n';
        }
        return;
      }
    }

  if (traffic_lights.size() > 0) {

    if (traffic_lights[0].Class == "3 red" || traffic_lights[0].Class == "3 yellow" || traffic_lights[0].Class == "4 red" || traffic_lights[0].Class == "4 yellow" || traffic_lights[0].Class == "4 redyellow") {
      pp_.straight_go_flag = false;
      pp_.left_go_flag = false;
    }
    else if (traffic_lights[0].Class == "3 green" || traffic_lights[0].Class == "4 green") {
      pp_.straight_go_flag = true;
      pp_.left_go_flag = false;
    }
    else if (traffic_lights[0].Class == "3 left" || traffic_lights[0].Class == "4 redleft") {
      pp_.straight_go_flag = false;
      pp_.left_go_flag = true;
    }
    else if (traffic_lights[0].Class == "4 greenleft") {
      pp_.straight_go_flag = true;
      pp_.left_go_flag = true;
    }
  }
}

double convertCurvatureToSteeringAngle(const double& wheel_base, const double& kappa) {
  return atan(wheel_base * kappa);
}

void path_split(const std::string& str, std::vector<std::string>& cont, const std::string& delim) {
    size_t prev = 0, pos = 0;
    do {
      pos = str.find(delim, prev);
      if (pos == std::string::npos) pos = str.length();
      std::string token = str.substr(prev, pos-prev);
      if (!token.empty()) cont.push_back(token);
      prev = pos + delim.length();
    } while (pos < str.length() && prev < str.length());
}

bool compare(darknet_ros_msgs::BoundingBox a, darknet_ros_msgs::BoundingBox b) {
  int a_area = (a.ymax - a.ymin) * (a.xmax - a.xmin);
  int b_area = (b.ymax - b.ymin) * (b.xmax - b.xmin);

  return a_area > b_area ? true : false;
}

bool compare2(vision_distance::Delivery a, vision_distance::Delivery b) {
  return a.dist_y < b.dist_y ? true : false;
}

}  // namespace waypoint_follower