//
//  ViewController.m
//  TestForDevice
//
//  Created by dvt04 on 2018/3/2.
//  Copyright © 2018年 dvt04. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    [self observeDeviceOrientation];
}

- (void)test
{
    self.motionManager = [[CMMotionManager alloc] init];
    // push方式
    // 1. 判断加速计是否可用
    if (!self.motionManager.isAccelerometerAvailable) {
        NSLog(@"-------- 加速计不可用");
    } else {
        
    }
    // 2. 设置采样间隔
    self.motionManager.accelerometerUpdateInterval = 1;
    // 3. 开始采样
#if 1
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        // 重力感应监测
        double gravityMaxZ = 0.95;
        double gravityz = motion.gravity.z;
        BOOL faceDown = NO;
        if (gravityz > gravityMaxZ) {
            self.view.backgroundColor = [UIColor redColor];
            faceDown = YES;
        } else {
            self.view.backgroundColor = [UIColor yellowColor];
            faceDown = NO;
        }
        // 旋转速度监测
        BOOL isAchieveRotationRate = NO;
        double rateDefault = 3.5;
        CMRotationRate rate = motion.rotationRate;
        
        if (rate.x >= rateDefault || rate.x <= - rateDefault) {
            isAchieveRotationRate = YES;
        }
        if (rate.y >= rateDefault || rate.y <= - rateDefault) {
            isAchieveRotationRate = YES;
        }
        
        if (isAchieveRotationRate && faceDown) {
            // TODO:待完善
            // 震动
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }

    }];
#else
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        // 获取加速计信息
//        CMAcceleration acceleration = accelerometerData.acceleration;
        
    }];
#endif
}

- (void)observeDeviceOrientation
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

#pragma mark - 方向监测
- (void)orientationChange:(NSNotification *)noti
{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down
     */
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        {
            self.view.backgroundColor = [UIColor yellowColor];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
        }
            break;
        case UIDeviceOrientationFaceDown:
        {
            NSLog(@"-------- facedown");
            self.view.backgroundColor = [UIColor redColor];
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - 距离监测
- (void)proximityStateChanged:(NSNotification *)noti
{
    // 靠近物体后会自动黑屏
    BOOL isProximity = [UIDevice currentDevice].proximityState;
    NSLog(@"%@", isProximity?@"YES":@"NO");
}

#pragma mark - 禁止横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
