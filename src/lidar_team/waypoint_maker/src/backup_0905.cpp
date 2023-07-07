// 라바콘만 갖고오는 필터 만들기
// 
#include "header_morai.h"

#define SWAP(x, y, t) ((t) = (x), (x) = (y), (y) = (t))

#define X_CMP 1
#define Y_CMP 2
#define D_CMP 3

using namespace std;

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

double getDistanceConeToCone(Object firstCone, Object secondCone) {
    double c2c_distance = sqrt( pow(firstCone.centerX - secondCone.centerX, 2) + pow(firstCone.centerY - secondCone.centerY, 2) );
    return c2c_distance;
}

double getDistanceObjectToObject(const Object &obj1, const Object &obj2) {
    return sqrt( pow(obj1.centerX - obj2.centerX, 2) + pow(obj1.centerY - obj2.centerY, 2) );
}

class WaypointMaker {
private:
    double xMinRubberCone = 0.05;
    double xMaxRubberCone = 0.5;
    double yMinRubberCone = 0.05;
    double yMaxRubberCone = 0.5;
    double zMinRubberCone = 0.05;
    double zMaxRubberCone = 0.5;

    int boxMarkerID = 0;
    int leftObjectMarkerID = 10000;
    int rightobjectMarkerID = 20000;
    int waypointMarkerID = 30000;

    ObjectArray objectInfoArray;
    ObjectArray rubberConeInfoArray;
    ObjectArray yPositiveObjectArray;
    ObjectArray yNegativeObjectArray;
    ObjectArray objectBufferInfoArray;
    ObjectArray leftObjectInfoArray;
    ObjectArray rightObjectInfoArray;
    ObjectArray waypointInfoArray;

public:
    ros::Publisher waypointInfoPub;
    ros::Publisher boundingBoxMarkerPub;
    ros::Publisher leftObjectMarkerPub;
    ros::Publisher rightObjectMarkerPub;
    ros::Publisher waypointMarkerPub;

    void getObjectInfo(const object_detector::ObjectInfo& msg);
    void appendVirtualRubberCone();
    void setRubberConeInfo();
    void setBoundingBoxInfo();
    void setLeftRightInfo();
    void setWaypointInfo();
    void resetAttributes();
    
    void rubberConeVisualization();
    void leftObjectVisualization();
    void rightObjectVisualization();
    void waypointVisualization();
};

void WaypointMaker::getObjectInfo(const object_detector::ObjectInfo& msg) {
    this->objectInfoArray.size = msg.objectCounts;
    for (int i = 0; i < this->objectInfoArray.size; i++) {
        this->objectInfoArray.objectArray[i].centerX = msg.centerX[i];
        this->objectInfoArray.objectArray[i].centerY = msg.centerY[i];
        this->objectInfoArray.objectArray[i].centerZ = msg.centerZ[i];

        this->objectInfoArray.objectArray[i].lengthX = msg.lengthX[i];
        this->objectInfoArray.objectArray[i].lengthY = msg.lengthY[i];
        this->objectInfoArray.objectArray[i].lengthZ = msg.lengthZ[i];
    }

    quickSort(this->objectInfoArray.objectArray, 0, this->objectInfoArray.size-1, X_CMP);

    appendVirtualRubberCone();
    setRubberConeInfo();
    setLeftRightInfo();
    setWaypointInfo();

    rubberConeVisualization();
    leftObjectVisualization();
    rightObjectVisualization();
    waypointVisualization();

    resetAttributes();
}

