#include "header.h"
#include "dbscan.h"

using namespace std;

int minPoints; //10          //Core Point 기준 필요 인접점 최소 개수
double epsilon; //0.3        //Core Point 기준 주변 탐색 반경 

int minClusterSize; //10     //Cluster 최소 사이즈
int maxClusterSize; //10000  //Cluster 최대 사이즈

double xMinROI, xMaxROI, yMinROI, yMaxROI, zMinROI, zMaxROI; // ROI(PassThrough) 범위 지정 변수

double xMinBoundingBox, xMaxBoundingBox, yMinBoundingBox, yMaxBoundingBox, zMinBoundingBox, zMaxBoundingBox; // BoundingBox 크기 범위 지정 변수 

typedef pcl::PointXYZ PointT;

vector<float> obstacle;
vector< vector<float> > obstacle_vec;

ros::Publisher staticObsClusterPub; //Cluster Publishser
ros::Publisher staticObsMarkerPub; //Bounnding Box Visualization Publisher
ros::Publisher staticObsPosePub; //Bounding Box Position Publisher
ros::Publisher staticObsCropboxPub; //Cropbox Publishser
ros::Publisher staticObsShortFlagPub;
ros::Publisher staticObsLongFlagPub;

void dynamicParamCallback(lidar_team_erp42::large_st_hyper_parameterConfig &config, int32_t level) {
  xMinROI = config.large_st_xMinROI;
  xMaxROI = config.large_st_xMaxROI;
  yMinROI = config.large_st_yMinROI;
  yMaxROI = config.large_st_yMaxROI;
  zMinROI = config.large_st_zMinROI;
  zMaxROI = config.large_st_zMaxROI;

  minPoints = config.large_st_minPoints;
  epsilon = config.large_st_epsilon;
  minClusterSize = config.large_st_minClusterSize;
  maxClusterSize = config.large_st_maxClusterSize;

  xMinBoundingBox = config.large_st_xMinBoundingBox;
  xMaxBoundingBox = config.large_st_xMaxBoundingBox;
  yMinBoundingBox = config.large_st_yMinBoundingBox;
  yMaxBoundingBox = config.large_st_yMaxBoundingBox;
  zMinBoundingBox = config.large_st_zMinBoundingBox;
  zMaxBoundingBox = config.large_st_zMaxBoundingBox;
}

void cloud_cb(const sensor_msgs::PointCloud2ConstPtr& inputcloud) {
  //ROS message 변환
  //PointXYZI가 아닌 PointXYZ로 선언하는 이유 -> 각각의 Cluster를 다른 색으로 표현해주기 위해서. Clustering 이후 각각 구별되는 intensity value를 넣어줄 예정.
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
  pcl::fromROSMsg(*inputcloud, *cloud);

  //Visualizing에 필요한 Marker 선언
  visualization_msgs::MarkerArray BoxArray;
  visualization_msgs::Marker Box;

  //Boundingbox & Waypoitn Position Messsage 
  lidar_team_erp42::Boundingbox BoxPosition;

  //static Obstacle Detected Message
  std_msgs::Bool staticObsLongDetected;
  std_msgs::Bool staticObsShortDetected;
  staticObsLongDetected.data = false;
  staticObsShortDetected.data = false;

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

  // //Voxel Grid를 이용한 DownSampling
  // pcl::VoxelGrid<pcl::PointXYZ> vg;    // VoxelGrid 선언
  // pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>); //Filtering 된 Data를 담을 PointCloud 선언
  // vg.setInputCloud(cloud);             // Raw Data 입력
  // vg.setLeafSize(0.5f, 0.5f, 0.5f); // 사이즈를 너무 작게 하면 샘플링 에러 발생
  // vg.filter(*cloud);          // Filtering 된 Data를 cloud PointCloud에 삽입

  //KD-Tree
  pcl::search::KdTree<pcl::PointXYZ>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZ>);
  if (cloud_xyzf->size() > 0) {
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
  int cluster_id = 0;

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
        tmp.intensity = cluster_id%8;
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

    if ( (xMinBoundingBox < x_len && x_len < xMaxBoundingBox) && (yMinBoundingBox < y_len && y_len < yMaxBoundingBox) && (zMinBoundingBox < z_len && z_len < zMaxBoundingBox) ) {
      Box.header.frame_id = "velodyne";
      Box.header.stamp = ros::Time();
      Box.ns = cluster_counts; //ns = namespace
      Box.id = cluster_id; 
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
    }

    if (BoxArray.markers.size() > 0) {
      for (int i = 0; i < BoxArray.markers.size(); i++) {
        vector<float>().swap(obstacle);
        obstacle.emplace_back(BoxArray.markers[i].pose.position.x);
        obstacle.emplace_back(BoxArray.markers[i].pose.position.y);
        obstacle.emplace_back(BoxArray.markers[i].pose.position.z);
        obstacle.emplace_back(distance);
        obstacle_vec.emplace_back(obstacle);
      }
      
      sort(obstacle_vec.begin(), obstacle_vec.end());
      //2.5, 5
      if (6 <= obstacle_vec[0][0] && obstacle_vec[0][0] < 10) {
        staticObsLongDetected.data = true;
      }

      else if (obstacle_vec[0][0] < 6) {
        staticObsShortDetected.data = true;
      }
    }

    vector< vector<float> >().swap(obstacle_vec);   

    cluster_id++; //intensity 증가

  }

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

  staticObsClusterPub.publish(cluster);
  staticObsMarkerPub.publish(BoxArray);
  staticObsPosePub.publish(BoxPosition);
  staticObsCropboxPub.publish(cropbox);
  staticObsShortFlagPub.publish(staticObsShortDetected); 
  staticObsLongFlagPub.publish(staticObsLongDetected);
}


int main(int argc, char **argv) {
  ros::init(argc, argv, "large_static_obstacle_detector");
  ros::NodeHandle nh;

  dynamic_reconfigure::Server<lidar_team_erp42::large_st_hyper_parameterConfig> server;
  dynamic_reconfigure::Server<lidar_team_erp42::large_st_hyper_parameterConfig>::CallbackType f;

  f = boost::bind(&dynamicParamCallback, _1, _2);
  server.setCallback(f);

  ros::Subscriber rawDataSub = nh.subscribe("/velodyne_points", 1, cloud_cb);  // velodyne_points 토픽 구독. velodyne_points = 라이다 raw data

  staticObsClusterPub = nh.advertise<sensor_msgs::PointCloud2>("/static_obs_cluster", 0.001);                  
  staticObsMarkerPub = nh.advertise<visualization_msgs::MarkerArray>("/static_obs_marker", 0.001);  
  staticObsPosePub = nh.advertise<lidar_team_erp42::Boundingbox>("/static_obs_position", 0.001);    
  staticObsCropboxPub = nh.advertise<sensor_msgs::PointCloud2>("/static_obs_cropbox", 0.001); 
  staticObsShortFlagPub = nh.advertise<std_msgs::Bool>("/static_obs_flag_short", 0.001); 
  staticObsLongFlagPub = nh.advertise<std_msgs::Bool>("/static_obs_flag_long", 0.001); 

  ros::spin();

  return 0;
}
