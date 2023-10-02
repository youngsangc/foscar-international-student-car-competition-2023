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
#include <nav_msgs/Path.h>

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

//vizualizaiton
float x_max=0;
float x_min=9999999;
float y_max=0;
float y_min=9999999;
nav_msgs::Path rviz_global_path;
nav_msgs::Path rviz_avoidance_path;
nav_msgs::Path rviz_delivery_path;


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

bool static_turning = false;

/* traffic Index manager */
int tf_idx_1 = 1000;
int tf_idx_2 = 1000;
int tf_idx_3 = 1000;
int tf_idx_4 = 1000;
int tf_idx_5 = 1000;
int tf_idx_6 = 1000;
int tf_idx_7 = 1000;


// const float tf_coord1[2] = {931249.94306, 1929755.90643}; //SNU

const float tf_coord1[2] = {935572.3887599346, 1915920.8248813895}; //KCITY
const float tf_coord2[2] = {935598.762623029, 1915969.727575488};
const float tf_coord3[2] = {935651.0951423608, 1916095.6502789722};
const float tf_coord4[2] = {935654.1688240928, 1916200.426984696};
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
const float slow_down_tf_coord1[2] = {935563.1985652759, 1915903.4101987937};
const float slow_down_tf_coord2[2] = {935592.2670452371, 1915957.8284363798};
const float slow_down_tf_coord3[2] = {935648.7951854715, 1916077.9497171796};
const float slow_down_tf_coord4[2] = {935654.6144100301, 1916176.3925115995};
const float slow_down_tf_coord5[2] = {935642.692369, 1916147.18467};
const float slow_down_tf_coord6[2] = {935616.622802, 1916018.72386};
const float slow_down_tf_coord7[2] = {935595.685842, 1915975.14741};


// U-turn index
int ut_idx = 1000;

// K-city 
//const float ut_coord[2] = {931329.340380759, 19298721.960995914};

//기존인덱스//7월 29일 직전
//const float ut_coord[2] = {931286.0243913059, 1929810.1196518776};
//k-city 7월 29일

const float ut_coord[2] = {935712.3733283298, 1916096.1128496532};




// SNU
// const float ut_coord[2] = {931182.173187, 1929625.08779};

// cross walk index
int cw_idx_1 = 1000;
int cw_idx_2 = 1000;

// K-city
const float cw_coord_1[2] = {935623.59424, 1916230.0299};
const float cw_coord_2[2] = {935640.5385652623, 1916220.4796704461};

/* Parking index */
int pk_idx[7] = {0, 0, 0, 0, 0, 0, 0};

// K-City
const float pk_coord[4][2] = { {931343.787078791, 1929862.5572373515},
                               {931343.787078791, 1929862.5572373515},
                               {931343.787078791, 1929862.5572373515},
                               {931343.787078791, 1929862.5572373515} };



// const float pk_coord[4][2] = { {935539.5063647057, 1915872.2606872066},
//                                {935537.0244854591, 1915867.875155339},
//                                {935534.7374843466, 1915863.454844135},
//                                {935532.3626342632, 1915859.1461546447} };

// SNU
// const float pk_coord[4][2] = { {931347.674500, 1929883.017834},
//                                {931350.691454, 1929886.987260},
//                                {931353.761445, 1929890.945170},
//                                {931356.679894, 1929894.782270} };
// // SNU-2
// const float pk_coord[4][2] = { {931283.899972, 1929822.08646},
//                                {931284.911271, 1929823.376270},
//                                {931284.911271, 1929823.376270},
//                                {931284.911271, 1929823.376270} };


// const float pk_coord1[2] = {935537.101828, 1915867.54744};
// const float pk_coord2[2] = {935534.641037, 1915863.05751};
// const float pk_coord3[2] = {935525.445681, 1915845.94072};
// const float pk_coord4[2] = {935520.003677, 1915835.89874};
// const float pk_coord5[2] = {935517.529914, 1915831.50221};

bool is_parked = false;

int slow_down_before_delivery_idx = 1000;

const float slow_down_coord[2] = {935650.983648, 1916121.33595};

// Delivery Distance
double min_a_dist = 9999999;
double min_b_dist = 9999999;

