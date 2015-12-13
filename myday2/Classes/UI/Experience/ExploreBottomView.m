//
//  ExploreBottomView.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExploreBottomView.h"

@interface ExploreBottomView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;

@end
@implementation ExploreBottomView
+ (ExploreBottomView*) exploreBottomViewFromXibWithTitle:(NSString*)title subTitle:(NSString*)subTitle target:(NSObject*)target action:(SEL)action showBtn:(BOOL)showBtn showArror:(BOOL)showArrow
{
    ExploreBottomView* expView = (ExploreBottomView*)[[[NSBundle mainBundle]loadNibNamed:@"ExploreBottomView" owner:nil options:nil] lastObject];
    
    expView.titleLabel.text = title;
    expView.subTitleLabel.text = subTitle;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [expView addGestureRecognizer:tap];
    expView.remindBtn.hidden = !showBtn;
    expView.arrowImageView.hidden = !showArrow;
    expView.backgroundColor = [UIColor clearColor];
    expView.remindBtn.enabled = NO;
    expView.userInteractionEnabled = YES;
    
    return expView;
}
@end