void WaypointMaker::appendVirtualRubberCone() {
    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerX = 0.0;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerY = this->objectInfoArray.objectArray[0].centerY;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerZ = this->objectInfoArray.objectArray[0].centerZ;

    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthX = this->objectInfoArray.objectArray[0].lengthX;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthY = this->objectInfoArray.objectArray[0].lengthY;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthZ = this->objectInfoArray.objectArray[0].lengthZ;

    this->objectInfoArray.size++;

    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerX = 0.0;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerY = this->objectInfoArray.objectArray[0].centerY * -1; 
    this->objectInfoArray.objectArray[this->objectInfoArray.size].centerZ = this->objectInfoArray.objectArray[0].centerZ;

    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthX = this->objectInfoArray.objectArray[0].lengthX;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthY = this->objectInfoArray.objectArray[0].lengthY;
    this->objectInfoArray.objectArray[this->objectInfoArray.size].lengthZ = this->objectInfoArray.objectArray[0].lengthZ;
        
    this->objectInfoArray.size++;
}

void WaypointMaker::setRubberConeInfo() {
    for (int i = 0; i < this->objectInfoArray.size; i++) {
        if ( (this->xMinRubberCone < this->objectInfoArray.objectArray[i].lengthX && this->objectInfoArray.objectArray[i].lengthX < this->xMaxRubberCone) &&
             (this->yMinRubberCone < this->objectInfoArray.objectArray[i].lengthY && this->objectInfoArray.objectArray[i].lengthY < this->yMaxRubberCone) &&
             (this->zMinRubberCone < this->objectInfoArray.objectArray[i].lengthZ && this->objectInfoArray.objectArray[i].lengthZ < this->zMaxRubberCone) ) {
            
            double distance = sqrt(pow(this->objectInfoArray.objectArray[i].centerX, 2) + pow(this->objectInfoArray.objectArray[i].centerY, 2));
            double volume = this->objectInfoArray.objectArray[i].lengthX *this->objectInfoArray.objectArray[i].lengthY * this->objectInfoArray.objectArray[i].lengthZ;

            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].centerX = this->objectInfoArray.objectArray[i].centerX;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].centerY = this->objectInfoArray.objectArray[i].centerY;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].centerZ = this->objectInfoArray.objectArray[i].centerZ;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].lengthX = this->objectInfoArray.objectArray[i].lengthX;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].lengthY = this->objectInfoArray.objectArray[i].lengthY;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].lengthZ = this->objectInfoArray.objectArray[i].lengthZ;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].distance = distance;
            this->rubberConeInfoArray.objectArray[this->rubberConeInfoArray.size].volume = volume;

            this->rubberConeInfoArray.size++;
        }
    }
}

