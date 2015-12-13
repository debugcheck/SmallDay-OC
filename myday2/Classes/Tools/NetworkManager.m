//
//  NetworkManager.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "NetworkManager.h"
#import "SimpleNetwork.h"

static NetworkManager* instance = nil;
typedef void(^Completion)(NSObject* result, NSError* error);

@interface NetworkManager()
@property(nonatomic, strong)SimpleNetwork* net;
@end

@implementation NetworkManager

+ (NetworkManager*) sharedManager
{
    if(instance == nil) {
        instance = [[NetworkManager alloc]init];
    }
    return instance;
}

- (void) requestJSON:(HTTPMethod)method urlString:(NSString*)url params:(NSDictionary*)params completion:(Completion)completion
{
    [self.net requestJSON:method urlString:url params:params completion:completion];
}

/// 取消全部网络请求
- (void) cancleAllNetwork
{
    [self.net cancleAllNetwork];
}

@end