// Delivery var
double delivery_x_dist;

// max index of pp_.a_cnt array
int a_max_index = -1;
int b_max_index = -1;

// calc max index flag
bool a_cnt_flag = false;
bool b_cnt_flag = false;

// calc show A flag
bool a_show_flag = false;

bool delivery_A_brake_flag = false;
bool delivery_B_brake_flag = false;
bool parking_brake_flag = false;

bool delivery_distance_init_flag = true;

// Parallel Parking flag
bool parking_available_flag = false;
bool once_flag = false;
int check_point_index = 0;
double moved_distance = 0.0;
bool final_parking_flag = false;
int step = 1;

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
  parking_rubbercone_sub = nh_.subscribe("/is_parking_rubbercone", 1, &PurePursuitNode::callbackFromParkingRubberCone, this);

  gps_velocity_raw_sub = nh_.subscribe("/gps_front/fix_velocity", 1, &PurePursuitNode::callbackFromGpsVelocityRawdata, this);

  traffic_light_sub = nh_.subscribe("darknet_ros/bounding_boxes",1, &PurePursuitNode::callbackFromTrafficLight, this);
  traffic_light_sub2= nh_.subscribe("yolov7/traffic_light2",1, &PurePursuitNode::callbackFromTrafficLight2, this);
  delivery_obs_sub1 = nh_.subscribe("delivery_information", 1, &PurePursuitNode::callbackFromDeliveryObstacleStop, this);

  //delivery subscriber
  delivery_sub = nh_.subscribe("delivery", 1, &PurePursuitNode::callbackFromDelivery, this);

  // setup publisher
  drive_msg_pub = nh_.advertise<race::drive_values>("control_value", 1);
  steering_vis_pub = nh_.advertise<geometry_msgs::PoseStamped>("steering_vis", 1);

  // for visualization
  target_point_pub = nh_.advertise<geometry_msgs::PointStamped>("target_point", 1);
  current_point_pub = nh_.advertise<geometry_msgs::PointStamped>("current_point", 1);
  rviz_current_pose_pub = nh_.advertise<geometry_msgs::PointStamped>("rviz_current_pose", 1);
  rviz_path_global_pub = nh_.advertise<nav_msgs::Path>("visual_global_path", 1);
  rviz_path_avoidance_pub = nh_.advertise<nav_msgs::Path>("visual_avoidance_path", 1);
  rviz_path_delivery_pub = nh_.advertise<nav_msgs::Path>("visual_delivery_path", 1);

}