void WaypointMaker::setLeftRightInfo() {
    if (this->rubberConeInfoArray.size > 1) {
        for (int i = 0; i < this->rubberConeInfoArray.size; i++) {
            if (this->rubberConeInfoArray.objectArray[i].centerY >= 0) {
                this->yPositiveObjectArray.objectArray[this->yPositiveObjectArray.size].centerX = this->rubberConeInfoArray.objectArray[i].centerX;
                this->yPositiveObjectArray.objectArray[this->yPositiveObjectArray.size].centerY = this->rubberConeInfoArray.objectArray[i].centerY;
                this->yPositiveObjectArray.objectArray[this->yPositiveObjectArray.size].centerZ = this->rubberConeInfoArray.objectArray[i].centerZ;
                this->yPositiveObjectArray.objectArray[this->yPositiveObjectArray.size].distance = this->rubberConeInfoArray.objectArray[i].distance;

                this->yPositiveObjectArray.size++;
            }
            else if (this->rubberConeInfoArray.objectArray[i].centerY < 0) {
                this->yNegativeObjectArray.objectArray[this->yNegativeObjectArray.size].centerX = this->rubberConeInfoArray.objectArray[i].centerX;
                this->yNegativeObjectArray.objectArray[this->yNegativeObjectArray.size].centerY = this->rubberConeInfoArray.objectArray[i].centerY;
                this->yNegativeObjectArray.objectArray[this->yNegativeObjectArray.size].centerZ = this->rubberConeInfoArray.objectArray[i].centerZ;
                this->yNegativeObjectArray.objectArray[this->yNegativeObjectArray.size].distance = this->rubberConeInfoArray.objectArray[i].distance;

                this->yNegativeObjectArray.size++;
            } 
        }

        if (this->yPositiveObjectArray.size > 0 && this->yNegativeObjectArray.size > 0) {
            // x 기준으로 정렬 (라이다와 가까운 라바콘 부터)     
            quickSort(this->yPositiveObjectArray.objectArray, 0, this->yPositiveObjectArray.size-1, X_CMP);
            quickSort(this->yNegativeObjectArray.objectArray, 0, this->yNegativeObjectArray.size-1, X_CMP);

            // 제일 가까운 라바콘 하나씩만 먼저 좌우측 배열에 삽입
            this->leftObjectInfoArray.objectArray[0] = this->yPositiveObjectArray.objectArray[0];
            this->rightObjectInfoArray.objectArray[0] = this->yNegativeObjectArray.objectArray[0];

            this->leftObjectInfoArray.size++;
            this->rightObjectInfoArray.size++;
            
            // 나머지는 버퍼에 삽입
            for (int i = 1; i < this->yPositiveObjectArray.size; i++) {
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerX = this->yPositiveObjectArray.objectArray[i].centerX;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerY = this->yPositiveObjectArray.objectArray[i].centerY;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerZ = this->yPositiveObjectArray.objectArray[i].centerZ;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].distance = this->yPositiveObjectArray.objectArray[i].distance;

                this->objectBufferInfoArray.size++;
            }

            for (int i = 1; i < this->yNegativeObjectArray.size; i++) {
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerY = this->yNegativeObjectArray.objectArray[i].centerY;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerX = this->yNegativeObjectArray.objectArray[i].centerX;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].centerZ = this->yNegativeObjectArray.objectArray[i].centerZ;
                this->objectBufferInfoArray.objectArray[this->objectBufferInfoArray.size].distance = this->yNegativeObjectArray.objectArray[i].distance;

                this->objectBufferInfoArray.size++;
            }
           
            // 좌우측 라바콘 하나씩만 제외한 나머지가 포함된 버퍼를 정렬
            quickSort(this->objectBufferInfoArray.objectArray, 0, this->objectBufferInfoArray.size-1, D_CMP);

            // 버퍼를 탐색하며 왼쪽에 들어갈 라바콘과 오른쪽에 들어갈 라바콘 구분 후 배열에 삽입
            for (int i = 0; i < this->objectBufferInfoArray.size; i++) {
                double leftDistanceConeToCone = getDistanceConeToCone(this->objectBufferInfoArray.objectArray[i], this->leftObjectInfoArray.objectArray[this->leftObjectInfoArray.size - 1]);
                double rightDistanceConeToCone = getDistanceConeToCone(this->objectBufferInfoArray.objectArray[i], this->rightObjectInfoArray.objectArray[this->rightObjectInfoArray.size - 1]);
                
                if (leftDistanceConeToCone >= rightDistanceConeToCone) {
                    this->rightObjectInfoArray.objectArray[this->rightObjectInfoArray.size++] = this->objectBufferInfoArray.objectArray[i];

                    quickSort(this->rightObjectInfoArray.objectArray, 0, this->rightObjectInfoArray.size-1, X_CMP);
                }
                else if (leftDistanceConeToCone < rightDistanceConeToCone) {
                    this->leftObjectInfoArray.objectArray[this->leftObjectInfoArray.size++] = this->objectBufferInfoArray.objectArray[i];

                    quickSort(this->leftObjectInfoArray.objectArray, 0, this->leftObjectInfoArray.size-1, X_CMP);
                }
            }
        }
    }
}

