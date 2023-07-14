#include "../include/header.h"
#include <morai_msgs/CtrlCmd.h>
using namespace std;


class Static_Waypoint_Maker {

private:

    ObjectArray objects; // object detector로부터 받은 토픽 메세지를 저장하는 객체

    Object NearRubberCone; // 가까운 라바콘의 정보를 담는 객체

    Object FarRubberCone; // 멀리 있는 라바콘의 정보를 담는 객체

    waypoint_maker::Waypoint waypointInfoMsg; //waypoint msg (Waypoint를 발행하기 위한 메세지 타입)




    ros::NodeHandle nh; // 해당 노드를 담당하는 핸들러

    ros::Subscriber sub_object_info;

    ros::Publisher LocalwaypointInfoPub;

    ros::Publisher motorPub;



    double DistanceLidarToNearRubberCone;
    double DistanceLidarToFarRubberCone;
    //waypoint_maker::Waypoint waypointInfoMsg; // waypoint msg ( Waypoint를 발행하기 위한 메시지타입 객체 )





    ros::Publisher visualizeWaypointInfoMsgPub; // 이름 그대로를 수행하는 Publisher



public:

    double xMinRubberCone;
    double xMaxRubberCone;
    double yMinRubberCone;
    double yMaxRubberCone;
    double zMinRubberCone;
    double zMaxRubberCone;

    int avoid_flag;

    double Width_Each_Cone;

    bool avoid_Left_Right;//장애물이 왼쪽 먼저 등장
    bool avoid_Right_Left;// 장애물이 오른쪽 먼저 등장

    int left_cnt = 0;
    int right_cnt = 0;
    int pass_obstacle =0;

    int count__;

    int cnt;

    morai_msgs::CtrlCmd motor_info;
    // motorPub = nh.advertise<morai_msgs::CtrlCmd>("/ctrl_cmd", 0.001);



    //생성자

    Static_Waypoint_Maker() {


        std::cout << "생성자 생성" << endl;


        NearRubberCone.centerX = 0;
        NearRubberCone.centerY = 0;
        NearRubberCone.centerZ = 0;


        FarRubberCone.centerX = 0;
        FarRubberCone.centerY = 0;
        FarRubberCone.centerZ = 0;

        avoid_flag = 0;// 첫번째 장애물을 회피 했는지에 대한 flag

        Width_Each_Cone = 3;

        int count__ = 0;

        cnt=0;


        sub_object_info = nh.subscribe("/object_info", 1, &Static_Waypoint_Maker::object_info_callback, this);
        LocalwaypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);

        visualizeWaypointInfoMsgPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);
        motorPub = nh.advertise<morai_msgs::CtrlCmd>("/ctrl_cmd", 0.001);
        


    }

    void object_info_callback(const object_detector::ObjectInfo& msg);
    void setObjectInfo(const object_detector::ObjectInfo& msg);
    void set_Near_Far_info();
    void publish_Local_Path();
    void publish_Local_Path2();
    void visualizeWaypointInfoMsg();
};


void Static_Waypoint_Maker::visualizeWaypointInfoMsg() {
    visualization_msgs::Marker waypoint;
    visualization_msgs::MarkerArray waypointArray;

    for (int i = 0; i < waypointInfoMsg.cnt; i++) {
        waypoint.header.frame_id = "velodyne";
        waypoint.header.stamp = ros::Time();

        waypoint.id = 200 + i;
        waypoint.type = visualization_msgs::Marker::SPHERE;
        waypoint.action = visualization_msgs::Marker::ADD;

        waypoint.pose.position.x = waypointInfoMsg.x_arr[i];
        waypoint.pose.position.y = waypointInfoMsg.y_arr[i];
        waypoint.pose.position.z = 0.2;

        waypoint.scale.x = 0.5;
        waypoint.scale.y = 0.5;
        waypoint.scale.z = 0.5;

        waypoint.color.a = 1.0;
        waypoint.color.r = 1.0;
        waypoint.color.g = 0.0;
        waypoint.color.b = 0.0;

        waypoint.lifetime = ros::Duration(0.1);
        waypointArray.markers.emplace_back(waypoint);
    }
    visualizeWaypointInfoMsgPub.publish(waypointArray);
}


