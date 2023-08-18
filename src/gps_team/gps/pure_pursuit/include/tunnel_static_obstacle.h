#ifndef HEADER_H
#define HEADER_H

#include <iostream> 
#include <string>  
#include <vector>
#include <ctime>
#include <chrono>
#include <time.h>
#include <algorithm>
#include <cmath>
#include <cstdlib>

#include <ros/ros.h>

#include <sensor_msgs/PointCloud2.h>

#include <pcl/io/pcd_io.h>
#include <pcl/common/common.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/filters/crop_box.h>
#include <pcl/kdtree/kdtree.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/common/transforms.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/ModelCoefficients.h>
#include <pcl/features/normal_3d.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/model_types.h>
#include <pcl/visualization/cloud_viewer.h>
#include <pcl/filters/passthrough.h>
#include <pcl/segmentation/progressive_morphological_filter.h>

#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>



#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include <geometry_msgs/Pose.h>
#include <geometry_msgs/PoseArray.h>

// #include <std_msgs/Bool.h>

#include <std_msgs/Int32.h>



#include <lidar_team_morai/Boundingbox.h>
#include <lidar_team_morai/Waypoint.h>
#include <lidar_team_morai/DynamicVelocity.h>
#include <waypoint_maker/Waypoint.h>
#include <object_detector/ObjectInfo.h>

#include <dynamic_reconfigure/server.h>
#include "waypoint_maker/waypointMakerConfig.h"

#include <morai_msgs/CtrlCmd.h>
#include <race/drive_values.h>

#include <pure_pursuit_core.h>
#include <pure_pursuit.h>


//IMU 센서 추가로 인한 메세지 헤더 추가

#include <geometry_msgs/Quaternion.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/MagneticField.h>





#define SWAP(x, y, t) ((t) = (x), (x) = (y), (y) = (t))

#define X_CMP 1
#define Y_CMP 2
#define D_CMP 3

int msf = 0;


int *mission_flag = &msf;




typedef struct Object {
    double centerX;
    double centerY;
    double centerZ;
    double lengthX;
    double lengthY;
    double lengthZ;
    double distance;
    double volume;
}Object;

typedef struct ObjectArray
{
    int size = 0;
    Object objectArray[100];
}ObjectArray;

typedef struct
{
    int size = 0;
    Object* cone[30];
}ConeArray;

int partition(Object list[], int left, int right, int cmp) {
    switch (cmp) {
        case X_CMP: {
            double pivot = list[left].centerX;
            int low = left;
            int high = right + 1;
            Object temp;

            do {
                do {
                    low++;
                } while (list[low].centerX < pivot);
                do {
                    high--;
                } while (list[high].centerX > pivot);

                if (low < high) {
                    SWAP(list[low], list[high], temp);
                }

            } while (low < high);

            SWAP(list[left], list[high], temp);
            
            return high;
            }
        case Y_CMP: {
            double pivot = list[left].centerY;
            int low = left;
            int high = right + 1;
            Object temp;

            do {
                do {
                    low++;
                } while (list[low].centerY < pivot);
                do {
                    high--;
                } while (list[high].centerY > pivot);

                if (low < high) {
                    SWAP(list[low], list[high], temp);
                }

            } while (low < high);

            SWAP(list[left], list[high], temp);

            return high;
            }
        case D_CMP: {
            double pivot = list[left].distance;
            int low = left;
            int high = right + 1;
            Object temp;

            do {
                do {
                    low++;
                } while (list[low].distance < pivot);
                do {
                    high--;
                } while (list[high].distance > pivot);

                if (low < high) {
                    SWAP(list[low], list[high], temp);
                }

            } while (low < high);

            SWAP(list[left], list[high], temp);

            return high;
            }
        default: {
            cout << "SORT PARAMETER ERROR \n";
            return 0;
            }
    }
}

void quickSort(Object array[], int left, int right, int cmp) {
    if (left < right) {
        int p = partition(array, left, right, cmp);
        quickSort(array, left, p - 1, cmp);
        quickSort(array, p + 1, right, cmp);
    }
}