void WaypointMaker::setWaypointInfo() {
    if (this->leftObjectInfoArray.size <= 2 || this->rightObjectInfoArray.size <= 2 || abs(this->leftObjectInfoArray.size - this->rightObjectInfoArray.size) >= 3) {
        double waypointStandardX = (this->leftObjectInfoArray.objectArray[0].centerX + this->rightObjectInfoArray.objectArray[0].centerX) / 2;
        double waypointStandardY = (this->leftObjectInfoArray.objectArray[0].centerY + this->rightObjectInfoArray.objectArray[0].centerY) / 2;

        if (this->leftObjectInfoArray.size >= this->rightObjectInfoArray.size) {
            double dx = this->rightObjectInfoArray.objectArray[0].centerX - waypointStandardX;
            double dy = this->rightObjectInfoArray.objectArray[0].centerY - waypointStandardY;

            for (int i = 0; i < this->leftObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = this->leftObjectInfoArray.objectArray[i].centerX + dx - 1 - 0.1 * i;
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerY = this->leftObjectInfoArray.objectArray[i].centerY + dy;
                
                this->waypointInfoArray.size++;
            } 
        }
        else if (this->leftObjectInfoArray.size < this->rightObjectInfoArray.size) {
            double dx = waypointStandardX - this->rightObjectInfoArray.objectArray[0].centerX;
            double dy = waypointStandardY - this->rightObjectInfoArray.objectArray[0].centerY;

            for (int i = 0; i < this->rightObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = this->rightObjectInfoArray.objectArray[i].centerX + dx - 1 - 0.1 * i;
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerY = this->rightObjectInfoArray.objectArray[i].centerY + dy;

                this->waypointInfoArray.size++;
            }
        }
    }
    
    // 평범한 상황
    else {
        if (this->leftObjectInfoArray.size >= this->rightObjectInfoArray.size) {
            for (int i = 0; i < this->rightObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = (this->leftObjectInfoArray.objectArray[i].centerX + this->rightObjectInfoArray.objectArray[i].centerX) / 2;
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerY = (this->leftObjectInfoArray.objectArray[i].centerY + this->rightObjectInfoArray.objectArray[i].centerY) / 2;

                this->waypointInfoArray.size++;
            }
        }
        else if (this->leftObjectInfoArray.size < this->rightObjectInfoArray.size) {
            for (int i = 0; i < this->leftObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = (this->leftObjectInfoArray.objectArray[i].centerX + this->rightObjectInfoArray.objectArray[i].centerX) / 2;
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerY = (this->leftObjectInfoArray.objectArray[i].centerY + this->rightObjectInfoArray.objectArray[i].centerY) / 2;

                this->waypointInfoArray.size++;
            }
        }
    }


    // PUBLISHING
    waypoint_maker::Waypoint WaypointInfoMsg;

    WaypointInfoMsg.cnt = this->waypointInfoArray.size;

    for (int i = 0; i < this->waypointInfoArray.size; i++) {
        WaypointInfoMsg.x_arr[i] = double(this->waypointInfoArray.objectArray[i].centerX);
        WaypointInfoMsg.y_arr[i] = double(this->waypointInfoArray.objectArray[i].centerY);
    }

    this->waypointInfoPub.publish(WaypointInfoMsg);
}

void WaypointMaker::rubberConeVisualization() {
    visualization_msgs::Marker BoundingBox;
    visualization_msgs::MarkerArray BoundingBoxArray;
    
    for (int i = 0; i < this->rubberConeInfoArray.size; i++) {
        BoundingBox.header.frame_id = "velodyne";
        BoundingBox.header.stamp = ros::Time();

        BoundingBox.id = this->boxMarkerID++; 
        BoundingBox.type = visualization_msgs::Marker::CUBE; 
        BoundingBox.action = visualization_msgs::Marker::ADD;

        BoundingBox.pose.position.x = this->rubberConeInfoArray.objectArray[i].centerX; 
        BoundingBox.pose.position.y = this->rubberConeInfoArray.objectArray[i].centerY; 
        BoundingBox.pose.position.z = this->rubberConeInfoArray.objectArray[i].centerZ; 

        BoundingBox.scale.x = this->rubberConeInfoArray.objectArray[i].lengthX;
        BoundingBox.scale.y = this->rubberConeInfoArray.objectArray[i].lengthY;
        BoundingBox.scale.z = this->rubberConeInfoArray.objectArray[i].lengthZ;

        BoundingBox.color.a = 0.5; 
        BoundingBox.color.r = 1.0; 
        BoundingBox.color.g = 1.0;
        BoundingBox.color.b = 1.0;

        BoundingBox.lifetime = ros::Duration(0.1); 
        BoundingBoxArray.markers.emplace_back(BoundingBox);
    }
    this->boundingBoxMarkerPub.publish(BoundingBoxArray);
}

