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
            std::cout << "SORT PARAMETER ERROR \n";
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

class WaypointMaker {
private:
    int xMinRubberCone = 0.05;
    int xMaxRubberCone = 2.0;
    int yMinRubberCone = 0.05;
    int yMaxRubberCone = 2.0;
    int zMinRubberCone = 0.05;
    int zMaxRubberCone = 2.0;

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
    void setObjectInfo(int _objectCounts, double _centerX[], double _centerY[], double _centerZ[], double _lengthX[], double _lengthY[], double _lengthZ[]);
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

    setRubberConeInfo();
    setLeftRightInfo();
    setWaypointInfo();

    rubberConeVisualization();
    leftObjectVisualization();
    rightObjectVisualization();
    waypointVisualization();

    resetAttributes();
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

                    quickSort(this->rightObjectInfoArray.objectArray, 0, this->rightObjectInfoArray.size-1, D_CMP);
                }
                else if (leftDistanceConeToCone < rightDistanceConeToCone) {
                    this->leftObjectInfoArray.objectArray[this->leftObjectInfoArray.size++] = this->objectBufferInfoArray.objectArray[i];

                    quickSort(this->leftObjectInfoArray.objectArray, 0, this->leftObjectInfoArray.size-1, D_CMP);
                }
            }
        }
    }
}

void WaypointMaker::setWaypointInfo() {
    if (this->leftObjectInfoArray.size == 1 || this->rightObjectInfoArray.size == 1 || abs(this->leftObjectInfoArray.size - this->rightObjectInfoArray.size) > 3) {
        double waypointStandardX = (this->leftObjectInfoArray.objectArray[0].centerX + this->rightObjectInfoArray.objectArray[0].centerX) / 2;
        double waypointStandardY = (this->leftObjectInfoArray.objectArray[0].centerY + this->rightObjectInfoArray.objectArray[0].centerY) / 2;

        if (this->leftObjectInfoArray.size >= this->rightObjectInfoArray.size) {
            double dx = this->rightObjectInfoArray.objectArray[0].centerX - waypointStandardX;
            double dy = this->rightObjectInfoArray.objectArray[0].centerY - waypointStandardY;

            for (int i = 0; i < this->leftObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = this->leftObjectInfoArray.objectArray[i].centerX + dx - 1;
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerY = this->leftObjectInfoArray.objectArray[i].centerY + dy;

                this->waypointInfoArray.size++;
                cout << this->leftObjectInfoArray.objectArray[i].centerX << " ";
            } 
            cout << '\n';
        }
        else if (this->leftObjectInfoArray.size < this->rightObjectInfoArray.size) {
            double dx = waypointStandardX - this->rightObjectInfoArray.objectArray[0].centerX;
            double dy = waypointStandardY - this->rightObjectInfoArray.objectArray[0].centerY;

            for (int i = 0; i < this->rightObjectInfoArray.size; i++) {
                this->waypointInfoArray.objectArray[this->waypointInfoArray.size].centerX = this->rightObjectInfoArray.objectArray[i].centerX + dx - 1;
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

                cout << this->leftObjectInfoArray.objectArray[i].centerX << " ";
            }
            cout << '\n';
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

int main(int argc, char **argv) {
    ros::init(argc, argv, "waypoint_maker");
    ros::NodeHandle nh;

    WaypointMaker waypointMaker;

    ros::Subscriber objectInfoSub = nh.subscribe("/object_info", 1, &WaypointMaker::getObjectInfo, &waypointMaker); 

    waypointMaker.waypointInfoPub = nh.advertise<waypoint_maker::Waypoint>("/waypoint_info", 0.001);
    waypointMaker.boundingBoxMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/boundingbox_marker", 0.001);
    waypointMaker.leftObjectMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/left_object_marker", 0.001);
    waypointMaker.rightObjectMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/right_object_marker", 0.001);
    waypointMaker.waypointMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);

    ros::spin();

    return 0;
}