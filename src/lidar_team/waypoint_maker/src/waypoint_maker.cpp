// 라바콘만 갖고오는 필터 만들기
// 
#include "../include/header.h"


class WaypointMaker{
    // attribute
    ObjectArray objects; // subscribe msg data ( object_detector 토픽 구독해서 받는 정보를 저장하는 객체 )

    Object leftPivot; // pivot ( 좌측 cone을 분류 할 때 기준이 되는 pivot 객체 )
    Object rightPivot; // pivot ( 우측 cone을 분류 할 때 기준이 되는 pivot 객체 )
    
    ConeArray leftCones; // cone segmentation ( 좌측 cone의 정보를 담는 객체 )
    ConeArray rightCones; // cone segmentation ( 좌측 cone의 정보를 담는 객체 )
    /* 알아야 하는 중요한 정보 : ConeArray 타입은 위에 구조체로 선언되어 있는데 다음과 같습니다.
    // int size         원소의 수가 총 몇개인지 저장되는 변수
    // Object* cone[30] Object를 가리키는 포인터를 담는 배열 
    // 포인터 배열을 이용하여 연산속도를 효과적으로 줄이게 됩니다.
    */

    waypoint_maker::Waypoint waypointInfoMsg; // waypoint msg ( Waypoint를 발행하기 위한 메시지타입 객체 )

    // ros attribute
    ros::NodeHandle nh; // 객체를 생성만 해서 노드를 실행시키기 위해서 가지는 멤버변수
    ros::Subscriber mainSub; // 이 객체가 중심적으로 Subscribe하고 객체의 제일 중요한 함수를 Callback 하는 기능을 수행해서 이름을 mainSub라고 했습니다.
    ros::Publisher waypointInfoPub; // 이름 그대로를 수행하는 Publisher
    ros::Publisher visualizeConePub; // 이름 그대로를 수행하는 Publisher
    ros::Publisher visualizeWaypointInfoMsgPub; // 이름 그대로를 수행하는 Publisher
    ros::Publisher visualizePivotPub; // 이름 그대로를 수행하는 Publisher
    
    

    public:

    double xMinRubberCone;
    double xMaxRubberCone;
    double yMinRubberCone;
    double yMaxRubberCone;
    double zMinRubberCone;
    double zMaxRubberCone;

    // constructor
    WaypointMaker() {
        /**
         * @brief 
         * 객체가 생성될 때 임의의 피봇 값을 설정하지 않으면 쓰레기 값이 들어가기 때문에 Critical Error가 발생합니다. 생성자로 값을 초기화 시킵니다.
         * ROS Subscriber 설정과 Publisher를 설정합니다
         */
        
        leftPivot.centerX = 0.0;
        leftPivot.centerY = 1.0;
        leftPivot.centerZ = 0.0;
        rightPivot.centerX = 0.0;
        rightPivot.centerY = -1.0;
        rightPivot.centerZ = 0.0;

        mainSub = nh.subscribe("/object_info", 1, &WaypointMaker::mainCallback, this);

        visualizeConePub = nh.advertise<visualization_msgs::MarkerArray>("/cone_marker", 0.001);
        waypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);
        visualizeWaypointInfoMsgPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);
        visualizePivotPub = nh.advertise<visualization_msgs::MarkerArray>("/pivot_marker", 0.001);
    }

    // method
    void mainCallback(const object_detector::ObjectInfo& msg); // 이 객체의 전체 로직을 수행하는 함수입니다.
    void setObjectInfo(const object_detector::ObjectInfo& msg); // object_info 정보를 받아 값을 objects에 저장하고 X값 기준 오름차순으로 정렬합니다.
    void setLeftRightConeInfo(); // 핵심 함수입니다. 자세한건 함수에 적어놨습니다.
    void setWaypointInfo(); // leftCone과 rightCone 정보를 이용하여 Waypoint를 계산하고 토픽을 발행합니다.

    // visualize method
    void visualizeLeftRightCone(); // 이름 그대로를 수행하는 Rviz 시각화 함수
    void visualizeWaypointInfoMsg(); // 이름 그대로를 수행하는 Rviz 시각화 함수
    void visualizePivot(); // 이름 그대로를 수행하는 Rviz 시각화 함수

    // dynamic reconfigure
    // void cfgCallback(waypoint_maker::waypointMakerConfig &config, int32_t level);
};

void WaypointMaker::mainCallback(const object_detector::ObjectInfo& msg) {
    // 이걸 하겠구나 하면 그 행동을 하는 함수입니다.
    setObjectInfo(msg);
    setLeftRightConeInfo();
    setWaypointInfo();

    //1006
    visualizeLeftRightCone();
    visualizeWaypointInfoMsg();
    visualizePivot();
}

void WaypointMaker::setObjectInfo(const object_detector::ObjectInfo& msg) {
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
    }

    objects.size = count;
    quickSort(this->objects.objectArray, 0, this->objects.size-1, X_CMP);
}