double getDistanceObjectToObject(const Object &obj1, const Object &obj2) {
    return sqrt( pow(obj1.centerX - obj2.centerX, 2) + pow(obj1.centerY - obj2.centerY, 2) );
}

double getDistanceLidarToObject(const Object &obj1){
return sqrt(pow(obj1.centerX,2)+pow(obj1.centerY,2));

}



// semi final cpp파일 전용 라이브러리 추가

class Static_Waypoint_Maker {

private:

    ObjectArray objects; // object detector로부터 받은 토픽 메세지를 저장하는 객체

    Object NearRubberCone; // 가까운 라바콘의 정보를 담는 객체

    Object FarRubberCone; // 멀리 있는 라바콘의 정보를 담는 객체

    waypoint_maker::Waypoint waypointInfoMsg; //waypoint msg (Waypoint를 발행하기 위한 메세지 타입)




    ros::NodeHandle nh; // 해당 노드를 담당하는 핸들러

    ros::Subscriber sub_object_info;

    ros::Subscriber imu_sub; //IMU 값을 받아와서 관련 정보를 노드에 저장하는 역할을 하는 노드

    

    ros::Publisher LocalwaypointInfoPub;

    ros::Publisher motorPub;

    ros::Publisher drive_msg_pub;

    ros::Publisher lane_switch_pub;



    



    double DistanceLidarToNearRubberCone;
    double DistanceLidarToFarRubberCone;
    //waypoint_maker::Waypoint waypointInfoMsg; // waypoint msg ( Waypoint를 발행하기 위한 메시지타입 객체 )

    double x_orientation;
    double y_orientation;
    double z_orientation=0;
    double w_orientation;

    double x_angular_velocity;
    double y_angular_velocity;
    double z_angular_velocity;

    double x_linear_acceleration;
    double y_linear_acceleration;
    double z_linear_acceleration;





    ros::Publisher visualizeWaypointInfoMsgPub; // 이름 그대로를 수행하는 Publisher



public:

    //ROI 정보(근본적으로는 cfg를 바꿔야함 이 변수는 활용하기 위함)
    double ROI_y_max = 4;
    double ROI_y_min = -4;


    //그리드 정보
    double grid_size_y=3;
    double grid_size_x=4;

    double tread=1.6; //erp-42 윤거
    double x_limit=0.5; //이상적으로는 x가 0보다 작아질때 장애물을 넘어선것으로 판단하지만, 그전에 이미 안보일수도 있기 때문.

    double cell_size_x;

    double y_split_cnt = 6;
    double cell_size_y = grid_size_y/y_split_cnt;
    double out_cell_size_y = (ROI_y_max-(grid_size_y/2))/y_split_cnt;
    //그리드 정보 끝


    



    double xMinRubberCone;
    double xMaxRubberCone;
    double yMinRubberCone;
    double yMaxRubberCone;
    double zMinRubberCone;
    double zMaxRubberCone;

    int avoid_flag= 0;

    //int lane_flag = 0;

    double Width_Each_Cone;

    bool avoid_Left_Right;//장애물이 왼쪽 먼저 등장
    bool avoid_Right_Left;// 장애물이 오른쪽 먼저 등장

    int left_cnt = 0;
    int right_cnt = 0;
    int pass_obstacle =0;
    int pass_obstacle_1 =0;


    int count__;

    int cnt;

    double Distance_Near_Far_RubberCone;
    int get_distance_cnt=0;
    int get_distance_flag =0;


    //for imu

    double heading_init;
    double heading;
    int get_heading_cnt =0;
    int get_heading_flag = 0;


    int imu_return_cnt=0;

    //new controll

    double k=1.5;
    double alp=-1.5;
    double exp=2.71;

    double target_angle=0;
    double current_angle=0;





    int sleep_cnt=0;
    

    morai_msgs::CtrlCmd motor_info;
    // motorPub = nh.advertise<morai_msgs::CtrlCmd>("/ctrl_cmd", 0.001);

    race::drive_values drive_info;

    std_msgs::Int32 lane_flag;





    //생성자

