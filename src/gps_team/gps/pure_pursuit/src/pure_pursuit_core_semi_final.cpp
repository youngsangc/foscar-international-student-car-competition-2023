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
#include <std_msgs/Bool.h>
#include<std_msgs/Int32.h>



//터널 정적장애물 include 파일

#include "../include/tunnel_static_obstacle.h"
//#include <morai_msgs/CtrlCmd.h>
//#include <race/drive_values.h>




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
  , left_right()
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

float steering_memory = 0;

/* traffic Index manager */
int tf_idx_1 = 1000; // 1180

int slow_down_tf_idx_1 = 1000;

const float tf_coord1[2] = {935572.7866943456, 1915921.7229049096};

const float slow_down_tf_coord1[2] = {935565.651362, 1915908.8576};

bool index_flag = false;
bool is_parked = false;
bool is_dynamic = false;

/* Parking manager */
int start_parking_idx = 0;
int end_parking_idx = 0;
int end_parking_backward_idx = 0;
int end_parking_full_steer_backward_idx = 0;

// For kcity (kcity 주차 좌표)
const float pk_coord1[2] = {935534.247324, 1915849.29071};
const float pk_coord2[2] = {935536.127777, 1915852.74891};
const float pk_coord3[2] = {935537.027791, 1915854.43949};
const float pk_coord4[2] = {935539.530479, 1915859.22427};
const float pk_coord5[2] = {935540.465801, 1915860.89238};
const float pk_coord6[2] = {935541.86021, 1915863.43345};

// For School Test (학교 주차 좌표)
// const float pk_coord1[2] = {955568.258427, 1956932.10464};48 87
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
  static_obstacle_short_sub = nh_.subscribe("/static_obs_flag_short", 1, &PurePursuitNode::callbackFromStaticObstacleShort, this);
  static_obstacle_long_sub = nh_.subscribe("/static_obs_flag_long", 1, &PurePursuitNode::callbackFromStaticObstacleLong, this);
  dynamic_obstacle_short_sub = nh_.subscribe("/dynamic_obs_flag_short", 1, &PurePursuitNode::callbackFromDynamicObstacleShort, this);
  dynamic_obstacle_long_sub = nh_.subscribe("/dynamic_obs_flag_long", 1, &PurePursuitNode::callbackFromDynamicObstacleLong, this);

  traffic_light_sub = nh_.subscribe("darknet_ros/bounding_boxes",1, &PurePursuitNode::callbackFromTrafficLight, this);

  delivery_obs_sub1 = nh_.subscribe("delivery_obs_calc", 1, &PurePursuitNode::callbackFromDeliveryObstacleCalc, this);
  delivery_obs_sub2 = nh_.subscribe("delivery_obs_stop", 1, &PurePursuitNode::callbackFromDeliveryObstacleStop, this);
 
  //delivery subscriber
  delivery_sub = nh_.subscribe("delivery", 1, &PurePursuitNode::callbackFromDelivery, this);

  // setup publisher
  drive_msg_pub = nh_.advertise<race::drive_values>("control_value", 1);
  steering_vis_pub = nh_.advertise<geometry_msgs::PoseStamped>("steering_vis", 1);

  // for visualization
  target_point_pub = nh_.advertise<geometry_msgs::PointStamped>("target_point", 1);
  current_point_pub = nh_.advertise<geometry_msgs::PointStamped>("current_point", 1);

  // publisher for Tunnel

  // lane_detector_switch_pub = nh_.advertise<std_msgs::Int32>("lane_detection_switch",1);




  
}