void PurePursuitNode::run(char** argv) {
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
    rviz_path_global_pub.publish(rviz_global_path);
    rviz_path_avoidance_pub.publish(rviz_avoidance_path);
    rviz_path_delivery_pub.publish(rviz_delivery_path);


    double kappa = 0;
    bool can_get_curvature = pp_.canGetCurvature(&kappa);

    // target point visualization
    publishTargetPointVisualizationMsg();
    publishCurrentPointVisualizationMsg();
    publishCurrentPoseVisualizationMsg();
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

      pk_idx[0] = pp_.getPosIndex(pk_coord[0][0], pk_coord[0][1]);
      pk_idx[1] = pp_.getPosIndex(pk_coord[1][0], pk_coord[1][1]);
      pk_idx[2] = pp_.getPosIndex(pk_coord[2][0], pk_coord[2][1]);
      pk_idx[3] = pp_.getPosIndex(pk_coord[3][0], pk_coord[3][1]);

      slow_down_before_delivery_idx = pp_.getPosIndex(slow_down_coord[0], slow_down_coord[1]);
    }

    // ROS_INFO("MODE=%d, MISSION_FLAG=%d", pp_.mode, pp_.mission_flag);

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
      const_lookahead_distance_ = 5;//원래 6이였음
      const_velocity_ = 15;
      final_constant = 1.0;
    }

    // MODE 1 : 신호등(직진)
    if (pp_.mode == 1) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 6;
      const_velocity_ = 15;
      final_constant = 1.0;

      // When traffic lights are RED at slow_down_point -> SLOWNIG DOWN
      if((pp_.reachMissionIdx(slow_down_tf_idx_1) || pp_.reachMissionIdx(slow_down_tf_idx_2) || pp_.reachMissionIdx(slow_down_tf_idx_3) || pp_.reachMissionIdx(slow_down_tf_idx_5) || pp_.reachMissionIdx(slow_down_tf_idx_6) || pp_.reachMissionIdx(slow_down_tf_idx_7)) && !pp_.straight_go_flag){
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
      } 
      // When traffic lights are GREEN at slow_down_point -> SPEEDING UP
      else if((pp_.reachMissionIdx(slow_down_tf_idx_1) || pp_.reachMissionIdx(slow_down_tf_idx_2) || pp_.reachMissionIdx(slow_down_tf_idx_3) || pp_.reachMissionIdx(slow_down_tf_idx_5) || pp_.reachMissionIdx(slow_down_tf_idx_6) || pp_.reachMissionIdx(slow_down_tf_idx_7)) && pp_.straight_go_flag){
        while(const_velocity_ < 10){
            const_velocity_ += 0.1;
            // pulishControlMsg(const_velocity_ , 0);
            publishPurePursuitDriveMsg(can_get_curvature, kappa);
        }
      }
      // 1,2,3,5,6,7번 직진신호등 멈춤
      if ((pp_.reachMissionIdx(tf_idx_1) || pp_.reachMissionIdx(tf_idx_2) || pp_.reachMissionIdx(tf_idx_3) || pp_.reachMissionIdx(tf_idx_5) || pp_.reachMissionIdx(tf_idx_6) || pp_.reachMissionIdx(tf_idx_7)) && !pp_.straight_go_flag) { 
        while(!pp_.straight_go_flag)
        {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
          ros::spinOnce();
        }
        continue;
      }
    }

    //  MODE 2 : 정적장애물 감지되면 avoidance path로 진로변경 후 원래 global path로 복귀
    if (pp_.mode == 2) {
      printf("%d\n", pp_.mission_flag);
      if (pp_.mission_flag == 0 || pp_.mission_flag == 2) {
        const_lookahead_distance_ = 5;
        const_velocity_ = 7;
      }

      if (pp_.mission_flag == 0 && pp_.is_static_obstacle_detected_long) {
        printf("-------------------------long------------------------\n");
        publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.5);

        if (!isPresentYaw) {
          present_yaw = pp_.gps_yaw;
          isPresentYaw = true;
        }

        pp_.mission_flag = 111;
        // for (int i = 0; i < 130/(velocity*3.6); i++) {
        //   pp_.mission_flag = 11;  
        //   pulishControlMsg(6, 22);
        //   usleep(100000);
        // }
        // continue;
      }

      else if (pp_.mission_flag == 111) {
        if (!static_turning) {
          moved_distance = 0.0;
          static_turning = true;
        }
        if (static_turning){
          if (moved_distance < 3.7) {
            pulishControlMsg(7, 20);
            continue;
          }
          else if (3.7 <= moved_distance && moved_distance < 7.4) {
            pulishControlMsg(7, -20);
            continue;
          }
          else {
            pp_.mission_flag = 11;

            static_turning = false;
          }
        }
      }

      /*else if (pp_.mission_flag == 11 && pp_.gps_yaw <= present_yaw - 20) {
        pulishControlMsg(4, -22);
        continue;
      }*/

      else if (pp_.mission_flag == 11 /*&& pp_.gps_yaw > present_yaw - 20*/) {
        //const_lookahead_distance_ = 6;
        const_velocity_ = 7;
        pp_.setWaypoints(avoidance_path);
        const_lookahead_distance_ = 6;
        pp_.mission_flag = 1; 
        isPresentYaw = false;
      }

      else if (pp_.mission_flag == 1 && pp_.is_static_obstacle_detected_short) {
        printf("-------------------------short------------------------\n"); 
        const_lookahead_distance_ = 5;
        const_velocity_ = 7;
        
        if (!isPresentYaw) {
          present_yaw = pp_.gps_yaw;
          isPresentYaw = true;
        }

        // for (int i = 0; i < 100/(velocity*3.6); i++) {
        //   pp_.mission_flag = 22;
        //   pulishControlMsg(7, -22);
        //   usleep(100000);
        // }
        // continue;
        pp_.mission_flag = 222;
      }
      else if (pp_.mission_flag == 222) {
        if (!static_turning) {
          moved_distance = 0.0;
          static_turning = true;
          continue;
        }
        else if (static_turning){
          if (moved_distance < 3.3) {
            pulishControlMsg(7, -20);
            continue;
          }
          else if (3.3 <= moved_distance && moved_distance < 6.6) {
            pulishControlMsg(7, 20);
            continue;
          }
          else {
            pp_.mission_flag = 22;
            static_turning = false;
          }
        }
      }

      // 0921 주석처리 하면 가능
      // else if (pp_.mission_flag == 22 && pp_.gps_yaw >= present_yaw + 10) {
      //   pulishControlMsg(4, 22);
      //   continue;
      // }

      else if (pp_.mission_flag == 22 /*&& pp_.gps_yaw < present_yaw + 10*/) {
        const_lookahead_distance_ = 4;
        const_velocity_ = 7;
        pp_.setWaypoints(global_path);
        pp_.mission_flag = 2;
      }
    }

    // MODE 3 : 배달 PICK A
    if (pp_.mode == 3) {

      // 1001
      // const_lookahead_distance_ = 3;
      const_lookahead_distance_ = 4;
      const_velocity_ = 5;
      final_constant = 1.0;

      if (delivery_A_brake_flag == false) {
        for (int i = 0; i < 100; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.5);
          usleep(10000);
        }
        delivery_A_brake_flag = true;
      }
      if (pp_.mission_flag == 0 && pp_.is_delivery_obs_stop_detected == 1) { 
        if (delivery_distance_init_flag) {
          delivery_distance_init_flag = false;
          move_distance = 0.0;
        }

        // 1001 && a_show_flag
        // 배달 A 표지판 인지하기 전에 만에 하나 혹시 BB를 형성해서 멈추는 것을 방지 
        if ((move_distance > delivery_x_distance + 0.5 - (velocity * 0.55))) {
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
      std::cout << "is_delivery_obs_stop_detected = " << pp_.is_delivery_obs_stop_detected << '\n';
      std::cout << "move_distance = " << move_distance << " delivery_x_distance = " << delivery_x_distance << '\n';
    }

    // MODE 4 : 신호등(커브)
    if (pp_.mode == 4) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 10;
      final_constant = 1.0;

      // When traffic lights are RED at slow_down_point -> SLOWNIG DOWN
      if((pp_.reachMissionIdx(slow_down_tf_idx_4)) && !pp_.left_go_flag){
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
      } 
      // When traffic lights are GREEN at slow_down_point -> SPEEDING UP
      else if((pp_.reachMissionIdx(slow_down_tf_idx_4)) && pp_.left_go_flag){
        while(const_velocity_ < 10){
          const_velocity_ += 0.1;
          publishPurePursuitDriveMsg(can_get_curvature, kappa);
        }
      }
      if ((pp_.reachMissionIdx(tf_idx_4)) && !pp_.left_go_flag) { 
        while(!pp_.left_go_flag)
        {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
          ros::spinOnce();
        }
        continue;
      }
    }

    // MODE 5 : 유턴구간 (STOP 존재)
    if (pp_.mode == 5) {
      const_lookahead_distance_ = 3;
      const_velocity_ = 5;
      final_constant = 1.0;
      
      // if (pp_.reachMissionIdx(ut_idx) && pp_.mission_flag == 0) {
      //   for (int i = 0; i < 15; i++) {
      //     pulishControlMsg(0, 0); 
      //     usleep(100000);  // 0.1초
      //   }
      //   pp_.mission_flag = 1;
      // }

      if (pp_.reachMissionIdx(ut_idx)) {
        if(pp_.mission_flag == 0) {
          for (int i = 0; i < 10; i++) {
            publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
            usleep(100000);  // 0.1초
          }
          pp_.mission_flag = 1;
        }

        if(pp_.mission_flag == 1){
          if(!pp_.left_go_flag){
            publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
            continue;
          }
          
        }
      }

      if (pp_.mission_flag == 1) {
        const_lookahead_distance_ = 1.25;
        for (int i = 0; i < 80; i++) {
          pulishControlMsg(7, -30);
          usleep(100000);  // 0.1초
          pp_.mission_flag = 2;
        }
      }

      else if (pp_.mission_flag == 2) {
        for(int i = 0; i < 22; i++) {
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
      const_velocity_ = 7;
      final_constant = 1.2;

      if(pp_.reachMissionIdx(cw_idx_1) && !first_cw){
        for(int i = 0; i < 35; i++){
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
          usleep(100000);
        }
        first_cw = true;
      }

      if(pp_.reachMissionIdx(cw_idx_2) && !second_cw){
        for(int i = 0; i < 35; i++){
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
          usleep(100000);
        }
        second_cw = true;
      }
    }

    // MODE 7 : 배달 B
    if (pp_.mode == 7) 
    { // 1001
      //const_lookahead_distance_ = 3;
      const_lookahead_distance_ = 3.5;
      const_velocity_ = 7;
      final_constant = 1.0;

      if(start_of_mode7_flag) {
        pp_.setWaypoints(delivery_path);
        start_of_mode7_flag = false;
      }
      //1001
      // if (delivery_B_brake_flag == false) {
      //   for (int i = 0; i < 100; i++) {
      //     publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.5);
      //     usleep(10000);
      //   }
      //   delivery_B_brake_flag = true;
      // }
      if (delivery_B_brake_flag == false) {
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.03);
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
      // 1001
      if (pp_.is_finish) {
        pp_.is_finish = false;
        const_lookahead_distance_ = 4;
        const_velocity_ = 10;
        final_constant = 1.0;
        pp_.setWaypoints(global_path);
      }
    }

    // MODE 8 : Semi-Booster
    if (pp_.mode == 8) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 8;
      const_velocity_ = 12;
      final_constant = 1.0;
    }

    // MODE 9 : 수평주차
    if (pp_.mode == 9) {
      std::cout<<pp_.is_parking_rubbercone_detected<<"입니다"<<std::endl;
      if (parking_brake_flag == false) {
        // 1001
        // for (int i = 0; i < 5; i++) {
        //   publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
        //   usleep(100000);
        // }
        for (int i = 0; i < 100; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.5);
          usleep(10000);
        }
        
        // pp_.setWaypoints(parallel_parking_path);
        parking_brake_flag = true;
        const_velocity_ = 7;
      } 
      else if (pp_.mission_flag == 1)  {
        const_lookahead_distance_ = 3;
        const_velocity_ = 6;
      }

      if (pp_.reachMissionIdx(pk_idx[check_point_index]) && is_parked == false) {
        if (pp_.is_parking_rubbercone_detected == false) {
          parking_available_flag = true;
          once_flag = false;
        }
        else if (pp_.is_parking_rubbercone_detected == true && once_flag == true) {
          once_flag = false;
          parking_available_flag = false;
          check_point_index = (check_point_index + 1) % 4;
        }
      }
      else {
        once_flag = true;
      }

      if (pp_.reachMissionIdx(pk_idx[check_point_index + 1]) && parking_available_flag == true && is_parked == false && final_parking_flag == false) {
        if (pp_.mission_flag == 0) {
          final_parking_flag = true;
          moved_distance = 0.0;
        }
      }

      if (final_parking_flag == true) {
        // 직진
        if (moved_distance < 2.2 && step == 1) {
          pulishControlMsg(7, 0);
          continue;
        } 
        else if (2.2 <= moved_distance && step == 1) {
          for(int i = 0; i < 10; i++) {
            pulishControlMsg(0, 0); 
            usleep(100000);
          }
          step = 2;
          moved_distance = 0.0;
        }
        
        // 우측 후진
        if (moved_distance < 3.0 && step == 2) {
          pulishControlMsg(-7, 30);
          continue;
        } 
        else if (3.0 <= moved_distance && step == 2) {
          for(int i = 0; i < 10; i++) {
            pulishControlMsg(0, 0); 
            usleep(100000);
          }
          step = 3;
          moved_distance = 0.0;
        }
        
        // 좌측 후진
        if (moved_distance < 2.7 && step == 3) {
          pulishControlMsg(-7, -30);
          continue;
        } 
        else if (2.7 <= moved_distance && step == 3) {
          for(int i = 0; i < 110; i++) {
            pulishControlMsg(0, 0); 
            usleep(100000);
          }
          step = 4;
          moved_distance = 0.0;
        }

        // 좌측 전진
        if (moved_distance < 3.8 && step == 4) {
          pulishControlMsg(7, -30);
          continue;
        } 
        else if (3.8 <= moved_distance && step == 4) {
          for(int i = 0; i < 10; i++) {
            pulishControlMsg(0, 0); 
            usleep(100000);
          }
          step = 5;
          moved_distance = 0.0;
        }
        
        // 우측 전진
        if (moved_distance < 3.25 && step == 5) {
          pulishControlMsg(7, 30);
          continue;
        } else if (3.25 <= moved_distance && step == 5) {
          // for(int i = 0; i < 10; i++) {
          //   pulishControlMsg(0, 0); 
          //   usleep(100000);
          // }
          step = 100;
          pp_.mission_flag = 1;
          is_parked = true;
          final_parking_flag = false;
          if (is_parked) {
            pp_.setWaypoints(global_path);
          }
        }
      }
    }

    // 마지막 waypoint 에 다다랐으면 점차 속도를 줄이기
    if (pp_.is_finish && pp_.mode == 8) {
      while(const_velocity_ > 0) {
        const_velocity_ -= 1;
        pulishControlMsg(const_velocity_,0);
      }
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
  double steering_ = can_get_curvature ? (steering_radian * 180.0 / M_PI) * -1 * final_constant : 0;
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
  

  // path.txt
  // <x, y, mode>
  geometry_msgs::Point p;
  geometry_msgs::PoseStamped p_pose;

  rviz_global_path.header.frame_id = "base_link";
  rviz_avoidance_path.header.frame_id = "base_link";
  rviz_delivery_path.header.frame_id = "base_link";

  double x, y;
  int mode;

  std::ifstream global_path_file(ROS_HOME + "/paths/" + paths[0] + ".txt");
  while(global_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;
    if (x > x_max) {
        x_max = x;
    }
    if (x < x_min) {
        x_min = x;
    }
    if (y > y_max) {
        y_max = y;
    }
    if (y < y_min) {
        y_min = y;
    }
  }

  std::ifstream avoidance_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
  while(avoidance_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;
    if (x > x_max) {
        x_max = x;
    }
    if (x < x_min) {
        x_min = x;
    }
    if (y > y_max) {
        y_max = y;
    }
    if (y < y_min) {
        y_min = y;
    }
  }
  std::ifstream delivery_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
  while(delivery_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;
    if (x > x_max) {
        x_max = x;
    }
    if (x < x_min) {
        x_min = x;
    }
    if (y > y_max) {
        y_max = y;
    }
    if (y < y_min) {
        y_min = y;
    }
  }

  global_path_file.clear();
  global_path_file.seekg(0, std::ios::beg);
  avoidance_path_file.clear();
  avoidance_path_file.seekg(0, std::ios::beg);
  delivery_path_file.clear();
  delivery_path_file.seekg(0, std::ios::beg);

  while(global_path_file >> x >> y >> mode) {
    p.x = x;
    p.y = y;
    p_pose.pose.position.x=(x-x_min)/(x_max-x_min)*100;
    p_pose.pose.position.y=(y-y_min)/(y_max-y_min)*100;
    p_pose.pose.position.z=double(0);
    p_pose.pose.orientation.x=0;
    p_pose.pose.orientation.y=0;
    p_pose.pose.orientation.z=0;
    p_pose.pose.orientation.w=1;
    rviz_global_path.poses.push_back(p_pose);
    global_path.push_back(std::make_pair(p, mode));
  }

  if (paths.size() == 3) {
    while(avoidance_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      p_pose.pose.position.x=(x-x_min)/(x_max-x_min)*100;
      p_pose.pose.position.y=(y-y_min)/(y_max-y_min)*100;
      p_pose.pose.position.z=double(0);
      p_pose.pose.orientation.x=0;
      p_pose.pose.orientation.y=0;
      p_pose.pose.orientation.z=0;
      p_pose.pose.orientation.w=1;
      rviz_avoidance_path.poses.push_back(p_pose);
      avoidance_path.push_back(std::make_pair(p, mode));
    }

    while(delivery_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      p_pose.pose.position.x=(x-x_min)/(x_max-x_min)*100;
      p_pose.pose.position.y=(y-y_min)/(y_max-y_min)*100;
      p_pose.pose.position.z=double(0);
      p_pose.pose.orientation.x=0;
      p_pose.pose.orientation.y=0;
      p_pose.pose.orientation.z=0;
      p_pose.pose.orientation.w=1;
      rviz_delivery_path.poses.push_back(p_pose);
      delivery_path.push_back(std::make_pair(p, mode));
    }
  }
  is_waypoint_set_ = true;
}

