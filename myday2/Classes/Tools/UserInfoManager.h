//
//  UserInfoManager.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface UserInfoManager : NSObject
@property(nonatomic)CLLocationCoordinate2D userPosition;

+ (BOOL) userIsLogin;
+ (NSString*) userAccount;
+ (UserInfoManager*) sharedUserInfoManager;
@end
