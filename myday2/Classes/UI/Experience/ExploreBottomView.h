//
//  ExploreBottomView.h
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreBottomView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
+ (ExploreBottomView*) exploreBottomViewFromXibWithTitle:(NSString*)title subTitle:(NSString*)subTitle target:(NSObject*)target action:(SEL)action showBtn:(BOOL)showBtn showArror:(BOOL)showArrow;
@end