    Static_Waypoint_Maker() {


        std::cout << "생성자 생성" << endl;


        NearRubberCone.centerX = 0;
        NearRubberCone.centerY = 0;
        NearRubberCone.centerZ = 0;


        FarRubberCone.centerX = 0;
        FarRubberCone.centerY = 0;
        FarRubberCone.centerZ = 0;

        avoid_flag = 11;// 첫번째 장애물을 회피 했는지에 대한 flag

        Width_Each_Cone = 3;

        int count__ = 0;

        cnt=0;


        sub_object_info = nh.subscribe("/object_info", 1, &Static_Waypoint_Maker::object_info_callback, this);// for imu subscriber
        imu_sub = nh.subscribe("/euler_angles", 1, &Static_Waypoint_Maker::callbackFromIMU, this);

        // sensor_msgs::Imu imu_msg;
        // geometry_msgs::Quaternion quaternion_msg;
        // sensor_msgs::MagneticField magnetic_field_msg;




        LocalwaypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);


        
        visualizeWaypointInfoMsgPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);
        motorPub = nh.advertise<morai_msgs::CtrlCmd>("/ctrl_cmd", 0.001);

        drive_msg_pub = nh.advertise<race::drive_values>("control_value", 1);
        lane_switch_pub = nh.advertise<std_msgs::Int32>("lane_switch", 1); 

        


    }

    void object_info_callback(const object_detector::ObjectInfo& msg);
    void setObjectInfo(const object_detector::ObjectInfo& msg);
    void callbackFromIMU(const geometry_msgs::Vector3& msg);

    void set_Near_Far_info();
    void publish_Local_Path();
    void publish_Local_Path2();
    void publish_Local_Path3();
    void visualizeWaypointInfoMsg();

    ~Static_Waypoint_Maker() {
        // 객체가 소멸될 때 수행할 작업
        std::cout << "Tunnel_Static_Obstacle 소멸" << std::endl;
    }



   
};

//IMU로 부터 받아온 정보를 노드에 저장한다.

void Static_Waypoint_Maker::callbackFromIMU(const geometry_msgs::Vector3& msg){

    x_orientation = msg.x;
    y_orientation = msg.y;
    z_orientation = msg.z;

    

    if(get_heading_flag==0 && avoid_flag==0){

        heading_init = z_orientation;
        if(get_heading_cnt<=1000){

            heading = heading_init;
            get_heading_cnt++;


        }

        else if(get_heading_cnt>=1000 && get_heading_cnt<=2000){

                            
            heading = heading*0.7 + z_orientation*0.3;
            get_heading_cnt++;
           

            if(get_heading_cnt>=2000){

                get_heading_flag=1;
            }



        }


    


    }

    
    

    current_angle = z_orientation - heading;

    // std::cout<<"z_orientation : "<<z_orientation<<std::endl;
    // std::cout<<"Heading : "<<heading<<std::endl;


    // std::cout<<"Current_Heading : "<<current_angle<<std::endl;

    

    
    
    

    if(avoid_flag==2){

        if((current_angle)>0){//차량이 좌측으로 틀어져 있는경우
            drive_info.steering=10;

        }
        else if((current_angle)<0){//차량이 우측으로 틀어져 있는 경우
            drive_info.steering=-10;

        }

        drive_info.throttle = 5;

        drive_msg_pub.publish(drive_info);

        

        if(abs(current_angle)<10){

            imu_return_cnt++;


        }

        if(imu_return_cnt>=100){

            avoid_flag=3;


        }



    }
        


    
}