void PurePursuitNode::run(char** argv) {

  ROS_INFO_STREAM("pure pursuit2 start");

  pp_.mode = 7;

  



  left_right = atoi(argv[2]);
  parking_num = atoi(argv[3]);

  ros::Rate loop_rate(LOOP_RATE_);
  while (ros::ok()) {
    ros::spinOnce();

    // std_msgs::Int32 lane_switch;

    

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
      slow_down_tf_idx_1 = pp_.getPosIndex(slow_down_tf_coord1[0] , slow_down_tf_coord1[1]);
    }

    //ROS_INFO("MODE=%d, MISSION_FLAG=%d", pp_.mode, pp_.mission_flag);
    

  
    // MODE 0 - 직진구간
    // MODE 1 - 주차구간
    // MODE 2 - 신호등 and 커브구간
    // MODE 3 - 그냥 커브
    // MODE 4 - 정적장애물
    // MODE 5 - 동적장애물
    // MODE 6 - Semi-Booster
    // MODE 7 - 터널 정적장애물 23년도 추가
    // MODE 8 - 유턴

    // MODE 8 - 유턴

    if (pp_.mode == 8) {
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

      // if (pp_.reachMissionIdx(ut_idx)) {
      //   if(pp_.mission_flag == 0) {
      //     for (int i = 0; i < 10; i++) {
      //       publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
      //       usleep(100000);  // 0.1초
      //     }
      //     pp_.mission_flag = 1;
      //   }

      //   if(pp_.mission_flag == 1){
      //     if(!pp_.left_go_flag){
      //       publishPurePursuitDriveMsg(can_get_curvature, kappa, 1);
      //       continue;
      //     }
          
      //   }
      // }

      // if (pp_.mission_flag == 1) {
      //   const_lookahead_distance_ = 1.25;
      //   for (int i = 0; i < 80; i++) {
      //     pulishControlMsg(7, -30);
      //     usleep(100000);  // 0.1초
      //     pp_.mission_flag = 2;
      //   }
      // }

      // else if (pp_.mission_flag == 2) {
      //   for(int i = 0; i < 22; i++) {
      //     pulishControlMsg(5, 0);
      //   }
      //   pp_.setWaypoints(global_path);
      //   pp_.mission_flag = 3;
      // }
    }







    // MODE 0 - 직진구간
    if (pp_.mode == 0) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;//원래 10이였음
      const_velocity_ = 8;
      final_constant = 1.0;
     
        //동적장애물 멀리서 장애물 감지 -> 감속
      while(pp_.is_dynamic_obstacle_detected_long) {
        if (const_velocity_ > 5) {
          const_velocity_ -= 0.1;
          publishPurePursuitDriveMsg(can_get_curvature, kappa);
          ros::spinOnce();
          loop_rate.sleep();
        }
      }

      // 동적장애물 멈춰야하는 거리
      while(pp_.is_dynamic_obstacle_detected_short) {
        publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
        ROS_INFO_STREAM("OBSTACLE DETECT");
        ros::spinOnce();
        loop_rate.sleep();
      }


      ////////////////////////////////////////////


    }
      //int obstacle_detected_number = 0;

      // 동적 장애물 추가된 코드 

  //     while(obstacle_detected_number != 2)
  //    {
  //     if(pp_.is_dynamic_obstacle_detected_long == true || pp_.is_dynamic_obstacle_detected_short == true)
  //    {
  //     pp_.is_dynamic_obstacle_detected_long = false;
  //     pp_.is_dynamic_obstacle_detected_short = false;
  //     obstacle_detected_number++;
  //     ros::spinOnce();
  //     loop_rate.sleep();
  //    }
  //    else if(obstacle_detected_number == 1)
  //   {
  //   const_velocity_ = 10;
  //   const_lookahead_distance_ = 6;
  //   final_constant = 1.0;
  //   for (int i = 0; i < 3; i++) {
  //     publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.03);
  //     usleep(100000);
  //   }
  //   }
   
  //  }      
    
  //  if(obstacle_detected_number == 2)
  //  {
  //   while(pp_.is_dynamic_obstacle_detected_long)
  //   {
  //     if (const_velocity_ > 5) {
  //       const_velocity_ -= 0.1;
  //       publishPurePursuitDriveMsg(can_get_curvature, kappa);
  //       ros::spinOnce();
  //       loop_rate.sleep();
  //     }                
    // }
         
     
  //   while(pp_.is_dynamic_obstacle_detected_short)
  //   {
  //     publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
  //     ROS_INFO_STREAM("OBSTACLE DETECT");
  //     ros::spinOnce();
  //     loop_rate.sleep();
  //   }    
  // }  



    // MODE 1 - 주차
    if (pp_.mode == 1) {
      pp_.is_finish = false;
      if (!is_parked) {
        if (pp_.mission_flag == 3 || pp_.mission_flag == 0) {
          const_lookahead_distance_ = 6;
          const_velocity_ = 6;
        }

        // first
        if (parking_num == 1) {
          start_parking_idx = pp_.getPosIndex(pk_coord1[0], pk_coord1[1]);
          end_parking_idx = 120;
          end_parking_backward_idx = 100;
          end_parking_full_steer_backward_idx = 75;
        }

        // second
        else if (parking_num == 2) {
          start_parking_idx = pp_.getPosIndex(pk_coord2[0], pk_coord2[1]);
          // end_parking_idx = 87;
          end_parking_idx = 80;
          end_parking_backward_idx = 55;
          end_parking_full_steer_backward_idx = 25;
        }

        // third
        else if (parking_num == 3) {
          start_parking_idx = pp_.getPosIndex(pk_coord3[0], pk_coord3[1]);
          // end_parking_idx = 145;
          end_parking_idx = 138;std::cout<<"XXXXXXXXXXXXXXXXXXXX"<<std::endl;
          end_parking_backward_idx = 117; // 120
          end_parking_full_steer_backward_idx = 90;
        }  

        // forth
        else if (parking_num == 4) {
          start_parking_idx = pp_.getPosIndex(pk_coord4[0], pk_coord4[1]);
          // end_parking_idx = 88;
          end_parking_idx = 80;
          end_parking_backward_idx = 55;
          end_parking_full_steer_backward_idx = 23;
        }

        // fifth
        else if (parking_num == 5) {
          start_parking_idx = pp_.getPosIndex(pk_coord5[0], pk_coord5[1]);
          end_parking_idx = 80;
          end_parking_backward_idx = 50;
          end_parking_full_steer_backward_idx = 23;
        }

        //sixth
        else if (parking_num == 6) {
          start_parking_idx = pp_.getPosIndex(pk_coord6[0], pk_coord6[1]);
          end_parking_idx = 75;
          end_parking_backward_idx = 55;
          end_parking_full_steer_backward_idx = 25;
        }

        int backward_speed = -9;

        if (pp_.mission_flag == 0 && pp_.next_waypoint_number_ >= start_parking_idx) {
          pp_.setWaypoints(parking_path);
          const_lookahead_distance_ = 3;
          const_velocity_ = 3;  // 3
          pulishControlMsg(const_velocity_ , 0);
          pp_.mission_flag = 1;
        }

        // 주차 끝
        if (pp_.mission_flag == 1 && pp_.reachMissionIdx(end_parking_idx)) {
          // 10초 멈춤
          for (int i = 0; i < 110; i++) {
            pulishControlMsg(0, 0);
            usleep(100000); // 0.1초
          }

          // 특정 지점까지는 그냥 후진
          while (!pp_.reachMissionIdx(end_parking_backward_idx)) {
            pulishControlMsg(backward_speed, 0);
            ros::spinOnce();
          }
          
          // 그 다음 지점까지는 풀조향 후진
          while (!pp_.reachMissionIdx(end_parking_full_steer_backward_idx)) {
            pulishControlMsg(backward_speed, 30);
            ros::spinOnce();
          }
          pp_.mission_flag = 2;
        }

        // 주차 빠져나오고 다시 global path로
        if (pp_.mission_flag == 2) {
          for (int i = 0; i < 15; i++) {
            pulishControlMsg(0, 0);
            // 0.1초
            usleep(100000);
          }
          pp_.setWaypoints(global_path);
          pp_.mission_flag = 3;
        }

        if (pp_.mission_flag == 3) {
          const_lookahead_distance_ = 6;
          const_velocity_ = 15;
          final_constant = 1.0;
          is_parked = true;
        }
      }

      else {
        if (pp_.mission_flag == 3 || pp_.mission_flag == 0) {
          const_lookahead_distance_ = 6;
          const_velocity_ = 13;
        }
      }
    }

    // MODE 2 : 신호등 and 커브
    if (pp_.mode == 2) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 10;
      final_constant = 1.0;

      // When traffic lights are RED at slow_down_point -> SLOWNIG DOWN
      if (pp_.reachMissionIdx(slow_down_tf_idx_1) && !pp_.straight_go_flag) {
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.05);
          usleep(100000);
        }
        ROS_INFO_STREAM("*****RED LIGHT SLOWING DOWN*****");
      }

      // When traffic lights are GREEN at slow_down_point -> SPEEDING UP
      else if (pp_.reachMissionIdx(slow_down_tf_idx_1) && pp_.straight_go_flag) {
        while(const_velocity_ < 10) {
          const_velocity_ += 0.1;
          publishPurePursuitDriveMsg(can_get_curvature, kappa);
          ROS_INFO_STREAM("*****GREEN LIGHT SPEEDING UP*****");
        }
      }

      // 첫 신호등 인덱스 : tf_idx_1
      if (pp_.reachMissionIdx(tf_idx_1) && !pp_.straight_go_flag) {
        while(!pp_.straight_go_flag)
        {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
          ros::spinOnce();
        }
        continue;
      }
    }

    // MODE 3 - 그냥 커브
    if (pp_.mode == 3) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 5;
      const_velocity_ = 10;
      final_constant = 1.2;

        //동적장애물 멀리서 장애물 감지 -> 감속
        while(pp_.is_dynamic_obstacle_detected_long) {
          if (const_velocity_ > 5) {
            const_velocity_ -= 0.1;
            publishPurePursuitDriveMsg(can_get_curvature, kappa);
            ros::spinOnce();
            loop_rate.sleep();
          }
        }
 
        // 동적장애물 멈춰야하는 거리
        while(pp_.is_dynamic_obstacle_detected_short) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
          ROS_INFO_STREAM("OBSTACLE DETECT");
          ros::spinOnce();
          loop_rate.sleep();
        }


        //////////////////////////////////////////////////////


      }
    

    //  MODE 4 : 정적장애물 감지되면 avoidance path로 진로변경 후 원래 global path로 복귀 (드럼통)
    if (pp_.mode == 4) {
      if (left_right == 0) { // 장애물 오왼
        if (pp_.mission_flag == 0) {
          pp_.setWaypoints(left_path);
          const_lookahead_distance_ = 3;
          const_velocity_ = 5;
          final_constant = 1.0;
          pp_.mission_flag = 1;
        }

        if (pp_.mission_flag == 1 && pp_.is_static_obstacle_detected_short) {
          pp_.mission_flag = 2;
          pulishControlMsg(2.0, 26);
          continue;
        }

        else if (pp_.mission_flag == 2 && pp_.is_static_obstacle_detected_short) {
          pulishControlMsg(2.0, 26);
          continue;
        }

        else if (pp_.mission_flag == 2 && !pp_.is_static_obstacle_detected_short) {
          const_lookahead_distance_ = 5;
          pp_.setWaypoints(right_path);
          pp_.mission_flag = 3;
          pulishControlMsg(2, -26);
          continue;
        }

        else if (pp_.mission_flag == 3 && !pp_.is_finish) {
          const_lookahead_distance_ = 4;
          const_velocity_ = 7;
          final_constant = 1.0;
        }

        else if (pp_.mission_flag == 3 && pp_.is_finish) {
          const_lookahead_distance_ = 4;
          pp_.setWaypoints(global_path);
          const_velocity_ = 7;
          final_constant = 1.0;
          pp_.is_finish = false;
          pp_.mission_flag = 4;
        }
      }

      else if (left_right == 1) { // 장애물 왼오
        if (pp_.mission_flag == 0) {
          const_lookahead_distance_ = 3;
          pp_.setWaypoints(right_path);
          const_velocity_ = 5;
          final_constant = 1.0;
          pp_.mission_flag = 1;
        }

        if (pp_.mission_flag == 1 && pp_.is_static_obstacle_detected_short) {
          pp_.mission_flag = 2;
          pulishControlMsg(2.0, -26);
          continue;
        }

        else if (pp_.mission_flag == 2 && pp_.is_static_obstacle_detected_short) {
          pulishControlMsg(2.0, -26);
          continue;
        }

        else if (pp_.mission_flag == 2  && !pp_.is_static_obstacle_detected_short) {
          const_lookahead_distance_ = 5;
          pp_.setWaypoints(left_path);
          pp_.mission_flag = 3;
          pulishControlMsg(2, 26);
          continue;
        }

        else if (pp_.mission_flag == 3 && !pp_.is_finish) {
          const_lookahead_distance_ = 4;      publishPurePursuitDriveMsg(can_get_curvature, kappa);

      is_pose_set_ = false;
      loop_rate.sleep();
          const_velocity_ = 7;
          final_constant = 1.0;
        }

        else if (pp_.mission_flag == 3 && pp_.is_finish) {
          const_lookahead_distance_ = 4;
          pp_.setWaypoints(global_path);          
          const_velocity_ = 7;
          final_constant = 1.0;
          pp_.is_finish = false;
          pp_.mission_flag = 4;
        }
      }


///////////////////////////////////////////////


    } 

    // MODE 5 : 동적장애물 
    if (pp_.mode == 5) {

      //std::cout<<"XXXXXXXXXXXXXXXXXXXX"<<std::endl;
      const_velocity_ = 10;
      const_lookahead_distance_ = 6;
      final_constant = 1.0;
      
      if (pp_.mission_flag == 0) {  
        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.03);
          usleep(100000);
        }
        pp_.mission_flag = 1;
      }

      else if (pp_.mission_flag == 1) {
        //동적장애물 멀리서 장애물 감지 -> 감속
        while(pp_.is_dynamic_obstacle_detected_long) {
          if (const_velocity_ > 5) {
            const_velocity_ -= 0.1;
            publishPurePursuitDriveMsg(can_get_curvature, kappa);
            ros::spinOnce();
            loop_rate.sleep();
          }
        }
 
        // 동적장애물 멈춰야하는 거리
        while(pp_.is_dynamic_obstacle_detected_short) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
          ROS_INFO_STREAM("OBSTACLE DETECT");
          ros::spinOnce();
          loop_rate.sleep();
        }
      }