void Static_Waypoint_Maker::object_info_callback(const object_detector::ObjectInfo& msg) {

    std::cout << "메인 콜백 작동" << endl;



    std::cout << this->avoid_flag << std::endl;


    setObjectInfo(msg); // 라바콘 정보 받아옴
    set_Near_Far_info(); // 라바콘의 위치정보 저장(왼&오 , 멀리& 가까이)


    std::cout << avoid_Left_Right << " " << avoid_Right_Left << " " << std::endl; // 출력

    DistanceLidarToNearRubberCone = getDistanceLidarToObject(NearRubberCone); // 가까운 거리
    DistanceLidarToFarRubberCone = getDistanceLidarToObject(FarRubberCone); // 먼 라바콘 거리


    publish_Local_Path2();


}


void Static_Waypoint_Maker::publish_Local_Path2() {

    cnt++;
    cout << "obstacle" << '\n';
    cout<<cnt<<endl;
    // motor_info.steering = 10;
    // motor_info.velocity = 20;
    // motor_info.longlCmdType = 2;
    // motorPub.publish(motor_info);


    // for(int i =0;i<100;i++){
    //     waypointInfoMsg.x_arr[i] = 3;
    //     waypointInfoMsg.y_arr[i] = 30;

    // }

    // LocalwaypointInfoPub.publish(waypointInfoMsg);




    // 가까운 라바콘의 좌표
    double x_1 = this->NearRubberCone.centerX;
    double y_1 = this->NearRubberCone.centerY;
    double z_1 = this->NearRubberCone.centerZ;


    double x_2 = this->FarRubberCone.centerX;
    double y_2 = this->FarRubberCone.centerY;
    double z_2 = this->FarRubberCone.centerZ;

    double way_x = 0.0;
    double way_y = 0.0;
    
    if (avoid_flag==1 && x_1 < 0.1 ){
        x_1 = x_2;
        y_1 = y_2;
    }
    if(avoid_flag==0){// 첫번째 장애물 통과 전

        // 첫 번째 장애물 넘었는지 판단    
        if (abs(y_1) > 0.8 && x_1 < 0.1) {
            cout << "flag cout" << '\n';
            pass_obstacle++;
            if(pass_obstacle >= 1){
                avoid_flag = 1;
                x_1 = x_2;
                y_1 = y_2;
            }
        }
        // y간격 0.75, 1.5, 2.25, 3
        
        // 그리드 정보 : -1.5<y<1.5 && 0<x<6 
        // 그리드 안에 있을 경우
        else if((-1.5<=y_1 && y_1 <=1.5) && (0<x_1 && x_1<=6 )){
            cout << "in the grid" << '\n';
            if(y_1>0.75){
                way_x = x_1;
                way_y = y_1 - 0.75*3;
                left_cnt++;
            }
            else if(y_1>0){
                way_x = x_1;
                way_y = y_1 -0.75*2;
                left_cnt++;
            }
            else if(y_1 > -0.75){
                way_x = x_1;
                way_y = y_1 + 0.75*2;
                right_cnt++;
            }
            else{
                way_x = x_1;
                way_y = y_1 + 0.75*3;
                right_cnt++;
            }
        }
        //라바콘이 그리드 밖으로 벗어났을 때 
        else {
            cout << "out of grid" << '\n';
            if(y_1 > 1.5){//장애물이 왼쪽먼저 등장한 경우
                way_y = y_1+0.3;
                way_x = x_1;
                left_cnt++;
            }
            else if(y_1 < -1.5){
                way_y = y_1-0.3;
                way_x = x_1;
                right_cnt++;
            }
        }
    
    }
    if (avoid_flag == 1){
        cout << "avoid_pass" << '\n';
        if (abs(y_1) > 0.8 && x_1 < 0) {
            cout << "flag cout" << '\n';
            pass_obstacle++;
            if(pass_obstacle >= 2){
                avoid_flag = 2;
            }
        }
        // 왼 -> 오
        if(left_cnt > right_cnt){
            cout << "왼 -> 오" << '\n';
            if(y_1>-1.5){
                way_y = -1.5;//그리드의 왼쪽 끝을 추종한다. 
                way_x = 3; 
            }
            else if(y_1<-1.5){// /rosout
                way_y = y_1; //다시 그리드안에 들어오도록 한다. 
                way_x = x_1;
            }
        }
        // 오 -> 왼
        else if(right_cnt > left_cnt){
            cout << "오 -> 왼" << '\n';
            if(y_1<1.5){
                way_y = 1.5;
                way_x = 3;
            }
            else{
                way_y = y_1;
                way_x = x_1;
            }
        } 

    }
   

    for(int i =0;i<100;i++){
        waypointInfoMsg.x_arr[i] = way_x;
        waypointInfoMsg.y_arr[i] = way_y;

    }




    motor_info.steering = atan2(way_y,way_x)*0.3;
    motor_info.velocity = 1;
    motor_info.longlCmdType = 2;
    motorPub.publish(motor_info);


    cout << "steering: " <<   motor_info.steering  << '\n';
    cout << "flag: " << avoid_flag << '\n';
    // LocalwaypointInfoPub.publish(waypointInfoMsg);


}