void WaypointMaker::setLeftRightConeInfo() {
    /**
     * @brief 
     * objects에 저장되어 있는 Object객체들을 leftCone인지 rightCone인지 분류합니다.
     * : 반복문에서
     * 1. pivot과 cone의 y변화량을 이용하여 1차로 leftCone인지 rightCone인지 분류합니다.
     * 2. 1차에서 분류가 안되었다면(isLeft, isRight 둘다 true 혹은 둘다 false) pivot과 cone의 거리를 비교하여 더 짧은 거리 기준으로 분류합니다.
     * 3. cone이 leftCone으로 분류되었다면 leftPivot을 비교했던 cone으로 옮겨줍니다. rightCone으로 분류되었다면 rightPivot을 옮겨줍니다.
     * : 반복문이 종료되면
     * 1. leftPivot을 leftCone의 0번 인덱스로 rightPivot을 rightCone의 0번 인덱스로 옮겨줍니다.
     * 2. 만약 leftCone 혹은 rightCone의 size가 0이면 pivot을 0번 인덱스로 옮기지 못하기 때문에 옮기지 않습니다.(그냥 이전값 이용)
     */

    Object* cone;
    bool isLeft;
    bool isRight;
    leftCones.size = 0;
    rightCones.size = 0;

    double yDeltaMax = (leftPivot.centerY - rightPivot.centerY) * 0.85;

    for (int i = 0; i < objects.size; i++) {
        isLeft = false;
        isRight = false;
        cone = &(objects.objectArray[i]);

        if (abs(leftPivot.centerY - cone->centerY) < yDeltaMax)
            isLeft = true;
        if (abs(rightPivot.centerY - cone->centerY) < yDeltaMax)
            isRight = true;

        if ((isLeft && isRight) || (!isLeft && !isRight)) {
            // 거리기준 왼오구분
            isLeft = false;
            isRight = false;
            double leftPivotToConeDistance = getDistanceObjectToObject(leftPivot, *cone);
            double rightPivotToConeDistance = getDistanceObjectToObject(rightPivot, *cone);
            if (leftPivotToConeDistance < rightPivotToConeDistance) {
                isLeft = true;
            } else if (leftPivotToConeDistance > rightPivotToConeDistance) {
                isRight = true;
            } else {
                isLeft = true;
                cout << "Distance Same ERROR\n";
            }
        }
        
        if (isLeft) {
            // leftConeArray에 넣고 피봇 변경
            leftCones.cone[leftCones.size++] = cone;
            leftPivot = *cone;
        } else if (isRight) {
            rightCones.cone[rightCones.size++] = cone;
            rightPivot = *cone;
        } else {
            cout << "Critical ERROR CALL\n";
        }
    }

    if (leftCones.size != 0) {
        leftPivot = *leftCones.cone[0];
    }
    if (rightCones.size != 0) {
        rightPivot = *rightCones.cone[0];
    }
}

void WaypointMaker::setWaypointInfo() {
    double yDelta = (leftPivot.centerY - rightPivot.centerY) / 2;
    double xDelta = abs(rightPivot.centerX - leftPivot.centerX) / 2;
    if (leftCones.size > rightCones.size) {
        waypointInfoMsg.cnt = leftCones.size;

        waypointInfoMsg.x_arr[0] = (leftPivot.centerX + rightPivot.centerX) / 2;
        waypointInfoMsg.y_arr[0] = (leftPivot.centerY + rightPivot.centerY) / 2;
        for (int i = 1; i < leftCones.size; i++) {
            if (i < rightCones.size) {
                waypointInfoMsg.x_arr[i] = (leftCones.cone[i]->centerX + rightCones.cone[i]->centerX) / 2;
                waypointInfoMsg.y_arr[i] = (leftCones.cone[i]->centerY + rightCones.cone[i]->centerY) / 2;
            } else {
                if (rightCones.size != 0) {
                    waypointInfoMsg.x_arr[i] = (leftCones.cone[i]->centerX + rightCones.cone[rightCones.size-1]->centerX) / 2;
                    waypointInfoMsg.y_arr[i] = (leftCones.cone[i]->centerY + rightCones.cone[rightCones.size-1]->centerY) / 2;
                } else {
                    waypointInfoMsg.x_arr[i] = (leftCones.cone[i]->centerX + rightPivot.centerX) / 2;
                    waypointInfoMsg.y_arr[i] = (leftCones.cone[i]->centerY + rightPivot.centerY) / 2;
                }
            }
        }
    } else {
        waypointInfoMsg.cnt = rightCones.size;

        waypointInfoMsg.x_arr[0] = (leftPivot.centerX + rightPivot.centerX) / 2;
        waypointInfoMsg.y_arr[0] = (leftPivot.centerY + rightPivot.centerY) / 2;
        for (int i = 1; i < rightCones.size; i++) {
            if (i < leftCones.size) {
                waypointInfoMsg.x_arr[i] = (leftCones.cone[i]->centerX + rightCones.cone[i]->centerX) / 2;
                waypointInfoMsg.y_arr[i] = (leftCones.cone[i]->centerY + rightCones.cone[i]->centerY) / 2;
            } else {
                if ( leftCones.size != 0 ) {
                    waypointInfoMsg.x_arr[i] = (leftCones.cone[leftCones.size-1]->centerX + rightCones.cone[i]->centerX) / 2;
                    waypointInfoMsg.y_arr[i] = (leftCones.cone[leftCones.size-1]->centerY + rightCones.cone[i]->centerY) / 2;
                } else {
                    waypointInfoMsg.x_arr[i] = (leftPivot.centerX + rightCones.cone[i]->centerX) / 2;
                    waypointInfoMsg.y_arr[i] = (leftPivot.centerY + rightCones.cone[i]->centerY) / 2;
                }
            }
        }
    }

    waypointInfoPub.publish(waypointInfoMsg);
}

