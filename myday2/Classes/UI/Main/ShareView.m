//
//  ShareView.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ShareView.h"
#import "EveryDayModel.h"
#import "theme.h"

@interface ShareView()
@property(nonatomic, strong)UIButton* coverBtn;
@end

@implementation ShareView
- (UIButton*) getCoverBtn
{
    UIButton* coverBtn = [[UIButton alloc]initWithFrame:MainBounds];
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0.2;
    [coverBtn addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    return coverBtn;
}

+ (ShareView*) shareViewFromXib
{
    ShareView* shareV = (ShareView*)[[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil] lastObject];
    shareV.frame = CGRectMake(0, AppHeight, AppWidth, ShareViewHeight);
    return shareV;
}


- (IBAction)weChat:(id)sender {
    [self hideShareView];
    //[ShareTool shareToWeChat:self.shareModel];
}
- (IBAction)friends:(id)sender {
    [self hideShareView];
    //[ShareTool shareToWeChatFriends:self.shareModel];
}
- (IBAction)sina:(id)sender {
    [self hideShareView];
    //[ShareTool shareToSina:self.shareModel viewController:self.shareVC];
}
- (IBAction)cancle:(id)sender {
    [self hideShareView];
}


- (void) showShareView:(CGRect)rect
{
    [self.superview insertSubview:self.coverBtn belowSubview:self];
    [UIView animateWithDuration:0.4 animations:^(void){
        self.frame = rect;
    }];
}

- (void) hideShareView
{
    [self.coverBtn removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^(void){
        self.frame = CGRectMake(0, AppHeight, AppWidth, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) coverClick
{
    [self hideShareView];
}
@end