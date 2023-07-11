#include "../include/header.h"



using namespace std;



class Static_Waypoint_Maker{

ObjectArray objects; // object detector로부터 받은 토픽 메세지를 저장하는 객체

Object NearRubberCone; // 가까운 라바콘의 정보를 담는 객체

Object FarRubberCone; // 멀리 있는 라바콘의 정보를 담는 객체

waypoint_maker::Waypoint waypointInfoMsg; //waypoint msg (Waypoint를 발행하기 위한 메세지 타입)




ros::NodeHandle nh; // 해당 노드를 담당하는 핸들러

ros::Subscriber sub_object_info;

ros::Publisher LocalwaypointInfoPub;

    

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

    int mission_flag;




//생성자

Static_Waypoint_Maker(){


std::cout<<"생성자 생성"<<endl;


NearRubberCone.centerX=0;
NearRubberCone.centerY=0;
NearRubberCone.centerZ=0;


FarRubberCone.centerX=0;
FarRubberCone.centerY=0;
FarRubberCone.centerZ=0;

mission_flag=0;






sub_object_info = nh.subscribe("/object_info",1, &Static_Waypoint_Maker::object_info_callback ,this);
LocalwaypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);

visualizeWaypointInfoMsgPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);



}

void object_info_callback(const object_detector::ObjectInfo& msg);
void setObjectInfo(const object_detector::ObjectInfo& msg);
void set_Near_Far_info();
void publish_Local_Path();
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


void Static_Waypoint_Maker::object_info_callback(const object_detector::ObjectInfo& msg){

std::cout<<"메인 콜백 작동"<<endl;



std::cout<<this->mission_flag<<std::endl;


setObjectInfo(msg);
set_Near_Far_info();



DistanceLidarToNearRubberCone=getDistanceLidarToObject(NearRubberCone);
DistanceLidarToFarRubberCone=getDistanceLidarToObject(FarRubberCone);

 
if(DistanceLidarToNearRubberCone>1){

    publish_Local_Path();

}
// if(DistanceLidarToNearRubberCone<1){

// mission_flag =1;


// }
// if(mission_flag=1){

//     publish_Local_Path();
    
// }


}

void Static_Waypoint_Maker::publish_Local_Path(){

waypointInfoMsg.cnt=20;

int cnt=0;

double R = 0.3;


double x_1= this-> NearRubberCone.centerX;
double y_1= this->NearRubberCone.centerY;
double z_1= this->NearRubberCone.centerZ;


double x_2= this->FarRubberCone.centerX;
double y_2= this->FarRubberCone.centerY;
double z_2= this->FarRubberCone.centerZ;



// 첫번째 장애물을 넘지 않은 경우

if(mission_flag==0){

for(int i = 0;i<100;i++){

waypointInfoMsg.x_arr[i]=x_2-1;
waypointInfoMsg.y_arr[i]=y_2;


}

if(DistanceLidarToFarRubberCone<1){

    mission_flag=1;

}


}

// 첫번째 장애물을 넘어선 이후의 로직

else if(mission_flag==1){

    if()

//두번째 라바콘의 왼쪽 경로를 입력해줘야 한다.
//단지, 이때 가까이있는 라바콘이 보이지 않을 경우 멀리 있던 라바콘의 인덱스가 0에 오게 되므로
//이에 대한 대응이 필요하다. 


for(int i = 0;i<100;i++){


waypointInfoMsg.x_arr[i]=x_2-1;
waypointInfoMsg.y_arr[i]=y_2;


}

}

LocalwaypointInfoPub.publish(waypointInfoMsg);


// if(mission_flag=0){
// for(int i = 0;i<100;i++){

// waypointInfoMsg.x_arr[i]=x_2;
// waypointInfoMsg.y_arr[i]=y_2;


// }



// LocalwaypointInfoPub.publish(waypointInfoMsg);
// }



// else if(mission_flag=1){

// for(int i = 0;i<100;i++){

// waypointInfoMsg.x_arr[i]=(x_1)+1;
// waypointInfoMsg.y_arr[i]=(y_1)+1;


// }

// LocalwaypointInfoPub.publish(waypointInfoMsg);
// }


}

void Static_Waypoint_Maker::setObjectInfo(const object_detector::ObjectInfo& msg) {
    /**
     * @brief 
     * object_detector가 발행하는 /object_info 토픽 메시지를 받아
     * 값을 objects에 저장하고 X값 기준 오름차순으로 정렬합니다.
     */

    int count = 0;
    for (int i = 0; i < msg.objectCounts; i++) {
        if ( (this->xMinRubberCone < msg.lengthX[i] && msg.lengthX[i] < this->xMaxRubberCone) &&
             (this->yMinRubberCone < msg.lengthY[i] && msg.lengthY[i] < this->yMaxRubberCone) &&
             (this->zMinRubberCone < msg.lengthZ[i] && msg.lengthZ[i] < this->zMaxRubberCone) ) {
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
    quickSort(this->objects.objectArray, 0, this->objects.size-1, X_CMP);//일정 크기범위 이내의 라바콘들을 거리가 가까운 순서로 정렬한다. 

}
void Static_Waypoint_Maker::set_Near_Far_info(){

    this->NearRubberCone.centerX= this->objects.objectArray[0].centerX;
    this->NearRubberCone.centerY=this->objects.objectArray[0].centerY;
    this->NearRubberCone.centerZ=this->objects.objectArray[0].centerZ;

    this->FarRubberCone.centerX= this->objects.objectArray[1].centerX;
    this->FarRubberCone.centerY=this->objects.objectArray[1].centerY;
    this->FarRubberCone.centerZ=this->objects.objectArray[1].centerZ;


    
    std::cout<<"Near_Rubber_Cone_coordinate 11: "<<this->NearRubberCone.centerX<<","<<this->objects.objectArray[0].centerY<<endl;

    std::cout<<endl<<endl;

    std::cout<<"Near_Rubber_Cone_coordinate : "<<this->objects.objectArray[0].centerX<<","<<this->objects.objectArray[0].centerY<<endl;

    std::cout<<endl<<endl;

    std::cout<<"Far_Rubber_Cone_coordinate : "<<this->objects.objectArray[1].centerX<<","<<this->objects.objectArray[1].centerY<<endl;

    std::cout<<endl<<endl;

    

    //std::cout<<"--------------------------------"<<endl;
}


void cfgCallback(waypoint_maker::waypointMakerConfig &config, Static_Waypoint_Maker* wm) {
    wm->xMinRubberCone = config.xMinRubberCone;
    wm->xMaxRubberCone = config.xMaxRubberCone;
    wm->yMinRubberCone = config.yMinRubberCone;
    wm->yMaxRubberCone = config.yMaxRubberCone;
    wm->zMinRubberCone = config.zMinRubberCone;
    wm->zMaxRubberCone = config.zMaxRubberCone;
}



int main(int argc, char **argv){


ros::init(argc,argv, "waypoint_maker_static_obstacle");

//std::cout<<"노드 생성"<<endl;

Static_Waypoint_Maker waypointMaker;




dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig> server;
dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig>::CallbackType f;
f = boost::bind(&cfgCallback, _1, &waypointMaker);
server.setCallback(f);


 ros::spin();

    return 0;

}