#include <vector>
#include <pure_pursuit_core.h>
#include <fstream>
#include <cstdlib>
#include <unistd.h>
#include <time.h>
#include <chrono>
#include <algorithm>

#include <tf/transform_broadcaster.h>



// for delivery obstacle (stop)
void PurePursuitNode::callbackFromObstacleDelivery1(const avoid_obstacle::TrueObstacles& msg) {
  pp_.delivery_angle = msg.angle;
  pp_.delivery_x = msg.x;
  // x가 0이랑 근점, angle -값이 너무 커지면 안됨

  if(pp_.delivery_x <= 0.3 or pp_.delivery_angle <= -5) {
    pp_.is_delivery_obs_stop_detected = 1;
    pp_.is_delivery_obs_calc_detected = 0;
  }
//   if(pp_.is_delivery_obs_stop_detected)
//     pp_.is_delivery_obs_calc_detected = 0;
  //std::cout << "msg.detected : " << msg.detected << std::endl;
}
//msg
//x
//angle

// // 토픽 타입
// // for delivery obstacle (calc) - 판단로직
// void PurePursuitNode::callbackFromObstacleDelivery2(const avoid_obstacle::TrueObstacles& msg) {
//   if(msg.detected)
//     pp_.is_delivery_obs_calc_detected = msg.detected;

//   if(pp_.is_delivery_obs_stop_detected)
//     pp_.is_delivery_obs_calc_detected = 0;
//   //std::cout << "msg.detected : " << msg.detected << std::endl;
// }



// MODE 9 : 배달 A 전 진입구간
if (pp_.mode == 9){
    pp_.mission_flag = 0;
    const_lookahead_distance_ = 4;
    const_velocity_ = 7.5;
    final_constant = 1.8;
}


// MODE 10 : 배달 PICK A
if (pp_.mode == 10) {
    const_lookahead_distance_ = 6;
    const_velocity_ = 4;
    final_constant = 1.2;

    ROS_INFO("DELIVERY_A STOP FLAG=%d", pp_.is_delivery_obs_calc_detected);

    // if(pp_.is_delivery_obs_stop_detected) ROS_INFO("DELIVERY OBSTACLE DETECT!!!");
    if(pp_.mission_flag==0 && pp_.is_delivery_obs_stop_detected) {
    ROS_INFO("DELIVERY OBSTACLE DETECT!!!");
    pp_.mission_flag = 1;
    
    for (int i = 0; i < 55; i++)
    {
        pulishControlMsg(0, 0);
        // 0.1초
        usleep(100000);
    }
    continue;
    }

    if(pp_.mission_flag == 1){
    const_velocity_ = 9; // if not calculated a_max_index

    }
}

// 배달 A 구간 끝나고 바로 A_INDEX 계산함
if (pp_.mode == 11 && !a_cnt_flag){
    // if not calculated a_max_index
    // Calc max_index
    a_max_index = max_element(pp_.a_cnt.begin(), pp_.a_cnt.end()) - pp_.a_cnt.begin();
    ROS_INFO("A INDEX : %d",a_max_index);

    // Max flag on
    pp_.a_flag[a_max_index] = true;

    // Lock the a_cnt_flag
    a_cnt_flag = true;
    ROS_INFO("A1_f %d A2_f %d A3_f %d",pp_.a_flag[0], pp_.a_flag[1], pp_.a_flag[2]);
}

// MODE 19 : 배달 B 전 진입구간
if (pp_.mode == 19){
    pp_.mission_flag = 0;
    const_lookahead_distance_ = 4;
    const_velocity_ = 6;
    final_constant = 1.5;

    // for test
    // a_max_index = 0;
    // pp_.a_flag[a_max_index] = true;
}

// MODE 20 : 배달 PICK B
if (pp_.mode == 20) {
    const_lookahead_distance_ = 6;
    const_velocity_ = 4;
    final_constant = 1.2;
    
    ROS_INFO("MISSION_FLAG=%d) A_INDEX(%d)  B_INDEX(%d)", pp_.mission_flag, a_max_index, b_max_index);
    ROS_INFO("B1=%d, B2=%d, B3=%d", pp_.b_cnt[0],pp_.b_cnt[1], pp_.b_cnt[2]);
    ROS_INFO("CALC_FLAG=%d, STOP_FLAG=%d", pp_.is_delivery_obs_calc_detected, pp_.is_delivery_obs_stop_detected);

    
    // case 2) vision_distance + gps 로직
    if(pp_.mission_flag == 0 && pp_.is_delivery_obs_calc_detected){
    pp_.mission_flag = 1;
    }
    else if(pp_.mission_flag == 22 && pp_.is_delivery_obs_calc_detected){
    pp_.mission_flag = 2;
    }
    else if(pp_.mission_flag == 33 && pp_.is_delivery_obs_calc_detected){
    pp_.mission_flag = 3;
    }

    
    if((pp_.mission_flag == 1 || pp_.mission_flag == 2 || pp_.mission_flag == 3) && pp_.is_delivery_obs_stop_detected){
    b_max_index = max_element(pp_.b_cnt.begin(), pp_.b_cnt.end()) - pp_.b_cnt.begin();
    if (a_max_index == b_max_index) {
        ROS_INFO("B DELIVEY STOP");
        // Max flag on
        for (int i = 0; i < 55; i++)
        {
        pulishControlMsg(0, 0);
        usleep(100000);  // 0.1초
        }
        pp_.mission_flag = 100;
    }else{
        pp_.b_cnt = {0,0,0};
        if(pp_.mission_flag == 1){ pp_.mission_flag = 22; }
        else if(pp_.mission_flag == 2){ pp_.mission_flag = 33; }
        
    }
    }

    if(pp_.mission_flag == 100){
    const_lookahead_distance_ = 4;
    const_velocity_ = 11;
    final_constant = 1.4;
    }

}

void PurePursuitNode::callbackFromDelivery(const vision_distance::DeliveryArray& msg){
  std::vector<vision_distance::Delivery> deliverySign = msg.visions;

  // B Area
  if (pp_.mode == 20 && (pp_.mission_flag == 1 || pp_.mission_flag == 2 || pp_.mission_flag == 3)){
    sort(deliverySign.begin(), deliverySign.end(), compare2);
    
    if(deliverySign.size() > 0){
      if(deliverySign[0].flag < 4){
        pp_.b_cnt[deliverySign[0].flag-1] += 1;
      }
    }
  }

  // A Area
  if (pp_.mode == 10 && pp_.mission_flag == 0){
    sort(deliverySign.begin(), deliverySign.end(), compare2);
    
    if(deliverySign.size() > 0){
      if(deliverySign[0].flag >= 4){
        pp_.a_cnt[deliverySign[0].flag-4] += 1;
      }
    }
  }


}



