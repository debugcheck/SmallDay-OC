//
//  SimpleNetwork.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTPMethod) {
    GET = 0,
    POST = 2
};
typedef void (^Completion)(NSObject* result, NSError* error);

@interface SimpleNetwork : NSObject
- (void) cancleAllNetwork;
- (void) requestJSON:(HTTPMethod)method urlString:(NSString*)url params:(NSDictionary*)params completion:(Completion)completion;
@end