void Static_Waypoint_Maker::object_info_callback(const object_detector::ObjectInfo& msg) {







    std::cout << "메인 콜백 작동" << endl;

    cout<<"가까운 장애물의 좌표(x,y): "<<msg.centerX[0]<<", "<<msg.centerY[0]<<endl;
    cout<<"먼 장애물의 좌표(x,y): "<<msg.centerX[1]<<", "<<msg.centerY[1]<<endl;


    // cout<<"가까운 장애물의 좌표(x,y): "<<this->objects.objectArray[0].centerX<<", "<<this->objects.objectArray[0].centerY<<endl;
    // cout<<"먼 장애물의 좌표(x,y): "<<this->objects.objectArray[1].centerX<<", "<<this->objects.objectArray[1].centerY<<endl;

 

    
    if(get_heading_flag==0){

        std::cout<<"Fail to get Heading"<<std::endl;
    }
    else if(get_heading_flag==1){

        std::cout<<"Current Heading : "<<current_angle<<std::endl;

        
    }

    std::cout <<"avoid_flag : " <<this->avoid_flag << std::endl;
   




    

    if(msg.centerX[0]==NULL || msg.centerX[0]>=7 && avoid_flag != 3){

        cout<<"Before obstacle//////////////////"<<endl;
    
        if((current_angle)>0){//차량이 좌측으로 틀어져 있는경우
            drive_info.steering=5;

        }
        else if((current_angle)<0){//차량이 우측으로 틀어져 있는 경우
            drive_info.steering=-5;

        }

        drive_info.throttle = 5;

        drive_msg_pub.publish(drive_info);



    }

  
    else{

    setObjectInfo(msg); // 라바콘 정보 받아옴
    set_Near_Far_info(); // 라바콘의 위치정보 저장(왼&오 , 멀리& 가까이)


    std::cout << avoid_Left_Right << " " << avoid_Right_Left << " " << std::endl; // 출력

    

    DistanceLidarToNearRubberCone = getDistanceLidarToObject(NearRubberCone); // 가까운 거리
    DistanceLidarToFarRubberCone = getDistanceLidarToObject(FarRubberCone); // 먼 라바콘 거리

    if(avoid_flag<=3 || avoid_flag == 11){

        publish_Local_Path2();


    }





    
    }

   


}


