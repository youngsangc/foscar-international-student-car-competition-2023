#ifndef HEADER_H
#define HEADER_H

#include <iostream> 
#include <string>  
#include <vector>
#include <ctime>
#include <chrono>
#include <time.h>
#include <algorithm>
#include <cmath>

#include <ros/ros.h>

#include <sensor_msgs/PointCloud2.h>

#include <pcl/io/pcd_io.h>
#include <pcl/common/common.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/filters/crop_box.h>
#include <pcl/kdtree/kdtree.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/common/transforms.h>
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/conversions.h>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/ModelCoefficients.h>
#include <pcl/features/normal_3d.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/model_types.h>
#include <pcl/visualization/cloud_viewer.h>
#include <pcl/filters/passthrough.h>
#include <pcl/segmentation/progressive_morphological_filter.h>

#include <visualization_msgs/Marker.h>
#include <visualization_msgs/MarkerArray.h>

#include <nav_msgs/Path.h>
#include <geometry_msgs/PoseStamped.h>
#include <geometry_msgs/Pose.h>
#include <geometry_msgs/PoseArray.h>

#include <std_msgs/Bool.h>

#include <lidar_team_erp42/Boundingbox.h>
#include <lidar_team_erp42/Waypoint.h>
#include <lidar_team_erp42/Delivery.h>
#include <lidar_team_erp42/DynamicVelocity.h>
#include <lidar_team_erp42/PurePursuit.h>

#include <dynamic_reconfigure/server.h>
#include "lidar_team_erp42/hyper_parameterConfig.h"
#include "lidar_team_erp42/dy_hyper_parameterConfig.h"
#include "lidar_team_erp42/small_st_hyper_parameterConfig.h"
#include "lidar_team_erp42/large_st_hyper_parameterConfig.h"
#include "lidar_team_erp42/de_hyper_parameterConfig.h"
#include "lidar_team_erp42/pk_hyper_parameterConfig.h"
#include "lidar_team_erp42/uturn_hyper_parameterConfig.h"
#include <race/drive_values.h>


#endif // HEADER_H