/////////////////////////////////////////////////


    }
    
    // MODE 6 : Semi-Booster
    if (pp_.mode == 6) {
      pp_.mission_flag = 0;
      const_lookahead_distance_ = 8;
      const_velocity_ = 16;
      final_constant = 1.0;

      ////////////////////////////////////////////////////////



    }

    // MODE 7 터널 정적장애물


    if(pp_.mode == 7){
      
      //         //동적장애물 멀리서 장애물 감지 -> 감속
      
              
      // while(pp_.is_dynamic_obstacle_detected_long) {
      //   if (const_velocity_ > 5) {
      //     const_velocity_ -= 0.1;
      //     publishPurePursuitDriveMsg(can_get_curvature, kappa);
      //     ros::spinOnce();
      //     loop_rate.sleep();
      //   }
      // }

      // // 동적장애물 멈춰야하는 거리
      // while(pp_.is_dynamic_obstacle_detected_short) {
      //   publishPurePursuitDriveMsg(can_get_curvature, kappa, 1.0);
      //   ROS_INFO_STREAM("OBSTACLE DETECT");
      //   ros::spinOnce();
      //   loop_rate.sleep();
      // }


      ////////////////////////////////////////////

      pp_.mission_flag = 0;

      // lane_switch.data = 1;


      // lane_bool.data = 1;

      // lane_pub.publish(lane_bool);

      // std::cout<<"Lane_Bool : "<<lane_bool.data<<std::endl;


      if(pp_.mission_flag == 0){

        std::cout<<"감속 시작"<<std::endl;

        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.03);
          usleep(100000);

        }
        
        pp_.mission_flag = 1;

      }

      if(pp_.mission_flag == 1){

        for (int i = 0; i < 3; i++) {
          publishPurePursuitDriveMsg(can_get_curvature, kappa, 0.03);
          usleep(100000);

        
        }

        std::cout<<"객체 생성 "<<std::endl;

        Static_Waypoint_Maker* Tunnel_Static_Obstacle = new Static_Waypoint_Maker();


        dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig> server;
        dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig>::CallbackType f;
        f = boost::bind(&cfgCallback, _1, Tunnel_Static_Obstacle);
        server.setCallback(f);

        pp_.mission_flag = 2;


      }
      
        


      if(pp_.mission_flag == 2){

        // std::cout<<"mission_flag3: "<<*mission_flag<<std::endl;
        

        

        // if(*mission_flag==3){
        //   std::cout<<"mission_flag4: "<<*mission_flag<<std::endl;

        //   std::cout<<"set Path set Path set Path set Path set Path set Path set Path set Path"<<std::endl;


        //     pp_.setWaypoints(global_path);
        //     std::cout<<"mission_flag5: "<<*mission_flag<<std::endl;

          



        // }
        // std::cout<<"mission_flag6: "<<*mission_flag<<std::endl;



      }

        

      

        



        //ros::init(argc, argv, "waypoint_maker_static_obstacle");

        // std::cout<<"노드 생성"<<endl;

        // Static_Waypoint_Maker Tunnel_Static_Obstacle;

        // if(Tunnel_Static_Obstacle.avoid_flag==3){
 


        // 프로그램 종료 전, 마지막으로 할당된 인스턴스를 메모리에서 해제
        // if (Tunnel_Static_Obstacle != nullptr) {
        //     delete Tunnel_Static_Obstacle;
        //     Tunnel_Static_Obstacle = nullptr;
        // }
        //   std::cout<<"set Path set Path set Path set Path set Path set Path set Path set Path"<<std::endl;

        //   pp_.setWaypoints(global_path);

        // }



        // dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig> server;
        // dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig>::CallbackType f;
        // f = boost::bind(&cfgCallback, _1, &Tunnel_Static_Obstacle);
        // server.setCallback(f);

        // ros::spin(); 

        // Tunnel_Static_Obstacle 동적으로 할당
        // Static_Waypoint_Maker* Tunnel_Static_Obstacle = new Static_Waypoint_Maker();

        //   // avoid_flag의 값을 설정해야 하므로, Static_Waypoint_Maker 클래스에 적절한 초기화 방법이 있어야 합니다.
        //   if (Tunnel_Static_Obstacle->avoid_flag == 3) {


        //       delete Tunnel_Static_Obstacle;
        //       Tunnel_Static_Obstacle = nullptr; // 포인터를 nullptr로 설정
        //       std::cout << "set Path set Path set Path set Path set Path set Path set Path set Path" << std::endl;
        //       pp_.setWaypoints(global_path);
        //   }

          

        

        ros::spin();


        // 프로그램 종료 전, 마지막으로 할당된 인스턴스를 메모리에서 해제
        // if (Tunnel_Static_Obstacle != nullptr) {
        //     delete Tunnel_Static_Obstacle;
        //     Tunnel_Static_Obstacle = nullptr;
        // }
    }


    // 마지막 waypoint 에 다다랐으면 점차 속도를 줄이기
    if (pp_.is_finish && pp_.mode == 6) {
      while(const_velocity_ > 0) {
        const_velocity_ -= 1;
        pulishControlMsg(const_velocity_,0);
      }
      ROS_INFO_STREAM("Finish Pure Pursuit");
      //마지막 waypoint라면 코드를 종료하기 위함 안될시 삭제요망
      ros::shutdown(); 
      continue;






      //////////////////////////////////

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
  


  
  // if(steering_>=0){//우리 차량이 오른쪽으로 꺽을때 더 큰값을 줘야함

  //   steering_*=3.0;
  //   std::cout<<"steering 왼쪽: "<<steering_<<"\n";

  // } else {
  //   steering_*=0.3;
  //   std::cout<<"steering 오른쪽: "<<steering_<<"\n";
  // }
  
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


  if (paths.size() == 4) {
    std::ifstream left_path_file(ROS_HOME + "/paths/" + paths[1] + ".txt");
    while(left_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      left_path.push_back(std::make_pair(p, mode));
    }

    std::ifstream right_path_file(ROS_HOME + "/paths/" + paths[2] + ".txt");
    while(right_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      right_path.push_back(std::make_pair(p, mode));
    }

    std::ifstream parking_path_file(ROS_HOME + "/paths/" + paths[3] + ".txt");
    while(parking_path_file >> x >> y >> mode) {
      p.x = x;
      p.y = y;
      parking_path.push_back(std::make_pair(p, mode));
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

void PurePursuitNode::callbackFromDeliveryObstacleCalc(const lidar_team_erp42::Delivery& msg) {
  return;
}

void PurePursuitNode::callbackFromDeliveryObstacleStop(const lidar_team_erp42::Delivery& msg) {
  return;
}

void PurePursuitNode::callbackFromDelivery(const vision_distance::DeliveryArray& msg) {
  return;
}

void PurePursuitNode::callbackFromTrafficLight(const darknet_ros_msgs::BoundingBoxes& msg) {
  std::vector<darknet_ros_msgs::BoundingBox> yoloObjects = msg.bounding_boxes;
  std::vector<darknet_ros_msgs::BoundingBox> deliveryObjectsA, deliveryObjectsB;

  // 신호등 객체만 따로 검출함 (원근법 알고리즘 적용위함)
  std::vector<darknet_ros_msgs::BoundingBox> traffic_lights;
  for(int i=0; i<yoloObjects.size(); i++) {
    if (yoloObjects[i].Class == "3 red" || yoloObjects[i].Class == "3 yellow" || yoloObjects[i].Class == "3 green" || yoloObjects[i].Class == "3 left"
      || yoloObjects[i].Class == "4 red" || yoloObjects[i].Class == "4 yellow" || yoloObjects[i].Class == "4 green"
      || yoloObjects[i].Class == "4 redleft" || yoloObjects[i].Class == "4 greenleft"  || yoloObjects[i].Class == "4 redyellow") {

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