void Static_Waypoint_Maker::publish_Local_Path2() {

    cnt++; // 라이다로부터 토픽을 받을때 마다 카운트를 증가시킨다. 라이다가 토픽을 계속 보내고 있는지 관찰하기 위한 것.
    cout << "obstacle" << '\n'; // 라이다로 장애물이 인지되고 있음을 출력
    cout<<cnt<<endl;// 라이다로 부터 토픽을 계속 받고있는지 터미널에 출력해서 확인. 계속 토픽을 받고있다면, 숫자가 계속 증가한다.


    // 가까운 라바콘의 좌표
    double x_1 = this->NearRubberCone.centerX;
    double y_1 = this->NearRubberCone.centerY;
    double z_1 = this->NearRubberCone.centerZ;

    // 멀리있는 라바콘의 좌표
    double x_2 = this->FarRubberCone.centerX;
    double y_2 = this->FarRubberCone.centerY;
    double z_2 = this->FarRubberCone.centerZ;

    //차량이 추종해야 할 좌표값을 저장해놓는 변수
    double way_x = 0.0;
    double way_y = 0.0;

    


    //////////////

    //장애물 사이의 거리 측정하는 로직

    // 첫 번째 장애물과 두번째 장애물 사이의 거리
    if(get_distance_flag==0){

        if(x_1<3 && x_1>1&&Distance_Near_Far_RubberCone<10){

            if(y_1>y_2){//get_distance_flag==0 일 때이므로 장애물을 통과하기 전에도 미션 상황을 판단한다.

                left_cnt++;
            }
            else{
                right_cnt++;
            }
     
            //고주파 통과필터를 사용하여 보다 노이즈를 최대한 제거한 정보만 저장한다. 
            Distance_Near_Far_RubberCone = Distance_Near_Far_RubberCone*0.7 + (sqrt(pow(abs(x_1-x_2),2) + pow(abs(y_1-y_2),2)))*0.3; 
            
            
            get_distance_cnt++;
            if(get_distance_cnt>=5){
                get_distance_flag=1;


            }
            
            
        
        }
        std::cout<<"Fail to get  Distance Between Far and Near RubberCone"<<std::endl;
    }
    else if(get_distance_flag==1){
        std::cout<<"Distance Between Far and Near RubberCone : "<< Distance_Near_Far_RubberCone <<std::endl;
    }



    ////////////////////////////////////////
    //장애물 사이의 거리 구하는 로직 끝
        


    // 만약 첫번째 장애물과 두번째 장애물의 라이다로부터 종방향 거리가 모두 일정 거리 이내이면(두 라바콘사이의 거리) 아래의 로직에 맞춰서 미리 두번째 라바콘의 좌표를 가까운 라바콘의 좌표로 저장 시키고,
    // 만약 범위 밖이라면 두번째 라바콘은 일정 범위 안에 들어와 있지만 미지의 라바콘 클러스터가 인지 되고 있는 상황이므로 
    // 이경우에는 업데이트 작업 없이 (x_1,y_1)을 이미 가까운 라바콘으로 인지 하고 있다는 뜻이다. 때문에 아무런 추가 조치 없이 그대로 진행시켜준다. 
    
    
    if (avoid_flag==1 && x_1 < Distance_Near_Far_RubberCone && x_1>x_limit && x_2 < Distance_Near_Far_RubberCone){ 
        x_1 = x_2; //첫번째 장애물의 x좌표값을 두번째 장애물의 x좌표값으로 저장하고, 
        y_1 = y_2; //첫번째 장애물의 y좌표값을 두번째 장애물의 y좌표값으로 저장한다.0.8
    }
    


  
    //////////////

    if(avoid_flag == 11){

        
        


        lane_flag.data=1;

        lane_switch_pub.publish(lane_flag);//lane_net 작동
        std::cout<<"들어갔다."<<std::endl;

        if(x_1<3 && x_1>1){
            //std::cout<<"들어갔다."<<std::endl;



            lane_flag.data=2;

            lane_switch_pub.publish(lane_flag);//lane_net 작동 중지

            avoid_flag = 0;


        }

        std::cout<<"Lane_switch_pub.data : "<<lane_flag.data<<std::endl;



    }




    if(avoid_flag==0){// 첫번째 장애물 통과 전

       

        sleep_cnt++;

        // [1] 첫 번째 장애물 넘었는지 판단    
        if (abs(y_1) > (tread/2) && x_1 < x_limit ) { //만약 첫번째 장애물의 y좌표의 절댓값이 차량의 폭의 절반(라이다의 위치로부터 차량 (횡방향)한쪽 끝까지의 거리)보다 크고
            cout << "flag cout" << '\n'; //라이다와 첫번째 장애물의 종방향 거리가 0.5보다 작다면,(처음에 기준값을 0.1로 했으나 인지하지 못함) 
            pass_obstacle++; //장애물을 넘었다고 판단하고 이에대한 판단 횟수를 증가시킨다.
            if(pass_obstacle >= 1){ // 1회(판단 횟수는 조절가능) 정도 판단하였을 때 첫번째 장애물을 지나쳤다고 결론이 날 때,
                avoid_flag = 1; // flag를 바꾸어주어서 첫번째 장애물을 지났음을 확정한다.
                x_1 = x_2; //이제 두번째 장애물을 가까운 장애물로 인지 시켜야 하기 때문에 두번째 장애물의 좌표를 첫번째 장애물의 좌표로 업데이트해준다.
                y_1 = y_2; 
            }
        }


        //그리드 로직 시작 부분

        // 그리드 안에 있을 경우
        else if(((-1*grid_size_y/2)<=y_1 && y_1 <=(grid_size_y/2)) && (0<x_1 && x_1<=grid_size_x )){////////////////////
            cout << "in the grid" << '\n';
            if(y_1 > 0){
                way_x = x_1;
                way_y = y_1 -3 *cell_size_y;
                left_cnt++;

            }
            else{
                way_x = x_1;
                way_y = y_1 + 3*cell_size_y;
                right_cnt++;
            }
        }



        //라바콘이 그리드 밖으로 벗어났을 때 
        else if(((-1*grid_size_y/2)>y_1 && y_1 >(grid_size_y/2)) && y_1> ROI_y_min && y_1<ROI_y_max) {

            cout << "out of grid" << '\n';

            //왼쪽 그리드를 벗어났을 경우
            if((grid_size_y/2) < y_1 && y_1<((grid_size_y/2)+out_cell_size_y*5)){

                way_y = y_1 - 3*cell_size_y;
                way_x = x_1;
                left_cnt++;

            }

            

            //오른쪽 그리드를 벗어 났을 경우

            else if((-1*grid_size_y/2)>y_1 && y_1>-1*((grid_size_y/2)+out_cell_size_y*5)){


                way_y = y_1 + 3*cell_size_y;
                way_x = x_1;
                right_cnt++;

            }

        }

    
    }


    if (avoid_flag == 1){
        sleep_cnt++;


        cout << "avoid_pass" << '\n';
        if (abs(y_1) > (tread/2) && x_1 < x_limit && sleep_cnt>=50) {
            cout << "flag cout" << '\n';
            pass_obstacle_1++;

            cout<<"pass_CNT _Second : "<<pass_obstacle_1<<endl;
            if(pass_obstacle_1 >= 10){

                std::cout<<"change!!!!!!!!!!!!!!!!!"<<std::endl;
                avoid_flag = 2;

                if(left_cnt > right_cnt){
                    way_y = -1*grid_size_y*2;
                    way_x = 3;
                }
                else if(right_cnt > left_cnt){
                    way_y = grid_size_y*2;
                    way_x = 3;
                }

            }
        }


        // 왼 -> 오
        else if(left_cnt > right_cnt){
            cout << "왼 -> 오" << '\n';

            //그리드 안에 있는 경우
            if(y_1>-1*(grid_size_y/2)){
                way_y = y_1+cell_size_y*3;//그리드의 왼쪽 끝을 추종한다. 
                way_x = x_1; 
            }
            //그리드 밖에 있는 경우
            else if(y_1<-1*(grid_size_y/2)){// /rosout
                way_y = y_1+cell_size_y*3; //다시 그리드안에 들어오도록 한다. way_y = y_1
                way_x = x_1;
            }
        }




        // 오 -> 왼

        
        else if(right_cnt > left_cnt){
            cout << "오 -> 왼" << '\n';

            //그리드 안에 있는 경우
            if(y_1<(grid_size_y/2)){
                
                way_y = y_1-1*cell_size_y*3;
                way_x = x_1;
            }

            //그리드 밖에 있는 경우
            else if(y_1>(grid_size_y/2) ){
                
                way_y = y_1-1*cell_size_y*3;
                way_x = x_1;
            }
        } 

    }
   

    if(avoid_flag==1 && abs(current_angle)>40){



    drive_info.steering =(current_angle/abs(current_angle))*current_angle;


    drive_info.throttle = 5;//원래 5였음.



    drive_msg_pub.publish(drive_info);





    }

    if(avoid_flag==0 || avoid_flag ==1 ||avoid_flag==2 ){



        lane_flag.data=2;

        lane_switch_pub.publish(lane_flag);//lane_net 작동 중지


        //오른쪽 스티어링이 음의값(-), 왼쪽이 양의값 (+)을 가짐.

        //실제 자동차 ERP42 환경에서 제어메세지 전달 
        drive_info.steering =atan2(way_y,way_x)*(-1)*(180/3.14);


        drive_info.throttle = 3;//원래 8였음.



        drive_msg_pub.publish(drive_info);



    }

    else if(avoid_flag==3){

        lane_flag.data=1;

        lane_switch_pub.publish(lane_flag);//lane_net 작동
        

        //lane_net_control
    }



           



    std::cout << "Near_Rubber_Cone_coordinate : " << x_1 << "," << y_1 << endl;

    std::cout << endl << endl;

    std::cout << "Far_Rubber_Cone_coordinate : " << x_2 << "," << y_2 << endl;

    std::cout << endl << endl;



    cout << "steering: " <<   drive_info.steering  << '\n';

  
    cout << "flag: " << avoid_flag << '\n';

    cout<< "left_cnt : "<< left_cnt << "right_cnt : "<<right_cnt<<endl;
    // LocalwaypointInfoPub.publish(waypointInfoMsg);




    //모라이 스티어링 값 확인
    // cout << "steering: " <<   motor_info.steering  << '\n';

    //MORAI 가상환경에서 제어 메세지 전달
    motor_info.steering = atan2(way_y,way_x)*0.3;
    motor_info.velocity = 1;
    motor_info.longlCmdType = 2;
    motorPub.publish(motor_info);
}