void WaypointMaker::leftObjectVisualization() {
    visualization_msgs::Marker LeftObject;
    visualization_msgs::MarkerArray LeftObjectArray;

    for (int i = 0; i < this->leftObjectInfoArray.size; i++) {
        LeftObject.header.frame_id = "velodyne";
        LeftObject.header.stamp = ros::Time();
      
        LeftObject.id = this->leftObjectMarkerID++; 
        LeftObject.type = visualization_msgs::Marker::CYLINDER; 
        LeftObject.action = visualization_msgs::Marker::ADD;

        LeftObject.pose.position.x = this->leftObjectInfoArray.objectArray[i].centerX;
        LeftObject.pose.position.y = this->leftObjectInfoArray.objectArray[i].centerY;
        LeftObject.pose.position.z = this->leftObjectInfoArray.objectArray[i].centerZ;

        LeftObject.scale.x = 0.5;
        LeftObject.scale.y = 0.5;
        LeftObject.scale.z = 0.8;

        LeftObject.color.a = 0.5; 
        LeftObject.color.r = 1.0; 
        LeftObject.color.g = 1.0;
        LeftObject.color.b = 0.0;

        LeftObject.lifetime = ros::Duration(0.1);
        LeftObjectArray.markers.emplace_back(LeftObject);
    }
    this->leftObjectMarkerPub.publish(LeftObjectArray);
}

void WaypointMaker::rightObjectVisualization() {
    visualization_msgs::Marker RightObject;
    visualization_msgs::MarkerArray RightObjectArray;

    for (int i = 0; i < this->rightObjectInfoArray.size; i++) {
        RightObject.header.frame_id = "velodyne";
        RightObject.header.stamp = ros::Time();
      
        RightObject.id = this->rightobjectMarkerID++; 
        RightObject.type = visualization_msgs::Marker::CYLINDER; 
        RightObject.action = visualization_msgs::Marker::ADD;

        RightObject.pose.position.x = this->rightObjectInfoArray.objectArray[i].centerX;
        RightObject.pose.position.y = this->rightObjectInfoArray.objectArray[i].centerY;
        RightObject.pose.position.z = this->rightObjectInfoArray.objectArray[i].centerZ;

        RightObject.scale.x = 0.5;
        RightObject.scale.y = 0.5;
        RightObject.scale.z = 0.8;

        RightObject.color.a = 0.5; 
        RightObject.color.r = 0.0; 
        RightObject.color.g = 0.0;
        RightObject.color.b = 1.0;

        RightObject.lifetime = ros::Duration(0.1);
        RightObjectArray.markers.emplace_back(RightObject);
    }
    this->rightObjectMarkerPub.publish(RightObjectArray);
}

void WaypointMaker::waypointVisualization() {
    visualization_msgs::Marker Waypoint;
    visualization_msgs::MarkerArray WaypointArray;

    for (int i = 0; i < this->waypointInfoArray.size; i++) {
        Waypoint.header.frame_id = "velodyne";
        Waypoint.header.stamp = ros::Time();
    
        Waypoint.id = this->waypointMarkerID++;
        Waypoint.type = visualization_msgs::Marker::SPHERE; 
        Waypoint.action = visualization_msgs::Marker::ADD;

        Waypoint.pose.position.x = this->waypointInfoArray.objectArray[i].centerX; 
        Waypoint.pose.position.y = this->waypointInfoArray.objectArray[i].centerY;
        Waypoint.pose.position.z = 0.2;

        Waypoint.scale.x = 0.5;
        Waypoint.scale.y = 0.5;
        Waypoint.scale.z = 0.5;

        Waypoint.color.a = 1.0; 
        Waypoint.color.r = 1.0; 
        Waypoint.color.g = 0.0;
        Waypoint.color.b = 0.0;

        Waypoint.lifetime = ros::Duration(0.1);
        WaypointArray.markers.emplace_back(Waypoint);
    }
    this->waypointMarkerPub.publish(WaypointArray);
}

