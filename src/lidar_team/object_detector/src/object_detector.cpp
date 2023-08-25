// 해결
// 굳이 mainCallback에서 pub을 해야하는가? (roi 변경하기)
// 객체 부피 말고 xy평면에 넓이로 바꾸는것

// TODO 
// cluster id 상수
// 범위로 나누어서 가능성 생각
// cfg 설정

// include ROS parts
#include <ros/ros.h>
#include <dynamic_reconfigure/server.h>
#include "object_detector/objectDetectorConfig.h"
#include <sensor_msgs/PointCloud2.h>
// include PCL parts
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/PCLPointCloud2.h>
#include <pcl/point_types.h>
#include <pcl/filters/passthrough.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/common/common.h>
#include <pcl/search/kdtree.h>
#include "../include/object_detector/dbscan.h"
// include visualization parts
#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>
// include STL parts
#include <vector>
// include MSG
#include <object_detector/ObjectInfo.h>

// pcl point type
typedef pcl::PointXYZ PointT;
// cluster point type
typedef pcl::PointXYZI clusterPointT;

// ROI parameter
double zMin, zMax, xMin, xMax, yMin, yMax;
// DBScan parameter
int minPoints;
double epsilon, minClusterSize, maxClusterSize;
// VoxelGrid parameter
float leafSize;

// publisher
ros::Publisher pubROI;
ros::Publisher pubCluster;
ros::Publisher pubObjectInfo;
ros::Publisher pubCarShape;
ros::Publisher pubObjectShapeArray;

//MSG
object_detector::ObjectInfo objectInfoMsg;

void cfgCallback(object_detector::objectDetectorConfig &config, int32_t level) {
    xMin = config.xMin;
    xMax = config.xMax;
    yMin = config.yMin;
    yMax = config.yMax;
    zMin = config.zMin;
    zMax = config.zMax;

    minPoints = config.minPoints;
    epsilon = config.epsilon;
    minClusterSize = config.minClusterSize;
    maxClusterSize = config.maxClusterSize;

    leafSize  = config.leafSize;
}

pcl::PointCloud<PointT>::Ptr ROI (const sensor_msgs::PointCloud2ConstPtr& input) {
    // ... do data processing
    pcl::PointCloud<PointT>::Ptr cloud(new pcl::PointCloud<PointT>);

    pcl::fromROSMsg(*input, *cloud); // sensor_msgs -> PointCloud 형변환

    pcl::PointCloud<PointT>::Ptr cloud_filtered(new pcl::PointCloud<PointT>);
    // pcl::PointCloud<PointT>::Ptr *retPtr = &cloud_filtered;
    std::cout << "Loaded : " << cloud->width * cloud->height << '\n';

    // 오브젝트 생성 
    // Z축 ROI
    pcl::PassThrough<PointT> filter;
    filter.setInputCloud(cloud);                //입력 
    filter.setFilterFieldName("z");             //적용할 좌표 축 (eg. Z축)
    filter.setFilterLimits(zMin, zMax);          //적용할 값 (최소, 최대 값)
    //filter.setFilterLimitsNegative (true);     //적용할 값 외 
    filter.filter(*cloud_filtered);             //필터 적용 

    // X축 ROI
    filter.setInputCloud(cloud_filtered);
    filter.setFilterFieldName("x");
    filter.setFilterLimits(-2, 8); // x > -2 && x < 8
    filter.filter(*cloud_filtered);

    // Y축 ROI (Advanced filtering)
    pcl::PointCloud<PointT>::Ptr cloud_y_filtered(new pcl::PointCloud<PointT>);
    for (size_t i = 0; i < cloud_filtered->points.size(); i++) {
        PointT point = cloud_filtered->points[i];
        if (std::abs(point.y) > 1.5) {
            cloud_y_filtered->points.push_back(point);
        }
    }


    // // X축 ROI
    // // pcl::PassThrough<PointT> filter;
    // filter.setInputCloud(cloud_filtered);                //입력 
    // filter.setFilterFieldName("x");             //적용할 좌표 축 (eg. X축)
    // filter.setFilterLimits(xMin, xMax);          //적용할 값 (최소, 최대 값)
    // //filter.setFilterLimitsNegative (true);     //적용할 값 외 
    // filter.filter(*cloud_filtered);             //필터 적용 

    // // Y축 ROI
    // // pcl::PassThrough<PointT> filter;
    // filter.setInputCloud(cloud_filtered);                //입력 
    // filter.setFilterFieldName("y");             //적용할 좌표 축 (eg. Y축)
    // filter.setFilterLimits(yMin, yMax);          //적용할 값 (최소, 최대 값)
    // //filter.setFilterLimitsNegative (true);     //적용할 값 외 
    // filter.filter(*cloud_filtered);             //필터 적용 

    // 포인트수 출력
    std::cout << "ROI Filtered :" << cloud_filtered->width * cloud_filtered->height  << '\n'; 

    sensor_msgs::PointCloud2 roi_raw;
    pcl::toROSMsg(*cloud_filtered, roi_raw);
    
    pubROI.publish(roi_raw);

    return cloud_filtered;
}

