#include "header_morai.h"
#include "dbscan_morai.h"

using namespace std;

#define TANGENT 1.0          // tan45도

int minPoints; //10          //Core Point 기준 필요 인접점 최소 개수
double epsilon; //0.3        //Core Point 기준 주변 탐색 반경 

int minClusterSize; //10     //Cluster 최소 사이즈
int maxClusterSize; //10000  //Cluster 최대 사이즈

double xMinROI, xMaxROI, yMinROI, yMaxROI, zMinROI, zMaxROI; // ROI(PassThrough) 범위 지정 변수

double xMinBoundingBox, xMaxBoundingBox, yMinBoundingBox, yMaxBoundingBox, zMinBoundingBox, zMaxBoundingBox; // BoundingBox 크기 범위 지정 변수 

// 0 1 2 3
// x y z distance
bool x_cmp(const vector<float>& v1, const vector<float>& v2) {
    return v1[0] < v2[0];
}

bool y_cmp(const vector<float>& v1, const vector<float>& v2) {
    return v1[1] < v2[1];
}

bool d_cmp(const vector<float>& v1, const vector<float>& v2) {
    return v1[3] < v2[3];
}

float getDistanceC2C(const vector<float>& v1, const vector<float>& v2) {
  float c2c_distance;
  c2c_distance = sqrt( pow(v1[0] - v2[0], 2) + pow(v1[1] - v2[1], 2) );
  return c2c_distance;
}

float getTangentC2C(const vector<float>& v1, const vector<float>& v2) {
  float c2c_tangent;
  c2c_tangent = abs( (v1[1] - v2[1]) / (v1[0] - v2[0]) );
  return c2c_tangent;
}

void dynamicParamCallback(lidar_team_morai::hyper_parameter_moraiConfig &config, int32_t level) {
  xMinROI = config.xMinROI;
  xMaxROI = config.xMaxROI;
  yMinROI = config.yMinROI;
  yMaxROI = config.yMaxROI;
  zMinROI = config.zMinROI;
  zMaxROI = config.zMaxROI;

  minPoints = config.minPoints;
  epsilon = config.epsilon;

  minClusterSize = config.minClusterSize;
  maxClusterSize = config.maxClusterSize;

  xMinBoundingBox = config.xMinBoundingBox;
  xMaxBoundingBox = config.xMaxBoundingBox;
  yMinBoundingBox = config.yMinBoundingBox;
  yMaxBoundingBox = config.yMaxBoundingBox;
  zMinBoundingBox = config.zMinBoundingBox;
  zMaxBoundingBox = config.zMaxBoundingBox;
}

typedef pcl::PointXYZ PointT;

vector<float> obstacle_y_positive;
vector<float> obstacle_y_negative;
vector< vector<float> > obstacle_y_positive_vec;
vector< vector<float> > obstacle_y_negative_vec;
vector< vector<float> > obstacle_buffer_vec;
vector< vector<float> > obstacle_left_vec;
vector< vector<float> > obstacle_right_vec;
vector< vector<float> > waypoint_vec;
vector< vector<float> > previous_waypoint_vec;

ros::Publisher clusterPub; //Cluster Publishser
ros::Publisher boundingBoxMarkerPub; //Bounnding Box Visualization Publisher
ros::Publisher waypointMarkerPub; //Waypoint Visualization Publisher
ros::Publisher boundingBoxPosePub; //Bounding Box Position Publisher
ros::Publisher waypointPosePub; //Waypoint Position Publisher
ros::Publisher leftConesMarkerPub; //left Box Publisher
ros::Publisher rightConesMarkerPub; //right Box Publisher
ros::Publisher cropboxPub; //Cropbox PublishserCOMPONENTS
ros::Publisher dynamicVelpub;