void Static_Waypoint_Maker::publish_Local_Path3() {


    // 가까운 라바콘의 좌표
    double x_1 = this->NearRubberCone.centerX;
    double y_1 = this->NearRubberCone.centerY;
    double z_1 = this->NearRubberCone.centerZ;

    // 멀리있는 라바콘의 좌표
    double x_2 = this->FarRubberCone.centerX;
    double y_2 = this->FarRubberCone.centerY;
    double z_2 = this->FarRubberCone.centerZ;

    //차량이 추종해야 할 좌표값을 저장해놓는 변수
    double way_x = 0.0;
    double way_y = 0.0;


    if(get_distance_flag==0){


    //아래 조건문들은 차량이 flag가 1로 바뀌었음에도 라바콘을 정말로 넘었는지 안넘었는지 구별하고, 이에 따라 가까운 라바콘의 정보를 업데이트해주는 로직이다. 

        if(x_1<3 && x_1>1){

            
            //고주파 통과필터를 사용하여 보다 노이즈를 최대한 제거한 정보만 저장한다. 
            Distance_Near_Far_RubberCone = Distance_Near_Far_RubberCone*0.7 + (sqrt(pow(abs(x_1-x_2),2) + pow(abs(y_1-y_2),2)))*0.3; 
            get_distance_cnt++;
            if(get_distance_cnt>=5){
                get_distance_flag=1;


            }
            
            
        Static_Waypoint_Maker Tunnel_Static_Obstacle;
        }
        std::cout<<"Fail to get  Distance Between Far and Near RubberCone"<<std::endl;
    }
    else if(get_distance_flag==1){
        std::cout<<"Distance Between Far and Near RubberCone : "<< Distance_Near_Far_RubberCone <<std::endl;
    }


    if (avoid_flag==1 && x_1 < Distance_Near_Far_RubberCone && x_2 < Distance_Near_Far_RubberCone ){ 
        x_1 = x_2; //첫번째 장애물의 x좌표값을 두번째 장애물의 x좌표값으로 저장하고, 
        y_1 = y_2; //첫번째 장애물의 y좌표값을 두번째 장애물의 y좌표값으로 저장한다.
    }


    if(avoid_flag==0){// 첫번째 장애물 통과 전

        // [1] 첫 번째 장애물 넘었는지 판단    
        if (abs(y_1) > (tread/2) && x_1 < x_limit) { //만약 첫번째 장애물의 y좌표의 절댓값이 차량의 폭의 절반(라이다의 위치로부터 차량 (횡방향)한쪽 끝까지의 거리)보다 크고
            cout << "flag cout" << '\n'; //라이다와 첫번째 장애물의 종방향 거리가 0.5보다 작다면,(처음에 기준값을 0.1로 했으나 인지하지 못함) 
            pass_obstacle++; //장애물을 넘었다고 판단하고 이에대한 판단 횟수를 증가시킨다.
            if(pass_obstacle >= 1){ // 1회(판단 횟수는 조절가능) 정도 판단하였을 때 첫번째 장애물을 지나쳤다고 결론이 날 때,
                avoid_flag = 1; // flag를 바꾸어주어서 첫번째 장애물을 지났음을 확정한다.


                //첫번째 장애물을 통과한 이후의 로직을 작성

                ///end


            }
        }

        //첫번째 장애물 통과하기 전의 로직 작성

        current_angle = z_orientation; //라디안
        target_angle = ((k/alp)+(k/alp)*DistanceLidarToNearRubberCone+k)*pow(exp,DistanceLidarToNearRubberCone);
        






    }

    if (avoid_flag == 1){
            sleep_cnt++;


            cout << "avoid_pass" << '\n';
            if (abs(y_1) > (tread/2) && x_1 < x_limit && sleep_cnt>=50) {
                cout << "flag cout" << '\n';
                pass_obstacle++;
                if(pass_obstacle >= 2){
                    avoid_flag = 2;

                    //두번째 장애물을 통과한 이후의 로직 작성

                    ///end


                }
            }
    }

    


    //제어부분


    //오른쪽 스티어링이 음의값(-), 왼쪽이 양의값 (+)을 가짐.

    //실제 자동차 ERP42 환경에서 제어메세지 전달 
    //drive_info.steering =atan2(way_y,way_x)*(-1)*(180/3.14);



    if(current_angle>target_angle){
        drive_info.steering--;
    }
    else{
        drive_info.steering--;
    }

    drive_info.throttle = 5;//원래 5였음.



    drive_msg_pub.publish(drive_info);

}




