//
//  LoadAnimatImageView.h
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadAnimatImageView : NSObject
+ (LoadAnimatImageView*) sharedInstance;
- (void) startLoadAnimatImageViewInView:(UIView*)view center:(CGPoint)center;
- (void) stopLoadAnimatImageView;
@end
