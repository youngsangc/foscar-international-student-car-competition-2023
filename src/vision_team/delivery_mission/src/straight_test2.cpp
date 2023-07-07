#include <vector>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <unistd.h>
#include <ctime>
#include <chrono>
#include <algorithm>
#include <race/drive_values.h>
#include <tf/transform_broadcaster.h>
#include <ros/ros.h>

using namespace std;

int mode = 9;
int mission_flag = 0;

int is_delivery_obs_stop_detected = 0;

int a_max_index = -1;
int b_max_index = -1;


bool a_cnt_flag = false;
bool b_cnt_flag = false;

vector<int> a_cnt = {0, 0 ,0};
vector<int> b_cnt = {0, 0, 0};

double delivery_x_dist;
double delivery_angle;

ros::Publisher drive_msg_pub;


// bool compare2(vision_distance::Delivery a, vision_distance::Delivery b) {
//   return a.dist_y < b.dist_y ? true : false;
// }

// void callbackFromDeliveryObstacleStop(const lidar_team_erp42::Delivery& msg) {
//   // cout << "HELLO" << '\n';
//   if ((msg.x != 0 &&  msg.angle != 0) && (mode == 10 || mode == 20)) {
//     // msg.angle >=95 수정
//     if (msg.x > -0.05 && msg.x < 0.16) {   
//       is_delivery_obs_stop_detected++;
//       cout << "STOP CHANGE !!!!!!!! + is_del_obs_stop_num : " << is_delivery_obs_stop_detected << '\n';
//     }
//     else {
//       is_delivery_obs_stop_detected = 0;
//     }

//   }
// }


// void callbackFromDelivery(const vision_distance::DeliveryArray& msg){
//   vector<vision_distance::Delivery> deliverySign = msg.visions;

//   // A Area
//   if (mode == 10 && mission_flag == 0){
//     sort(deliverySign.begin(), deliverySign.end(), compare2);
    
//     if(deliverySign.size() > 0){
//       if(deliverySign[0].flag >= 4){
//         a_cnt[deliverySign[0].flag-4] += 1;
//         cout << "deliverySign: " << deliverySign[0].flag-4 << '\n';
//         cout << "a_cnt: " << a_cnt[deliverySign[0].flag-4] << '\n';
//       }
//     }
//   }

//   // B Area
//   if (mode == 20 && (mission_flag == 1 || mission_flag == 2 || mission_flag == 3)){
//     sort(deliverySign.begin(), deliverySign.end(), compare2);
    
//     if(deliverySign.size() > 0){
//       if(deliverySign[0].flag < 4){
//         //std::cout << b_cnt << std::endl;
//         b_cnt[deliverySign[0].flag-1] += 1;
//         cout << "deliverySign: " << deliverySign[0].flag-1 << '\n';
//         cout << "b_cnt: " << a_cnt[deliverySign[0].flag-1] << '\n';
//       }
//     }
//   }
// }

void publishControlMsg(double throttle, double steering) {
  race::drive_values drive_msg;
  drive_msg.throttle = throttle;
  drive_msg.steering = steering;
  drive_msg_pub.publish(drive_msg);
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "straight_test2");
    ros::NodeHandle nh_;

    // ros::Subscriber delivery_sub = nh_.subscribe("delivery", 1, callbackFromDelivery);
    // ros::Subscriber delivery_obs_sub1 = nh_.subscribe("delivery_information", 1, callbackFromDeliveryObstacleStop);

    drive_msg_pub = nh_.advertise<race::drive_values>("control_value", 1);

    while(1) {
        cout << "go straight" << '\n';
        publishControlMsg(6, 0);
    }

    
    ros::spin();
    
    return 0;
}