void cloud_cb(const sensor_msgs::PointCloud2ConstPtr& inputcloud) {
  int cluster_id = 0;
  int box_id = 1000;
  int left_box_id = 2000;
  int right_box_id = 3000;
  int waypoint_id = 4000;
  double velocity = 15;
  double minX = 99;
  lidar_team_morai::DynamicVelocity velMsg;

  //ROS message 변환
  //PointXYZI가 아닌 PointXYZ로 선언하는 이유 -> 각각의 Cluster를 다른 색으로 표현해주기 위해서. Clustering 이후 각각 구별되는 intensity value를 넣어줄 예정.
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
  pcl::fromROSMsg(*inputcloud, *cloud);

  //Visualizing에 필요한 Marker 선언
  visualization_msgs::MarkerArray BoxArray;
  visualization_msgs::Marker Box;

  visualization_msgs::MarkerArray WaypointArray;
  visualization_msgs::Marker Waypoint;

  visualization_msgs::MarkerArray LeftBoxArray;
  visualization_msgs::Marker LeftBox;

  visualization_msgs::MarkerArray RightBoxArray;
  visualization_msgs::Marker RightBox;

  //Boundingbox & Waypoitn Position Messsage 
  lidar_team_morai::Boundingbox BoxPosition;
  lidar_team_morai::Waypoint WaypointPosition;

  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_xf(new pcl::PointCloud<pcl::PointXYZ>);
  pcl::PassThrough<pcl::PointXYZ> xfilter;
  xfilter.setInputCloud(cloud);
  xfilter.setFilterFieldName("x");
  xfilter.setFilterLimits(xMinROI, xMaxROI); 
  xfilter.setFilterLimitsNegative(false);
  xfilter.filter(*cloud_xf);

  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_xyf(new pcl::PointCloud<pcl::PointXYZ>);
  pcl::PassThrough<pcl::PointXYZ> yfilter;
  yfilter.setInputCloud(cloud_xf);
  yfilter.setFilterFieldName("y");
  yfilter.setFilterLimits(yMinROI, yMaxROI);
  yfilter.setFilterLimitsNegative(false);
  yfilter.filter(*cloud_xyf);

  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_xyzf(new pcl::PointCloud<pcl::PointXYZ>);
  pcl::PassThrough<pcl::PointXYZ> zfilter;
  zfilter.setInputCloud(cloud_xyf);
  zfilter.setFilterFieldName("z");
  zfilter.setFilterLimits(zMinROI, zMaxROI); // -0.62, 0.0
  zfilter.setFilterLimitsNegative(false);
  zfilter.filter(*cloud_xyzf);

  //KD-Tree
  pcl::search::KdTree<pcl::PointXYZ>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZ>);
  
  if (cloud_xyzf->size() != 0)  {
    tree->setInputCloud(cloud_xyzf);
  }

  //Segmentation
  vector<pcl::PointIndices> cluster_indices;
  
  //DBSCAN with Kdtree for accelerating
  DBSCANKdtreeCluster<pcl::PointXYZ> dc;
  dc.setCorePointMinPts(minPoints);   //Set minimum number of neighbor points
  dc.setClusterTolerance(epsilon); //Set Epsilon 
  dc.setMinClusterSize(minClusterSize);
  dc.setMaxClusterSize(maxClusterSize);
  dc.setSearchMethod(tree);
  dc.setInputCloud(cloud_xyzf);
  dc.extract(cluster_indices);

  pcl::PointCloud<pcl::PointXYZI> totalcloud_clustered;

  //각 Cluster 접근
  for (vector<pcl::PointIndices>::const_iterator it = cluster_indices.begin(); it != cluster_indices.end(); it++, cluster_id++) {
    pcl::PointCloud<pcl::PointXYZI> eachcloud_clustered;
    float cluster_counts = cluster_indices.size();

    //각 Cluster내 각 Point 접근
    for(vector<int>::const_iterator pit = it->indices.begin(); pit != it->indices.end(); ++pit) {
        pcl::PointXYZI tmp;
        tmp.x = cloud_xyzf->points[*pit].x;
        tmp.y = cloud_xyzf->points[*pit].y;
        tmp.z = cloud_xyzf->points[*pit].z;
        tmp.intensity = cluster_id;
        eachcloud_clustered.push_back(tmp);
        totalcloud_clustered.push_back(tmp);
    }

    //minPoint와 maxPoint 받아오기
    pcl::PointXYZI minPoint, maxPoint;
    pcl::getMinMax3D(eachcloud_clustered, minPoint, maxPoint);

    float x_len = abs(maxPoint.x - minPoint.x);   //직육면체 x 모서리 크기
    float y_len = abs(maxPoint.y - minPoint.y);   //직육면체 y 모서리 크기
    float z_len = abs(maxPoint.z - minPoint.z);   //직육면체 z 모서리 크기 
    float volume = x_len * y_len * z_len;         //직육면체 부피

    float center_x = (minPoint.x + maxPoint.x)/2; //직육면체 중심 x 좌표
    float center_y = (minPoint.y + maxPoint.y)/2; //직육면체 중심 y 좌표
    float center_z = (minPoint.z + maxPoint.z)/2; //직육면체 중심 z 좌표 

    float distance = sqrt(center_x * center_x + center_y * center_y); //장애물 <-> 차량 거리

    if (-1.0 < center_y && center_y < 1.0 && minX > center_x) {
      minX = center_x;
      velocity = log(center_x + exp(1)) * 3.75;
      cout << "after throttle: " << velocity << "\n";
      velocity = (velocity < 7.0) ? 7.0 : velocity;
      velocity = (velocity > 18.0) ? 18.0 : velocity;
    } 
    velMsg.throttle = velocity;
    velMsg.steering = 0;


    if ( (xMinBoundingBox < x_len && x_len < xMaxBoundingBox) && (yMinBoundingBox < y_len && y_len < yMaxBoundingBox) && (zMinBoundingBox < z_len && z_len < zMaxBoundingBox) ) {
      Box.header.frame_id = "velodyne";
      Box.header.stamp = ros::Time();
      Box.ns = cluster_counts; //ns = namespace
      Box.id = box_id; 
      Box.type = visualization_msgs::Marker::CUBE; //직육면체로 표시
      Box.action = visualization_msgs::Marker::ADD;

      Box.pose.position.x = center_x; 
      Box.pose.position.y = center_y;
      Box.pose.position.z = center_z;

      Box.pose.orientation.x = 0.0;
      Box.pose.orientation.y = 0.0;
      Box.pose.orientation.z = 0.0;
      Box.pose.orientation.w = 1.0;

      Box.scale.x = x_len;
      Box.scale.y = y_len;
      Box.scale.z = z_len;

      Box.color.a = 0.5; //직육면체 투명도, a = alpha
      Box.color.r = 1.0; //직육면체 색상 RGB값
      Box.color.g = 1.0;
      Box.color.b = 1.0;

      Box.lifetime = ros::Duration(0.1); //box 지속시간
      BoxArray.markers.emplace_back(Box);

      //Boundingbox Position Message
      BoxPosition.x = Box.pose.position.x;
      BoxPosition.y = Box.pose.position.y;
      BoxPosition.z = Box.pose.position.z;
      BoxPosition.distance = distance;
    } // Bounding Box Array End

    cluster_id++; //intensity 증가
    box_id++;
  }

  if (BoxArray.markers.size() > 1) {
    for (int i = 0; i < BoxArray.markers.size(); i++) {
      if (BoxArray.markers[i].pose.position.y >= 0) {
        vector<float>().swap(obstacle_y_positive);
        obstacle_y_positive.emplace_back(BoxArray.markers[i].pose.position.x);
        obstacle_y_positive.emplace_back(BoxArray.markers[i].pose.position.y);
        obstacle_y_positive.emplace_back(BoxArray.markers[i].pose.position.z);
        obstacle_y_positive.emplace_back(sqrt(BoxArray.markers[i].pose.position.x * BoxArray.markers[i].pose.position.x + BoxArray.markers[i].pose.position.y * BoxArray.markers[i].pose.position.y));
        obstacle_y_positive_vec.emplace_back(obstacle_y_positive);
      }
      else if (BoxArray.markers[i].pose.position.y < 0) {
        vector<float>().swap(obstacle_y_negative);
        obstacle_y_negative.emplace_back(BoxArray.markers[i].pose.position.x);
        obstacle_y_negative.emplace_back(BoxArray.markers[i].pose.position.y);
        obstacle_y_negative.emplace_back(BoxArray.markers[i].pose.position.z);
        obstacle_y_negative.emplace_back(sqrt(BoxArray.markers[i].pose.position.x * BoxArray.markers[i].pose.position.x + BoxArray.markers[i].pose.position.y * BoxArray.markers[i].pose.position.y));
        obstacle_y_negative_vec.emplace_back(obstacle_y_negative);
      }
    } 

    if (obstacle_y_positive_vec.size() > 0 && obstacle_y_negative_vec.size() > 0) {
      // x 기준으로 정렬 (라이다와 가까운 라바콘 부터)      
      sort(obstacle_y_positive_vec.begin(), obstacle_y_positive_vec.end(), x_cmp);
      sort(obstacle_y_negative_vec.begin(), obstacle_y_negative_vec.end(), x_cmp);

      // 제일 가까운 라바콘 하나씩만 먼저 좌우측 배열에 삽입
      obstacle_left_vec.emplace_back(obstacle_y_positive_vec[0]);
      obstacle_right_vec.emplace_back(obstacle_y_negative_vec[0]);


      // 나머지는 버퍼에 삽입
      for (int i = 1; i < obstacle_y_positive_vec.size(); i++ ) {
        obstacle_buffer_vec.emplace_back(obstacle_y_positive_vec[i]);
      }

      for (int i = 1; i < obstacle_y_negative_vec.size(); i++ ) {
        obstacle_buffer_vec.emplace_back(obstacle_y_negative_vec[i]);
      }
      
      // 좌우측 라바콘 하나씩만 제외한 나머지가 포함된 버퍼를 정렬
      sort(obstacle_buffer_vec.begin(), obstacle_buffer_vec.end(), d_cmp);

      // 버퍼를 탐색하며 왼쪽에 들어갈 라바콘과 오른쪽에 들어갈 라바콘 구분 후 배열에 삽입
      for (int i = 0; i < obstacle_buffer_vec.size(); i++) {
        float left_distance_c2c = getDistanceC2C(obstacle_buffer_vec[i], obstacle_left_vec.back());
        float right_distacne_c2c = getDistanceC2C(obstacle_buffer_vec[i], obstacle_right_vec.back());

        if (left_distance_c2c < right_distacne_c2c) {
          obstacle_left_vec.emplace_back(obstacle_buffer_vec[i]);
          sort(obstacle_left_vec.begin(), obstacle_left_vec.end(), d_cmp);
        }
        else {
          obstacle_right_vec.emplace_back(obstacle_buffer_vec[i]);
          sort(obstacle_right_vec.begin(), obstacle_right_vec.end(), d_cmp);
        }
      }

      int left_size = obstacle_left_vec.size();
      int right_size = obstacle_right_vec.size();

      // Waypoint Array 구성 -> 왼쪽, 오른쪽 중 작은 사이즈인 배열의 사이즈를 기준으로 비교
      if ( (obstacle_left_vec.size() == 1) || (obstacle_right_vec.size() == 1) || (abs(left_size - right_size) >= 3) ) {
        vector<float> waypoint_standard; 
        waypoint_standard.emplace_back( (obstacle_left_vec[0][0] + obstacle_right_vec[0][0]) / 2 );
        waypoint_standard.emplace_back( (obstacle_left_vec[0][1] + obstacle_right_vec[0][1]) / 2 );
        waypoint_standard.emplace_back( (obstacle_left_vec[0][2] + obstacle_right_vec[0][2]) / 2 );

        if ( obstacle_left_vec.size() < obstacle_right_vec.size() ) {
          float dx = waypoint_standard[0] - obstacle_right_vec[0][0];
          float dy = waypoint_standard[1] - obstacle_right_vec[0][1];

          for (int i = 0; i < obstacle_right_vec.size(); i++) {
            vector<float> waypoint;
            waypoint.emplace_back( (obstacle_right_vec[i][0]) + dx - 1); 
            waypoint.emplace_back( (obstacle_right_vec[i][1]) + dy ); 
            waypoint.emplace_back( (obstacle_right_vec[i][2]) );

            waypoint_vec.emplace_back(waypoint);
          }
        }
        else {
          float dx = obstacle_right_vec[0][0] - waypoint_standard[0];
          float dy = obstacle_right_vec[0][1] - waypoint_standard[1];

          for (int i = 0; i < obstacle_left_vec.size(); i++) {
            vector<float> waypoint;
            waypoint.emplace_back( (obstacle_left_vec[i][0]) + dx - 1); 
            waypoint.emplace_back( (obstacle_left_vec[i][1]) + dy ); 
            waypoint.emplace_back( (obstacle_left_vec[i][2]) );

            waypoint_vec.emplace_back(waypoint);
          }
        }
      }

      // 평범한 상황
      else {
        if (obstacle_left_vec.size() < obstacle_right_vec.size()) {
          for (int i = 0; i < obstacle_left_vec.size(); i++) {
            vector<float> waypoint;
            waypoint.emplace_back( (obstacle_left_vec[i][0] + obstacle_right_vec[i][0]) / 2 );
            waypoint.emplace_back( (obstacle_left_vec[i][1] + obstacle_right_vec[i][1]) / 2 );
            waypoint.emplace_back( (obstacle_left_vec[i][2] + obstacle_right_vec[i][2]) / 2 );

            waypoint_vec.emplace_back(waypoint);

          }
        }
        else {
          for (int i = 0; i < obstacle_right_vec.size(); i++) {
            vector<float> waypoint;
            waypoint.emplace_back( (obstacle_left_vec[i][0] + obstacle_right_vec[i][0]) / 2 );
            waypoint.emplace_back( (obstacle_left_vec[i][1] + obstacle_right_vec[i][1]) / 2 );
            waypoint.emplace_back( (obstacle_left_vec[i][2] + obstacle_right_vec[i][2]) / 2 );

            waypoint_vec.emplace_back(waypoint);
          }
        }
      }

      previous_waypoint_vec = waypoint_vec;
        
      // Print for Debugging
      // cout << "LEFT: ";
      // for (int i = 0; i < obstacle_left_vec.size(); i++) {
      //   cout << "[" << obstacle_left_vec[i][0] << ", " << obstacle_left_vec[i][1] << "], ";
      // }
      // cout << "\n";

      // cout << "RIGHT: ";
      // for (int i = 0; i < obstacle_right_vec.size(); i++) {
      //   cout << "[" << obstacle_right_vec[i][0] << ", " << obstacle_right_vec[i][1] << "], ";
      // }
      // cout << "\n";

      // cout << "WAYPOINT: ";
      // for (int i = 0; i < waypoint_vec.size(); i++) {
      //   cout << "[" << waypoint_vec[i][0] << ", " << waypoint_vec[i][1] << "], ";
      // }

      // cout << "\n\n";

      // Visualization
      for (int i = 0; i < obstacle_left_vec.size(); i++) {
        LeftBox.header.frame_id = "velodyne";
        LeftBox.header.stamp = ros::Time();
      
        LeftBox.id = left_box_id; 
        LeftBox.type = visualization_msgs::Marker::CYLINDER; //직육면체로 표시
        LeftBox.action = visualization_msgs::Marker::ADD;

        LeftBox.pose.position.x = obstacle_left_vec[i][0]; 
        LeftBox.pose.position.y = obstacle_left_vec[i][1];
        LeftBox.pose.position.z = obstacle_left_vec[i][2];

        LeftBox.scale.x = 0.5;
        LeftBox.scale.y = 0.5;
        LeftBox.scale.z = 0.8;

        LeftBox.color.a = 0.5; //직육면체 투명도, a = alpha
        LeftBox.color.r = 1.0; //직육면체 색상 RGB값
        LeftBox.color.g = 1.0;
        LeftBox.color.b = 0.0;

        LeftBox.lifetime = ros::Duration(0.1); //box 지속시간
        LeftBoxArray.markers.emplace_back(LeftBox);

        left_box_id++;
      }

      for (int i = 0; i < obstacle_right_vec.size(); i++) {
        RightBox.header.frame_id = "velodyne";
        RightBox.header.stamp = ros::Time();
      
        RightBox.id = right_box_id; 
        RightBox.type = visualization_msgs::Marker::CYLINDER; //직육면체로 표시
        RightBox.action = visualization_msgs::Marker::ADD;

        RightBox.pose.position.x = obstacle_right_vec[i][0]; 
        RightBox.pose.position.y = obstacle_right_vec[i][1];
        RightBox.pose.position.z = obstacle_right_vec[i][2];

        RightBox.scale.x = 0.5;
        RightBox.scale.y = 0.5;
        RightBox.scale.z = 0.8;

        RightBox.color.a = 0.5; //직육면체 투명도, a = alpha
        RightBox.color.r = 0.0; //직육면체 색상 RGB값
        RightBox.color.g = 0.0;
        RightBox.color.b = 1.0;

        RightBox.lifetime = ros::Duration(0.1); //box 지속시간
        RightBoxArray.markers.emplace_back(RightBox);

        right_box_id++;
      }
    } //endif (obstacle_y_positive_vec.size() > 0 && obstacle_y_negative_vec.size() > 0)

  }// endif(BoxArray.markers.size() > 1)
  

  else { // BoxArray.markers.size() < 1
    waypoint_vec = previous_waypoint_vec;
  }

  for (int i = 0; i < waypoint_vec.size(); i++) {
    Waypoint.header.frame_id = "velodyne";
    Waypoint.header.stamp = ros::Time();
  
    Waypoint.id = waypoint_id;
    Waypoint.type = visualization_msgs::Marker::SPHERE; //직육면체로 표시
    Waypoint.action = visualization_msgs::Marker::ADD;

    Waypoint.pose.position.x = waypoint_vec[i][0]; 
    Waypoint.pose.position.y = waypoint_vec[i][1];
    Waypoint.pose.position.z = waypoint_vec[i][2];

    Waypoint.scale.x = 0.5;
    Waypoint.scale.y = 0.5;
    Waypoint.scale.z = 0.5;

    Waypoint.color.a = 1.0; //직육면체 투명도, a = alpha
    Waypoint.color.r = 1.0; //직육면체 색상 RGB값
    Waypoint.color.g = 0.0;
    Waypoint.color.b = 0.0;

    Waypoint.lifetime = ros::Duration(0.1); //box 지속시간
    WaypointArray.markers.emplace_back(Waypoint);
    
    WaypointPosition.x_arr[i] = (waypoint_vec[i][0]);
    WaypointPosition.y_arr[i] = (waypoint_vec[i][1]);

    waypoint_id++;
  }

  WaypointPosition.cnt = waypoint_vec.size();

  // 다음 탐색을 위한 배열 초기화
  vector< vector<float> >().swap(obstacle_y_positive_vec);
  vector< vector<float> >().swap(obstacle_y_negative_vec);
  vector< vector<float> >().swap(obstacle_buffer_vec);
  vector< vector<float> >().swap(obstacle_left_vec);
  vector< vector<float> >().swap(obstacle_right_vec);
  vector< vector<float> >().swap(waypoint_vec);

  //Convert To ROS data type
  pcl::PCLPointCloud2 cloud_p;
  pcl::toPCLPointCloud2(totalcloud_clustered, cloud_p);

  sensor_msgs::PointCloud2 cluster;
  pcl_conversions::fromPCL(cloud_p, cluster);
  cluster.header.frame_id = "velodyne";

  pcl::PCLPointCloud2 cloud_cropbox;
  pcl::toPCLPointCloud2(*cloud_xyzf, cloud_cropbox);

  sensor_msgs::PointCloud2 cropbox;
  pcl_conversions::fromPCL(cloud_cropbox, cropbox);
  cropbox.header.frame_id = "velodyne";

  clusterPub.publish(cluster);
  boundingBoxMarkerPub.publish(BoxArray);
  waypointMarkerPub.publish(WaypointArray);
  boundingBoxPosePub.publish(BoxPosition);
  waypointPosePub.publish(WaypointPosition);
  leftConesMarkerPub.publish(LeftBoxArray);
  rightConesMarkerPub.publish(RightBoxArray);
  cropboxPub.publish(cropbox);
  dynamicVelpub.publish(velMsg);
}