void WaypointMaker::resetAttributes() {
    this->objectInfoArray.size = 0;
    this->rubberConeInfoArray.size = 0;
    this->yPositiveObjectArray.size = 0;
    this->yNegativeObjectArray.size = 0;
    this->objectBufferInfoArray.size = 0;
    this->leftObjectInfoArray.size = 0;
    this->rightObjectInfoArray.size = 0;
    this->waypointInfoArray.size = 0;

    this->boxMarkerID = 0;
    this->leftObjectMarkerID = 10000;
    this->rightobjectMarkerID = 20000;
    this->waypointMarkerID = 30000;
}

class BinaryHoWaypointMaker{
    double xMinRubberCone = 0.05;
    double xMaxRubberCone = 0.55;
    double yMinRubberCone = 0.05;
    double yMaxRubberCone = 0.55;
    double zMinRubberCone = 0.05;
    double zMaxRubberCone = 0.85;
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
    // constructor
    BinaryHoWaypointMaker() {
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

        mainSub = nh.subscribe("/object_info", 1, &BinaryHoWaypointMaker::mainCallback, this);

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
};

void BinaryHoWaypointMaker::mainCallback(const object_detector::ObjectInfo& msg) {
    // 이걸 하겠구나 하면 그 행동을 하는 함수입니다.
    setObjectInfo(msg);
    setLeftRightConeInfo();
    setWaypointInfo();

    visualizeLeftRightCone();
    visualizeWaypointInfoMsg();
    visualizePivot();
}

void BinaryHoWaypointMaker::setObjectInfo(const object_detector::ObjectInfo& msg) {
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

void BinaryHoWaypointMaker::setLeftRightConeInfo() {
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

void BinaryHoWaypointMaker::setWaypointInfo() {
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

    // count 비교 
    // if (leftCones.size > rightCones.size) {
    //     waypointInfoMsg.cnt = leftCones.size;
    //     for (int i = 0; i < leftCones.size; i++) {
    //         waypointInfoMsg.x_arr[i] = leftCones.cone[i]->centerX - 0.3;
    //         waypointInfoMsg.y_arr[i] = leftCones.cone[i]->centerY - yDelta;
    //     }
    // } else {
    //     waypointInfoMsg.cnt = rightCones.size;
    //     for (int i = 0; i < rightCones.size; i++) {
    //         waypointInfoMsg.x_arr[i] = rightCones.cone[i]->centerX + 0.3;
    //         waypointInfoMsg.y_arr[i] = rightCones.cone[i]->centerY + yDelta;
    //     }
    // }

    waypointInfoPub.publish(waypointInfoMsg);
}

void BinaryHoWaypointMaker::visualizeLeftRightCone() {
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

void BinaryHoWaypointMaker::visualizeWaypointInfoMsg() {
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

void BinaryHoWaypointMaker::visualizePivot() {
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

int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_maker");
    
    BinaryHoWaypointMaker binaryhoMaker;

    // ros::NodeHandle nh;
    // WaypointMaker waypointMaker;

    // ros::Subscriber objectInfoSub = nh.subscribe("/object_info", 1, &WaypointMaker::getObjectInfo, &waypointMaker); 

    // waypointMaker.waypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);
    // waypointMaker.boundingBoxMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/boundingbox_marker", 0.001);
    // waypointMaker.leftObjectMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/left_object_marker", 0.001);
    // waypointMaker.rightObjectMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/right_object_marker", 0.001);
    // waypointMaker.waypointMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);

    

    ros::spin();

    return 0;
}