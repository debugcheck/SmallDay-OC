//
//  ShareModel.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ShareModel.h"
#import <UIKit/UIKit.h>


@interface ShareModel()
@property(nonatomic, strong)NSString* shareTitle;
@property(nonatomic, strong)NSString* shareURL;
@property(nonatomic, strong)UIImage* img;
@property(nonatomic, strong)NSString* shareDetail;
@end

@implementation ShareModel
- (ShareModel*) init:(NSString*)shareTitle shareURL:(NSString*)shareURL image:(UIImage*)image shareDetail:(NSString*)shareDetail
{
    self = [super init];
    if(shareDetail != nil) {
        NSString* text = [NSString stringWithCString:[shareDetail cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
        if(text) {
            if([text length] > 50) {
                NSString* aa = [text substringFromIndex:50];
                self.shareDetail = aa;
            } else {
                self.shareDetail = shareDetail;
            }
        }
    }
    self.shareTitle = shareTitle;
    self.img = image;
    self.shareURL = shareURL;
    
    return self;
}
@end