void Static_Waypoint_Maker::setObjectInfo(const object_detector::ObjectInfo& msg) {

    // cout<<"장애물 크기의 최솟값"<<this->xMinRubberCone<<endl;
   

//    cout<<"xMaxRubberCone : "<<this->xMaxRubberCone<<endl;
//    cout<<"yMaxRubberCone : "<<this->yMaxRubberCone<<endl;
//    cout<<"zMaxRubberCone : "<<this->zMaxRubberCone<<endl;

    int count = 0;
    for (int i = 0; i < msg.objectCounts; i++) {
        if ((this->xMinRubberCone < msg.lengthX[i] && msg.lengthX[i] < this->xMaxRubberCone) &&
            (this->yMinRubberCone < msg.lengthY[i] && msg.lengthY[i] < this->yMaxRubberCone) &&
            (this->zMinRubberCone < msg.lengthZ[i] && msg.lengthZ[i] < this->zMaxRubberCone)) {

            
            this->objects.objectArray[count].centerX = msg.centerX[i];
            this->objects.objectArray[count].centerY = msg.centerY[i];
            this->objects.objectArray[count].centerZ = msg.centerZ[i];

            this->objects.objectArray[count].lengthX = msg.lengthX[i];
            this->objects.objectArray[count].lengthY = msg.lengthY[i];
            this->objects.objectArray[count].lengthZ = msg.lengthZ[i];
            count++;
        }
    }// 위에서 정의해놓은 라바콘의 크기 범위 내에 들어오는 라바 콘만 다시 저장한다.

    cout<<"가까운 장애물의 좌표(x,y): "<<this->objects.objectArray[0].centerX<<", "<<this->objects.objectArray[0].centerY<<endl;
    cout<<"먼 장애물의 좌표(x,y): "<<this->objects.objectArray[1].centerX<<", "<<this->objects.objectArray[1].centerY<<endl;


    objects.size = count;
    quickSort(this->objects.objectArray, 0, this->objects.size - 1, X_CMP);//일정 크기범위 이내의 라바콘들을 거리가 가까운 순서로 정렬한다.

}
void Static_Waypoint_Maker::set_Near_Far_info() {

    this->NearRubberCone.centerX = this->objects.objectArray[0].centerX;
    this->NearRubberCone.centerY = this->objects.objectArray[0].centerY;
    this->NearRubberCone.centerZ = this->objects.objectArray[0].centerZ;

    this->FarRubberCone.centerX = this->objects.objectArray[1].centerX;
    this->FarRubberCone.centerY = this->objects.objectArray[1].centerY;
    this->FarRubberCone.centerZ = this->objects.objectArray[1].centerZ;

}


void cfgCallback(waypoint_maker::waypointMakerConfig& config, Static_Waypoint_Maker* wm) {
    wm->xMinRubberCone = config.xMinRubberCone;
    wm->xMaxRubberCone = config.xMaxRubberCone;
    wm->yMinRubberCone = config.yMinRubberCone;
    wm->yMaxRubberCone = config.yMaxRubberCone;
    wm->zMinRubberCone = config.zMinRubberCone;
    wm->zMaxRubberCone = config.zMaxRubberCone;


}



///semi final cpp파일 전용 라이브러리 끝

#endif // HEADER_H