void Static_Waypoint_Maker::setObjectInfo(const object_detector::ObjectInfo& msg) {
    /**
     * @brief
     * object_detector가 발행하는 /object_info 토픽 메시지를 받아
     * 값을 objects에 저장하고 X값 기준 오름차순으로 정렬합니다.
     */

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



    //초기에 어느방향으로 회피를 시작하는 지 구분해야한다.


    if (count__ == 0) {// 한번에 판단하는건 너무 위험하기 때문에 벡터에다가 한 10번 정도 받아서 10번중에 많은 경우로 따라가는 방식으로 코드 수정해야함.

        if (this->NearRubberCone.centerY > this->FarRubberCone.centerY) { //만약 가까이 있는 라바콘이 왼쪽에 놓인 경우(오른쪽으로 먼저 회피)

            avoid_Left_Right = true;
            avoid_Right_Left = false;

        }

        else if (this->NearRubberCone.centerY < this->FarRubberCone.centerY) {// 만약 가까이 있는 라바콘이 오른쪽에 놓인 경우(왼쪽으로 먼저 회피)

            avoid_Left_Right = false;
            avoid_Right_Left = true;

        }

        count__ = 1;


    }

    if (count__ == 1) {


    }





    std::cout << "Near_Rubber_Cone_coordinate 11: " << this->NearRubberCone.centerX << "," << this->objects.objectArray[0].centerY << endl;

    std::cout << endl << endl;

    std::cout << "Near_Rubber_Cone_coordinate : " << this->objects.objectArray[0].centerX << "," << this->objects.objectArray[0].centerY << endl;

    std::cout << endl << endl;

    std::cout << "Far_Rubber_Cone_coordinate : " << this->objects.objectArray[1].centerX << "," << this->objects.objectArray[1].centerY << endl;

    std::cout << endl << endl;



    //std::cout<<"--------------------------------"<<endl;
}


void cfgCallback(waypoint_maker::waypointMakerConfig& config, Static_Waypoint_Maker* wm) {
    wm->xMinRubberCone = config.xMinRubberCone;
    wm->xMaxRubberCone = config.xMaxRubberCone;
    wm->yMinRubberCone = config.yMinRubberCone;
    wm->yMaxRubberCone = config.yMaxRubberCone;
    wm->zMinRubberCone = config.zMinRubberCone;
    wm->zMaxRubberCone = config.zMaxRubberCone;
}



int main(int argc, char** argv) {


    ros::init(argc, argv, "waypoint_maker_static_obstacle");

    //std::cout<<"노드 생성"<<endl;

    Static_Waypoint_Maker waypointMaker;




    dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig> server;
    dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig>::CallbackType f;
    f = boost::bind(&cfgCallback, _1, &waypointMaker);
    server.setCallback(f);


    ros::spin();

    return 0;

}
