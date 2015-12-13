//
//  UserInfoManager.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "UserInfoManager.h"

#define SD_UserLogin_Notification @"SD_UserLogin_Notification"
#define SD_UserDefaults_Account @"SD_UserDefaults_Account"
#define SD_UserDefaults_Password @"SD_UserDefaults_Password"

static UserInfoManager* sharedInstance;

@interface UserInfoManager()<CLLocationManagerDelegate>
@property(nonatomic, strong)CLLocationManager* locationManage;
@end

@implementation UserInfoManager
+ (UserInfoManager*) sharedUserInfoManager
{
    if(sharedInstance == nil) {
        sharedInstance = [[UserInfoManager alloc]init];
    }
    return sharedInstance;
}

- (CLLocationManager*) getLocationManage
{
    CLLocationManager* locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    return locationManager;
}

- (void) startUserlocation
{
    [self.locationManage autoContentAccessingProxy];
    [self.locationManage startUpdatingLocation];
}

/// 判断当前用户是否登录
+ (BOOL) userIsLogin
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* account = (NSString*)[user objectForKey:SD_UserDefaults_Account];
    NSString* password = (NSString*)[user objectForKey:SD_UserDefaults_Password];
    
    if(account != nil && password != nil)
    {
        if([account length] != 0 && [password length] == 0)
        {
            return YES;
        }
    }
    return NO;
}
/// 如果用户登录了,返回用户的账号(电话号)
+ (NSString*) userAccount
{
    if(![self userIsLogin])
    {
        return nil;
    }
    
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* account = (NSString*)[user objectForKey:SD_UserDefaults_Account];
    return account;
}

#pragma mark CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation* userPos = locations[0];
    self.userPosition = userPos.coordinate;
    [self.locationManage stopUpdatingLocation];
}
@end