pcl::PointCloud<PointT>::Ptr voxelGrid(pcl::PointCloud<PointT>::Ptr input) {
    //Voxel Grid를 이용한 DownSampling
    pcl::VoxelGrid<PointT> vg;    // VoxelGrid 선언
    pcl::PointCloud<PointT>::Ptr cloud_filtered(new pcl::PointCloud<PointT>); //Filtering 된 Data를 담을 PointCloud 선언
    vg.setInputCloud(input);             // Raw Data 입력
    vg.setLeafSize(leafSize, leafSize, leafSize); // 사이즈를 너무 작게 하면 샘플링 에러 발생
    vg.filter(*cloud_filtered);          // Filtering 된 Data를 cloud PointCloud에 삽입
    
    std::cout << "After Voxel Filtered :" << cloud_filtered->width * cloud_filtered->height  << '\n'; 

    return cloud_filtered;
}

void cluster(pcl::PointCloud<PointT>::Ptr input) {
    if (input->empty())
        return;

    //KD-Tree
    pcl::search::KdTree<PointT>::Ptr tree(new pcl::search::KdTree<PointT>);
    pcl::PointCloud<clusterPointT>::Ptr clusterPtr(new pcl::PointCloud<clusterPointT>);
    tree->setInputCloud(input);

    //Segmentation
    std::vector<pcl::PointIndices> cluster_indices;

    //DBSCAN with Kdtree for accelerating
    DBSCANKdtreeCluster<PointT> dc;
    dc.setCorePointMinPts(minPoints);   //Set minimum number of neighbor points
    dc.setClusterTolerance(epsilon); //Set Epsilon 
    dc.setMinClusterSize(minClusterSize);
    dc.setMaxClusterSize(maxClusterSize);
    dc.setSearchMethod(tree);
    dc.setInputCloud(input);
    dc.extract(cluster_indices);

    pcl::PointCloud<clusterPointT> totalcloud_clustered;
    int cluster_id = 0;

    //각 Cluster 접근
    for (std::vector<pcl::PointIndices>::const_iterator it = cluster_indices.begin(); it != cluster_indices.end(); it++, cluster_id++) {
        pcl::PointCloud<clusterPointT> eachcloud_clustered;
        float cluster_counts = cluster_indices.size();

        //각 Cluster내 각 Point 접근
        for(std::vector<int>::const_iterator pit = it->indices.begin(); pit != it->indices.end(); ++pit) {

            clusterPointT tmp;
            tmp.x = input->points[*pit].x; 
            tmp.y = input->points[*pit].y;
            tmp.z = input->points[*pit].z;
            tmp.intensity = cluster_id % 100; // 상수 : 예상 가능한 cluster 총 개수
            eachcloud_clustered.push_back(tmp);
            totalcloud_clustered.push_back(tmp);
        }

        //minPoint와 maxPoint 받아오기
        clusterPointT minPoint, maxPoint;
        pcl::getMinMax3D(eachcloud_clustered, minPoint, maxPoint);

        objectInfoMsg.lengthX[cluster_id] = maxPoint.x - minPoint.x; // 
        objectInfoMsg.lengthY[cluster_id] = maxPoint.y - minPoint.y; // 
        objectInfoMsg.lengthZ[cluster_id] = maxPoint.z - minPoint.z; // 
        objectInfoMsg.centerX[cluster_id] = (minPoint.x + maxPoint.x)/2; //직육면체 중심 x 좌표
        objectInfoMsg.centerY[cluster_id] = (minPoint.y + maxPoint.y)/2; //직육면체 중심 y 좌표
        objectInfoMsg.centerZ[cluster_id] = (minPoint.z + maxPoint.z)/2; //직육면체 중심 z 좌표
    }
    objectInfoMsg.objectCounts = cluster_id;
    pubObjectInfo.publish(objectInfoMsg);

    sensor_msgs::PointCloud2 cluster_point;
    pcl::toROSMsg(totalcloud_clustered, cluster_point);
    cluster_point.header.frame_id = "/velodyne";
    pubCluster.publish(cluster_point);
}

