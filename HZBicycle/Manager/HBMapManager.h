//
//  HBMapManager.h
//  HZBicycle
//
//  Created by MADAO on 16/10/31.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBMapManager : NSObject

/**
 将火星坐标转换为百度坐标。

 @param coordinate 火星坐标

 @return 百度坐标
 */
+ (CLLocationCoordinate2D)convertToBaiduCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 获取杭州的中心点坐标
 */
+ (CLLocationCoordinate2D)hangZhouCenter;

/**
 计算两个坐标点之间距离，单位为米
 */
+ (NSUInteger)getDistanceFromPoint:(CLLocationCoordinate2D)point toAnotherPoint:(CLLocationCoordinate2D)anotherPoint;
    
/**
 通过导航路径获取地图范围

 @param route 路径
 @return 地图范围
 */
+ (MACoordinateRegion)getRegionFromNaviRoute:(AMapNaviRoute *)route;
@end

/**
 各种坐标系转换
 */
@interface DFLocationConverter : NSObject

/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;


/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;
/**
 *  @brief  中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;


@end