void PurePursuitNode::publishTargetPointVisualizationMsg() {
  geometry_msgs::PointStamped target_point_msg;
  target_point_msg.header.frame_id = "base_link";
  target_point_msg.header.stamp = ros::Time::now();
  target_point_msg.point = pp_.getPoseOfNextTarget();
  target_point_msg.point.x=(target_point_msg.point.x-x_min)/(x_max-x_min)*100;
  target_point_msg.point.y=(target_point_msg.point.y-y_min)/(y_max-y_min)*100;
  target_point_pub.publish(target_point_msg);
}


void PurePursuitNode::publishCurrentPointVisualizationMsg() {
  geometry_msgs::PointStamped current_point_msg;
  current_point_msg.header.frame_id = "base_link";
  current_point_msg.header.stamp = ros::Time::now();
  current_point_msg.point = pp_.getCurrentPose();
  current_point_msg.point.x=( current_point_msg.point.x-x_min)/(x_max-x_min)*100;
  current_point_msg.point.y=( current_point_msg.point.y-y_min)/(y_max-y_min)*100;
  current_point_pub.publish(current_point_msg);
}

void PurePursuitNode::publishCurrentPoseVisualizationMsg() {
  geometry_msgs::PointStamped rviz_current_pose;
  rviz_current_pose.header.frame_id = "base_link";
  rviz_current_pose.header.stamp = ros::Time::now();
  rviz_current_pose.point = pp_.current_pose_.position;
  rviz_current_pose.point.x=( rviz_current_pose.point.x-x_min)/(x_max-x_min)*100;
  rviz_current_pose.point.y=( rviz_current_pose.point.y-y_min)/(y_max-y_min)*100;
  rviz_current_pose_pub.publish(rviz_current_pose);
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
  pp_.gps_velocity = msg.data / 3.6;
  moved_distance += pp_.gps_velocity * 0.125;
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

void PurePursuitNode::callbackFromParkingRubberCone(const std_msgs::Bool& msg) {
  pp_.is_parking_rubbercone_detected = msg.data;
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
    // 1001 밑에 원본 있음
    // else if (msg.x >= delivery_sign_cutline && get_x_distance == true) {
    //   if (pp_.mode == 7 && (a_max_index != b_max_index)) {
    //     pp_.is_delivery_obs_stop_detected = 0;
        
    //     delivery_x_distance = 0.0;
    //     get_x_distance = false;
    //   }
    //   else if (pp_.mode == 3) {
    //     pp_.is_delivery_obs_stop_detected = 0;
        
    //     delivery_x_distance = 0.0;
    //     get_x_distance = false;
    //   }
    // }
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
        a_show_flag = true;
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

void PurePursuitNode::callbackFromTrafficLight(const darknet_ros_msgs::BoundingBoxes& msg){
}


void PurePursuitNode::callbackFromTrafficLight2(const std_msgs::Int32& msg) {
  if (msg.data==2){
    pp_.straight_go_flag=true;
    pp_.left_go_flag=true;
    }
    
  else if (msg.data ==1){
    pp_.straight_go_flag=true;
    pp_.left_go_flag=false;
    
  }
  else if (msg.data == 3){
    pp_.left_go_flag=true;
    pp_.straight_go_flag=false;
  }
  else{
    pp_.left_go_flag=false;
    pp_.straight_go_flag=false;
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