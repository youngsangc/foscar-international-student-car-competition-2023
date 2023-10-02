/////////////

#include <ros/ros.h>
#include <iostream>
#include <std_msgs/Int32.h>
#include <std_msgs/Float64.h>

ros::Publisher speed_pub; 


double first_time_msec = 0.0;
double previous_time = 0.0;
double previous_encoder_value = 0.0;
double current_encoder_value;
double wheel_diameter = 0.53; // 13 inches in meters //차량 바퀴의 직경
double wheel_circumference = 3.14159265358979323846 * wheel_diameter; // pi times diameter // 바퀴의 둘래길이


double last_non_zero_speed = 0.0;
int zero_speed_counter = 0;

void first_value()
{
  ros::Time previous_time = ros::Time::now();
  first_time_msec = previous_time.sec * 1000.0 + previous_time.nsec / 1e6; // 프로그램을 시작하는 시각을 저장한다. // 밀리 초 단위로
}

void EncoderCallback(const std_msgs::Int32& msg)
{
  // current_encoder_value = 360 - (-1*(msg.data)%101)*(360/100);
  current_encoder_value = msg.data*(360/100) *(2*3.141592)/(360);
  ros::Time current_time = ros::Time::now();
  double current_time_msec = current_time.sec * 1000.0 + current_time.nsec / 1e6; // 프로그램이 작동되는 동안에 100Hz의 주기로 현재 시간을 측정한다. 
  double elapsed_time = (current_time_msec - first_time_msec) * 0.001; //현재 시간에서 프로그램이 시작됐을때의 시점을 뺀값 



  // double delta_distance = (current_encoder_value - previous_encoder_value) * wheel_circumference; 
  double delta_distance = (current_encoder_value - previous_encoder_value) * (wheel_diameter/2); 
  std::cout << "Curent encoder = " << current_encoder_value << std::endl;
  std::cout << "previous encoder = " << previous_encoder_value << std::endl;
  std::cout << "delta distance: " << delta_distance << std::endl;
  std::cout << "차이값" << (current_encoder_value - previous_encoder_value) << std::endl;



  // double delta_time = (elapsed_time - previous_time);
  double delta_time = (current_time_msec - previous_time)*0.001;

  double current_speed = delta_distance / delta_time;

  // previous_time = elapsed_time;
  previous_time = current_time_msec;

  previous_encoder_value = current_encoder_value;

  // std::cout << "first_time (msec): " << first_time_msec << std::endl;
  // std::cout << "current_time (msec): " << current_time_msec << std::endl;
  std::cout << "delta_time (sec): " << delta_time << std::endl;

  if (abs(current_speed) > 0.01) {  // 속도가 거의 0이 아닐 때 (0.01은 임의의 임계값으로, 필요에 따라 조정)
        last_non_zero_speed = current_speed;  // 마지막으로 측정된 0이 아닌 속도 값을 저장
        zero_speed_counter = 0;  // 연속 0 속도 카운터를 초기화
  } 
    
  else {
        zero_speed_counter++;  // 연속 0 속도 카운터 증가
  }

  if (zero_speed_counter < 5) {  // 연속으로 0 속도가 두 번 이상 나오지 않았다면
      current_speed = last_non_zero_speed;  // 마지막으로 측정된 0이 아닌 속도를 사용
  }
  



  if(abs(current_speed) < 10){

    std_msgs::Float64 current_speed_topic;
    current_speed_topic.data = current_speed*3.6;

    speed_pub.publish(current_speed_topic);
  
    std::cout << "Current Speed (m/s): " << current_speed << std::endl;
    std::cout << "Current Speed (km/h): " << current_speed*3.6 << std::endl;

    std::cout<<"==============================================="<<std::endl;
  }

  
  
  // if(current_speed != 0){
  //   std::cout << "Current Speed (m/s): " << current_speed << std::endl;
  //   std::cout << "Current Speed (km/h): " << current_speed*3.6 << std::endl;

  // }
  // else if(abs(current_speed) > 100){
  //   std::cout << "Current Speed (m/s): " << 0 << std::endl;

  // }

  // std::cout << "current_encoder_value : "<<current_encoder_value<<std::endl;

}

int main(int argc, char** argv)
{
  ros::init(argc, argv, "encoder_value");
  ros::NodeHandle nh;
  first_value();

  ros::Subscriber sub = nh.subscribe("/encoder_value", 100, EncoderCallback);

  speed_pub = nh.advertise<std_msgs::Float64>("current_speed", 1000);
  // ros::Rate loop_rate(15);  
  //first_value();
  // ros::spinOnce();

  while (ros::ok())
  {
    // time_value();
    // loop_rate.sleep();
    ros::spinOnce();
  }

  // while (ros::ok())
  // {
  //   time_value();
  //   ros::spinOnce();
  //   loop_rate.sleep();
  // }
}