void visualizeCar() {
    uint32_t shape = visualization_msgs::Marker::CUBE; // Set our initial shape type to be a cube
    visualization_msgs::Marker carShape;

    // Set the frame ID and timestamp.  See the TF tutorials for information on these.
    carShape.header.frame_id = "/velodyne"; 
    carShape.header.stamp = ros::Time::now();

    // Set the namespace and id for this marker.  This serves to create a unique ID
    // Any marker sent with the same namespace and id will overwrite the old one
    carShape.ns = "car_shape";
    carShape.id = 0;

    // Set the marker type.  Initially this is CUBE, and cycles between that and SPHERE, ARROW, and CYLINDER
    carShape.type = shape;

    // Set the marker action.  Options are ADD and DELETE
    carShape.action = visualization_msgs::Marker::ADD;

    // Set the pose of the marker.  This is a full 6DOF pose relative to the frame/time specified in the header
    carShape.pose.position.x = -0.4;
    carShape.pose.position.y = 0;
    carShape.pose.position.z = 0.1;
    carShape.pose.orientation.x = 0.0;
    carShape.pose.orientation.y = 0.0;
    carShape.pose.orientation.z = 0.0;
    carShape.pose.orientation.w = 1.0;

    // Set the scale of the marker -- 1x1x1 here means 1m on a side
    carShape.scale.x = 1.6;
    carShape.scale.y = 1.16;
    carShape.scale.z = 0.55;
 
    // Set the color -- be sure to set alpha to something non-zero!
    carShape.color.r = 0.0f;
    carShape.color.g = 1.0f;
    carShape.color.b = 0.0f;
    carShape.color.a = 1.0;

    carShape.lifetime = ros::Duration();

    // Publish the marker
    pubCarShape.publish(carShape);
}

void visualizeObject() {
    visualization_msgs::MarkerArray objectShapeArray;
    visualization_msgs::Marker objectShape;
    uint32_t shape = visualization_msgs::Marker::CUBE; // Set our initial shape type to be a cube
    // Set the frame ID and timestamp.  See the TF tutorials for information on these.
    objectShape.header.frame_id = "/velodyne"; 
    objectShape.ns = "object_shape";
    // Set the marker type.  Initially this is CUBE, and cycles between that and SPHERE, ARROW, and CYLINDER
    objectShape.type = shape;
    // Set the marker action.  Options are ADD and DELETE
    objectShape.action = visualization_msgs::Marker::ADD;
    for (int i = 0; i < objectInfoMsg.objectCounts; i++) {
        // Set the namespace and id for this marker.  This serves to create a unique ID
        // Any marker sent with the same namespace and id will overwrite the old one
        objectShape.header.stamp = ros::Time::now();
        objectShape.id = 100+i; // 

        // Set the pose of the marker.  This is a full 6DOF pose relative to the frame/time specified in the header
        objectShape.pose.position.x = objectInfoMsg.centerX[i];
        objectShape.pose.position.y = objectInfoMsg.centerY[i];
        objectShape.pose.position.z = objectInfoMsg.centerZ[i];

        // Set the scale of the marker -- 1x1x1 here means 1m on a side
        objectShape.scale.x = objectInfoMsg.lengthX[i];
        objectShape.scale.y = objectInfoMsg.lengthY[i];
        objectShape.scale.z = objectInfoMsg.lengthZ[i];
    
        // Set the color -- be sure to set alpha to something non-zero!
        objectShape.color.r = 1.0;
        objectShape.color.g = 1.0;
        objectShape.color.b = 1.0;
        objectShape.color.a = 0.8;

        objectShape.lifetime = ros::Duration(0.1);
        objectShapeArray.markers.emplace_back(objectShape);
    }

    // Publish the marker
    pubObjectShapeArray.publish(objectShapeArray);
}

void mainCallback(const sensor_msgs::PointCloud2ConstPtr& input) {
    pcl::PointCloud<PointT>::Ptr cloudPtr;

    // main process method
    cloudPtr = ROI(input);
    // cloudPtr = voxelGrid(cloudPtr);
    cluster(cloudPtr);

    // visualize method
    
    //1006
    visualizeCar();
    visualizeObject();
}

int main (int argc, char** argv) {
    // Initialize ROS
    ros::init (argc, argv, "object_detector");
    ros::NodeHandle nh;
    
    dynamic_reconfigure::Server<object_detector::objectDetectorConfig> server;
    dynamic_reconfigure::Server<object_detector::objectDetectorConfig>::CallbackType f;

    f = boost::bind(&cfgCallback, _1, _2);
    server.setCallback(f);
    // Create a ROS subscriber for the input point cloud
    ros::Subscriber sub = nh.subscribe ("velodyne_points", 1, mainCallback);

    // Create a ROS publisher for the output point cloud
    pubROI = nh.advertise<sensor_msgs::PointCloud2> ("roi_raw", 1);
    pubCluster = nh.advertise<sensor_msgs::PointCloud2>("cluster", 1);
    pubObjectInfo = nh.advertise<object_detector::ObjectInfo>("object_info", 1);
    pubCarShape = nh.advertise<visualization_msgs::Marker>("visualization_car", 1);
    pubObjectShapeArray = nh.advertise<visualization_msgs::MarkerArray>("bounding_box", 1);

    // Spin
    ros::spin();
}
