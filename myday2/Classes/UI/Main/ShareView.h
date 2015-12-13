//
//  ShareView.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@interface ShareView : UIView
@property(nonatomic, strong)UIViewController* shareVC;
@property(nonatomic, strong)ShareModel* shareModel;
- (void) showShareView:(CGRect)rect;
+ (ShareView*) shareViewFromXib;
@end