int main(int argc, char **argv) {
  ros::init(argc, argv, "obstacle_detector");
  ros::NodeHandle nh;

  dynamic_reconfigure::Server<lidar_team_morai::hyper_parameter_moraiConfig> server;
  dynamic_reconfigure::Server<lidar_team_morai::hyper_parameter_moraiConfig>::CallbackType f;

  f = boost::bind(&dynamicParamCallback, _1, _2);
  server.setCallback(f);

  ros::Subscriber rawDataSub = nh.subscribe("/velodyne_points", 1, cloud_cb);  // velodyne_points 토픽 구독. velodyne_points = 라이다 raw data

  clusterPub = nh.advertise<sensor_msgs::PointCloud2>("/cluster", 0.001);                  
  boundingBoxMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/boundingbox_marker", 0.001); 
  waypointMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/waypoint_marker", 0.001);    
  boundingBoxPosePub = nh.advertise<lidar_team_morai::Boundingbox>("/boundingbox_position", 0.001);    
  waypointPosePub = nh.advertise<lidar_team_morai::Waypoint>("/waypoint_position", 0.001);          
  leftConesMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/leftbox_marker", 0.001);
  rightConesMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/rightbox_marker", 0.001);
  cropboxPub = nh.advertise<sensor_msgs::PointCloud2>("/cropbox", 0.001); 
  dynamicVelpub = nh.advertise<lidar_team_morai::DynamicVelocity>("/dynamic_velocity", 0.001);
  
  ros::spin();
 
  return 0;
}