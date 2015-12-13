//
//  ShareModel.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareModel : NSObject
- (ShareModel*) init:(NSString*)shareTitle shareURL:(NSString*)shareURL image:(UIImage*)image shareDetail:(NSString*)shareDetail;
@end