void WaypointMaker::visualizeLeftRightCone() {
    visualization_msgs::Marker coneObject;
    visualization_msgs::MarkerArray coneObjectArray;

    coneObject.header.frame_id = "velodyne";
    coneObject.header.stamp = ros::Time();
    coneObject.type = visualization_msgs::Marker::CYLINDER; 
    coneObject.action = visualization_msgs::Marker::ADD;

    coneObject.scale.x = 0.5;
    coneObject.scale.y = 0.5;
    coneObject.scale.z = 0.8;

    coneObject.color.a = 0.5;
    coneObject.color.r = 1.0;
    coneObject.color.g = 1.0;
    coneObject.color.b = 0.0;

    coneObject.lifetime = ros::Duration(0.1);

    for (int i = 0; i < leftCones.size; i++) {
        coneObject.id = 100 + i;

        coneObject.pose.position.x = leftCones.cone[i]->centerX;
        coneObject.pose.position.y = leftCones.cone[i]->centerY;
        coneObject.pose.position.z = leftCones.cone[i]->centerZ;

        coneObjectArray.markers.emplace_back(coneObject);
    }

    coneObject.color.a = 0.5; 
    coneObject.color.r = 0.0; 
    coneObject.color.g = 0.0;
    coneObject.color.b = 1.0;

    for (int i = 0; i < rightCones.size; i++) {
        coneObject.id = 200 + i; 

        coneObject.pose.position.x = rightCones.cone[i]->centerX;
        coneObject.pose.position.y = rightCones.cone[i]->centerY;
        coneObject.pose.position.z = rightCones.cone[i]->centerZ;

        coneObjectArray.markers.emplace_back(coneObject);
    }

    visualizeConePub.publish(coneObjectArray);
}

void WaypointMaker::visualizeWaypointInfoMsg() {
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

void WaypointMaker::visualizePivot() {
    visualization_msgs::Marker pivotObject;
    visualization_msgs::MarkerArray pivotObjectArray;

    pivotObject.header.frame_id = "velodyne";
    pivotObject.header.stamp = ros::Time();
    pivotObject.type = visualization_msgs::Marker::CYLINDER; 
    pivotObject.action = visualization_msgs::Marker::ADD;

    pivotObject.scale.x = 0.5;
    pivotObject.scale.y = 0.5;
    pivotObject.scale.z = 0.8;

    pivotObject.color.a = 1.0;
    pivotObject.color.r = 1.0;
    pivotObject.color.g = 1.0;
    pivotObject.color.b = 0.0;

    pivotObject.lifetime = ros::Duration(0.1);

    
    pivotObject.id = 33;

    pivotObject.pose.position.x = leftPivot.centerX;
    pivotObject.pose.position.y = leftPivot.centerY;
    pivotObject.pose.position.z = leftPivot.centerZ;

    pivotObjectArray.markers.emplace_back(pivotObject);
    

    pivotObject.color.a = 1.0; 
    pivotObject.color.r = 0.0; 
    pivotObject.color.g = 0.0;
    pivotObject.color.b = 1.0;

    pivotObject.id = 34; 

    pivotObject.pose.position.x = rightPivot.centerX;
    pivotObject.pose.position.y = rightPivot.centerY;
    pivotObject.pose.position.z = rightPivot.centerZ;

    pivotObjectArray.markers.emplace_back(pivotObject);

    visualizePivotPub.publish(pivotObjectArray);
}

void cfgCallback(waypoint_maker::waypointMakerConfig &config, WaypointMaker* wm) {
    wm->xMinRubberCone = config.xMinRubberCone;
    wm->xMaxRubberCone = config.xMaxRubberCone;
    wm->yMinRubberCone = config.yMinRubberCone;
    wm->yMaxRubberCone = config.yMaxRubberCone;
    wm->zMinRubberCone = config.zMinRubberCone;
    wm->zMaxRubberCone = config.zMaxRubberCone;
}


int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_maker");
    
    WaypointMaker waypointMaker;
    
    dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig> server;
    dynamic_reconfigure::Server<waypoint_maker::waypointMakerConfig>::CallbackType f;
    f = boost::bind(&cfgCallback, _1, &waypointMaker);
    server.setCallback(f);
    
    ros::spin();

    return 0;
}