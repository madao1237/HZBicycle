//
//  HBOfflineMapManager.m
//  HZBicycle
//
//  Created by MADAO on 16/10/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBOfflineMapManager.h"
#import <AMap3DMap/MAMapKit/MAMapKit.h>
@interface HBOfflineMapManager()

/**
 当前选中城市
 */
@property (nonatomic, strong, readwrite) MAOfflineCity *selectedCity;

/**
 当前选中的城市的代码
 */
@property (nonatomic, strong) NSString *selectedCityCode;

@end

@implementation HBOfflineMapManager

+ (instancetype)sharedManager
{
    static HBOfflineMapManager *mapManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapManager = [[HBOfflineMapManager alloc] init];
    });
    return mapManager;
}

#pragma mark - Setter
- (void)setSelectedCityCode:(NSString *)selectedCityCode
{
    _selectedCityCode = selectedCityCode;
    [self configWithCityCode:_selectedCityCode];
}

#pragma mark - Public Method
- (void)config {
    [self configWithCityCode:@"0571"];
}

- (void)clearMap {
    [[MAOfflineMap sharedOfflineMap] clearDisk];
}

- (void)configWithCityCode:(NSString *)code
{
    //初始化离线地图
    [[MAOfflineMap sharedOfflineMap] setupWithCompletionBlock:^(BOOL setupSuccess) {
        //根据编码 选取城市
        NSArray *cityArray = [MAOfflineMap sharedOfflineMap].cities;
        @WEAKSELF;
        [cityArray enumerateObjectsUsingBlock:^(MAOfflineItemMunicipality *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj.cityCode isKindOfClass:[NSString class]]){
                return;
            }
            if ([obj.cityCode isEqualToString:code]) {
                _selectedCityCode = obj.cityCode;
                weakSelf.selectedCity = obj;
                *stop = YES;
            }
        }];
    }];
}

- (void)startDownloadWithBlock:(MAOfflineMapDownloadBlock)downloadBlock
{
    if (self.selectedCity == nil) {
        //未选择城市
        downloadBlock(nil,MAOfflineMapDownloadStatusError,[NSError errorWithDomain:NSURLErrorDomain code:-999 userInfo:@{@"message":@"Please run config or congfigWithCode first"}]);
        return;
    }
    //判断下载对象状态:
//    MAOfflineItemStatusNone = 0,    //!< 不存在
//    MAOfflineItemStatusCached,      //!< 缓存状态
//    MAOfflineItemStatusInstalled,   //!< 已安装
//    MAOfflineItemStatusExpired      //!< 已过期
//    typedef void(^MAOfflineMapDownloadBlock)(MAOfflineItem * downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info);
    else if (self.selectedCity.itemStatus == MAOfflineItemStatusInstalled) {
        //下载好了
       downloadBlock(self.selectedCity,MAOfflineMapDownloadStatusCompleted,nil);
        [[MAOfflineMap sharedOfflineMap] downloadItem:self.selectedCity shouldContinueWhenAppEntersBackground:YES downloadBlock:downloadBlock];
    }
    else if (self.selectedCity.itemStatus == MAOfflineItemStatusCached || self.selectedCity.itemStatus == MAOfflineItemStatusNone){
        //高德支持断点续传，是否自动更新还不知道
        [[MAOfflineMap sharedOfflineMap] downloadItem:self.selectedCity shouldContinueWhenAppEntersBackground:YES downloadBlock:downloadBlock];
    }
}

#pragma mark - Private Method

@end
