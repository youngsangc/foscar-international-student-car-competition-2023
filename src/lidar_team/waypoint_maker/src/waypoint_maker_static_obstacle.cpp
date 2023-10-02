#include "../include/header.h"
#include <morai_msgs/CtrlCmd.h>
#include <race/drive_values.h>

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

    ros::Publisher drive_msg_pub;



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

    double Distance_Near_Far_RubberCone;
    int get_distance_cnt=0;
    int get_distance_flag =0;


    int sleep_cnt=0;

    morai_msgs::CtrlCmd motor_info;
    // motorPub = nh.advertise<morai_msgs::CtrlCmd>("/ctrl_cmd", 0.001);

    race::drive_values drive_info;



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

        drive_msg_pub = nh.advertise<race::drive_values>("control_value", 1);
        


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

    cnt++; // 라이다로부터 토픽을 받을때 마다 카운트를 증가시킨다. 라이다가 토픽을 계속 보내고 있는지 관찰하기 위한 것.
    cout << "obstacle" << '\n'; // 라이다로 장애물이 인지되고 있음을 출력
    cout<<cnt<<endl;// 라이다로 부터 토픽을 계속 받고있는지 터미널에 출력해서 확인. 계속 토픽을 받고있다면, 숫자가 계속 증가한다.

    //아래 주석 내용은 테스트를 위한것임.
    // motor_info.steering = 10;
    // motor_info.velocity = 20;
    // motor_info.longlCmdType = 2;
    // motorPub.publish(motor_info);


    // for(int i =0;i<100;i++){
    //     waypointInfoMsg.x_arr[i] = 3;
    //     waypointInfoMsg.y_arr[i] = 30;

    // }

    // LocalwaypointInfoPub.publish(waypointInfoMsg);



    //아래의 변수들은 라이다로 부터 토픽을 받을 때마다 업데이트 되는 값들이다.
    //즉, 차량이 멈춰있고, 장애물도 멈춰있는 경우에는 같은 값이 계속 들어올 것이고,
    // 차량 혹은, 장애물이 상대적으로 움직이고 있다면 아래 정의한 변수들의 값이 계속 변할 것이다.

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


    // avoid_flag는 첫번째 장애물을 회피 했는지, 못했는지에 대한 결과를 저장해주는 변수이다. 
    //만약 차량이 첫번째 장애물을 지나쳤을 때, aviod_flag의 값은 1로 바뀌게 된다.

    // avoid_flag가 바뀌는 로직. 즉, 첫번째 장애물을 회피 했는지 안했는지 판단해주는 로직은 아래 [1] 항목 주석으로 설명되어있다.

    // 첫 번째 장애물과 두번째 장애물 사이의 거리
    if(get_distance_flag==0){


    //아래 조건문들은 차량이 flag가 1로 바뀌었음에도 라바콘을 정말로 넘었는지 안넘었는지 구별하고, 이에 따라 가까운 라바콘의 정보를 업데이트해주는 로직이다. 

        if(x_1<3 && x_1>1){
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
        

        


    // 만약 첫번째 장애물과 두번째 장애물의 라이다로부터 종방향 거리가 모두 일정 거리 이내이면(두 라바콘사이의 거리) 아래의 로직에 맞춰서 미리 두번째 라바콘의 좌표를 가까운 라바콘의 좌표로 저장 시키고,
    // 만약 범위 밖이라면 두번째 라바콘은 일정 범위 안에 들어와 있지만 미지의 라바콘 클러스터가 인지 되고 있는 상황이므로 
    // 이경우에는 업데이트 작업 없이 (x_1,y_1)을 이미 가까운 라바콘으로 인지 하고 있다는 뜻이다. 때문에 아무런 추가 조치 없이 그대로 진행시켜준다. 
    if (avoid_flag==1 && x_1 < Distance_Near_Far_RubberCone && x_2 < Distance_Near_Far_RubberCone ){ 
        x_1 = x_2; //첫번째 장애물의 x좌표값을 두번째 장애물의 x좌표값으로 저장하고, 
        y_1 = y_2; //첫번째 장애물의 y좌표값을 두번째 장애물의 y좌표값으로 저장한다.
    }


    if(avoid_flag==0){// 첫번째 장애물 통과 전

        // [1] 첫 번째 장애물 넘었는지 판단    
        if (abs(y_1) > 0.8 && x_1 < 0.5) { //만약 첫번째 장애물의 y좌표의 절댓값이 차량의 폭의 절반(라이다의 위치로부터 차량 (횡방향)한쪽 끝까지의 거리)보다 크고
            cout << "flag cout" << '\n'; //라이다와 첫번째 장애물의 종방향 거리가 0.5보다 작다면,(처음에 기준값을 0.1로 했으나 인지하지 못함) 
            pass_obstacle++; //장애물을 넘었다고 판단하고 이에대한 판단 횟수를 증가시킨다.
            if(pass_obstacle >= 1){ // 1회(판단 횟수는 조절가능) 정도 판단하였을 때 첫번째 장애물을 지나쳤다고 결론이 날 때,
                avoid_flag = 1; // flag를 바꾸어주어서 첫번째 장애물을 지났음을 확정한다.
                x_1 = x_2; //이제 두번째 장애물을 가까운 장애물로 인지 시켜야 하기 때문에 두번째 장애물의 좌표를 첫번째 장애물의 좌표로 업데이트해준다.
                y_1 = y_2; 
            }
        }

        //하지만 위에서 장애물을 지나쳤는지, 안지나쳤는지 판단하는 로직에서 예외 상황이 발생 할 수있다. 
        // if (abs(y_1) > 0.8 && x_1 < 0.1) 이 조건을 만족 시킨다고 했을때, 
        // 두 가지의 경우의 수가 존재하게 된다.
        // 첫 번째 경우의 수 :  if (abs(y_1) > 0.8 && x_1 < 0.1) 조건을 만족 시키면서, 라이다는 아직 첫번째 장애물과 두번째 장애물을 둘다 인지하고 있을때
        // 두 번째 경우의 수 :  if (abs(y_1) > 0.8 && x_1 < 0.1) 조건을 만족 시키면서, 라이다가 바라보는 ROI가 이미 첫번째 장애물을 지나쳐서 두번째 장애물을 가까운 라바콘으로 인지하고 있는 경우.

        // 첫번째 경우에서는 두번째 장애물을 미리 가까운 라바콘으로 인지 시켰기 때문에 문제가 없다. (두번째 장애물을 회피할 때 가까운 라바콘의 좌표를 기준으로 회피하면 된다.)
        // 두번째 경우에서는 두번째 장애물을 이미 가까운 라바콘으로 인지하고 있기 때문에 멀리있는 미지의 라바콘 클러스터를 두번째 라바콘(멀리있는 라바콘의 좌표: (x_2,y_2))로 인지하고 있기 때문에 
        // 아래의 과정에서 미지의 라바콘의 좌표를 가까운 라바콘의 좌표로 저장한다는 오류가 발생하게 된다.(flag가 1로 바뀌면 가까운 라바콘의 좌표값을 기준으로 회피하기 때문)

            // if(pass_obstacle >= 1){ 
            //     avoid_flag = 1; 
            //     x_1 = x_2; 
            //     y_1 = y_2; 
            // }



        // y간격 0.75, 1.5, 2.25, 3
        
        // 그리드 정보 : -1.5<y<1.5 && 0<x<6 
        // 그리드 안에 있을 경우
        else if((-1.5<=y_1 && y_1 <=1.5) && (0<x_1 && x_1<=6 )){
            cout << "in the grid" << '\n';
            if(y_1>0.75){//그리드의 경계 부근에 있으므로 스티어링을 조금만 변화시키자.
                way_x = x_1;
                way_y = y_1 - 0.75*3;//3칸 변화에서 2칸 변화로 수정
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
                way_y = y_1 + 0.75*3;//그리드의 경계 부근에 있으므로 스티어링을 조금만 변화시키자.
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
        sleep_cnt++;


        cout << "avoid_pass" << '\n';
        if (abs(y_1) > 0.8 && x_1 < 0.5 && sleep_cnt>=50) {
            cout << "flag cout" << '\n';
            pass_obstacle++;
            if(pass_obstacle >= 2){
                avoid_flag = 2;

                if(left_cnt > right_cnt){
                    way_y = -1.5;
                    way_x = 3;
                }
                else if(right_cnt > left_cnt){
                    way_y = 1.5;
                    way_x = 3;
                }

            }
        }
        // 왼 -> 오
        if(left_cnt > right_cnt){
            cout << "왼 -> 오" << '\n';
            if(y_1>-1.5){
                way_y = 1.5;//그리드의 왼쪽 끝을 추종한다. 
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
                way_y = -1.5;
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



    //MORAI 가상환경에서 제어 메세지 전달
    motor_info.steering = atan2(way_y,way_x)*0.3;
    motor_info.velocity = 1;
    motor_info.longlCmdType = 2;
    motorPub.publish(motor_info);

    //오른쪽 스티어링이 음의값(-), 왼쪽이 양의값 (+)을 가짐.

    //실제 자동차 ERP42 환경에서 제어메세지 전달 
    drive_info.steering =atan2(way_y,way_x)*(-1)*(180/3.14)*0.7;

    // if( drive_info.steering<0){//우리 차량이 오른쪽으로 꺽을때 더 큰값을 줘야함

    //     drive_info.steering =atan2(way_y,way_x)*(-1)*(180/3.14);


    // }
    drive_info.throttle = 5;
    drive_msg_pub.publish(drive_info);
    


    std::cout << "Near_Rubber_Cone_coordinate : " << x_1 << "," << y_1 << endl;

    std::cout << endl << endl;

    std::cout << "Far_Rubber_Cone_coordinate : " << x_2 << "," << y_2 << endl;

    std::cout << endl << endl;

    cout << "steering: " <<   drive_info.steering  << '\n';

    //모라이 스티어링 값 확인
    // cout << "steering: " <<   motor_info.steering  << '\n';
    cout << "flag: " << avoid_flag << '\n';

    cout<< "left_cnt : "<< left_cnt << "right_cnt : "<<right_cnt<<endl;
    // LocalwaypointInfoPub.publish(waypointInfoMsg);


}

void Static_Waypoint_Maker::setObjectInfo(const object_detector::ObjectInfo& msg) {
    /**
     *
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