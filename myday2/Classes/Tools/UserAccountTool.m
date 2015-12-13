//
//  UserAccountTool.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "UserAccountTool.h"
#import "theme.h"

#define SD_UserLogin_Notification @"SD_UserLogin_Notification"
#define SD_UserDefaults_Account @"SD_UserDefaults_Account"
#define SD_UserDefaults_Password @"SD_UserDefaults_Password"

@implementation UserAccountTool
/// 判断当前用户是否登录
+ (BOOL) userIsLogin
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* account = [user objectForKey:SD_UserDefaults_Account];
    NSString* password = [user objectForKey:SD_UserDefaults_Password];
    
    if(account != nil && password != nil) {
        if(![account isEqual:@""] && ![password isEqual:@""]) {
            return YES;
        }
    }
    return NO;
}

/// 如果用户登录了,返回用户的账号(电话号)
+ (NSString*) userAccount
{
    if(![self userIsLogin]) {
        return nil;
    }
    
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* account = [user objectForKey:SD_UserDefaults_Account];
    return account;
}
@end
