//
//  HBRealTimeNaviController.m
//  HZBicycle
//
//  Created by 胡翔 on 2017/1/20.
//  Copyright © 2017年 MADAO. All rights reserved.
//

#import "HBRealTimeNaviController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface HBRealTimeNaviController () <AMapNaviWalkViewDelegate,AMapNaviRideViewDelegate>

@property (nonatomic, strong) AMapNaviRideView *naviRideView;

@property (nonatomic, strong) AMapNaviWalkView *naviWalkView;

@property (nonatomic, strong) AMapNaviRideManager *rideManager;

@property (nonatomic, strong) AMapNaviWalkManager *walkManager;

@end

@implementation HBRealTimeNaviController

#pragma mark - Lazy Init 
- (AMapNaviRideView *)naviRideView {
    if (_naviRideView == nil) {
        _naviRideView = [[AMapNaviRideView alloc] initWithFrame:self.view.frame];
        _naviRideView.showMoreButton = NO;
        _naviRideView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_naviRideView setDelegate:self];
        [self.view addSubview:_naviRideView];
    }
    return _naviRideView;
}

-(AMapNaviWalkView *)naviWalkView {
    if (_naviWalkView == nil) {
        _naviWalkView = [[AMapNaviWalkView alloc] initWithFrame:self.view.frame];
        _naviWalkView.showMoreButton = NO;
        _naviWalkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_naviWalkView setDelegate:self];
        [self.view addSubview:_naviWalkView];
    }
    return _naviWalkView;
}

- (instancetype)initWithNaviType:(HBNaviType)naviType {
    if (self = [self init]) {
        switch (naviType) {
            case HBNaviTypeWalk:
                self.walkManager = (AMapNaviWalkManager *)[HBNaviManager sharedManager].naviManager;
                break;
            default:
                self.rideManager = (AMapNaviRideManager *)[HBNaviManager sharedManager].naviManager;
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviDriveView];
    // Do any additional setup after loading the view.
}

- (void)setupNaviDriveView {
    if ([HBNaviManager sharedManager].naviType == HBNaviTypeWalk) {
        [self.walkManager addDataRepresentative:self.naviWalkView];
        [self.walkManager startGPSNavi];
    }else {
        [self.rideManager addDataRepresentative:self.naviRideView];
        [self.rideManager startGPSNavi];
    }
}

#pragma mark - NaviViewDelegate
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIStatusBarStyle
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
