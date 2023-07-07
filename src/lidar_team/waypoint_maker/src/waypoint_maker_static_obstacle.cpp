#include "../include/header.h"



using namespace std;



class Static_Waypoint_Maker{

ObjectArray objects; // object detector로부터 받은 토픽 메세지를 저장하는 객체

Object NearRubberCone; // 가까운 라바콘의 정보를 담는 객체

Object FarRubberCone; // 멀리 있는 라바콘의 정보를 담는 객체

waypoint_maker::Waypoint waypointInfoMsg; //waypoint msg (Waypoint를 발행하기 위한 메세지 타입)




  public:

    double xMinRubberCone;
    double xMaxRubberCone;
    double yMinRubberCone;
    double yMaxRubberCone;
    double zMinRubberCone;
    double zMaxRubberCone;


ros::NodeHandle nh; // 해당 노드를 담당하는 핸들러

ros::Subscriber sub_object_info;




//생성자

Static_Waypoint_Maker(){


std::cout<<"생성자 생성"<<endl;


NearRubberCone.centerX=0;
NearRubberCone.centerY=0;
NearRubberCone.centerZ=0;

FarRubberCone.centerX=0;
FarRubberCone.centerY=0;
FarRubberCone.centerZ=0;




sub_object_info = nh.subscribe("/object_info",1, &Static_Waypoint_Maker::object_info_callback ,this);


}

void object_info_callback(const object_detector::ObjectInfo& msg);
void setObjectInfo(const object_detector::ObjectInfo& msg);
void set_Near_Far_info();


};



void Static_Waypoint_Maker::object_info_callback(const object_detector::ObjectInfo& msg){

std::cout<<"메인 콜백 작동"<<endl;

setObjectInfo(msg);
set_Near_Far_info();


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