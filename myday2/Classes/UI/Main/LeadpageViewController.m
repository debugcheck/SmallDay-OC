//
//  LeadpageViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "LeadpageViewController.h"
#import "DoubleTextView.h"
#import "theme.h"

#define SD_ShowMianTabbarController_Notification @"SD_Show_MianTabbarController_Notification"

@interface LeadpageViewController()
@property(nonatomic, strong)UIImageView* backgroundImage;
@property(nonatomic, strong)NoHighlightButton* startBtn;
@end
@implementation LeadpageViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSString* imageName = nil;
    switch ((int)AppWidth) {
        case 375:
            imageName = [[NSBundle mainBundle]pathForResource:@"fourpage-375w-667h@2x.jpg" ofType:nil];
            break;
        case 414:
            imageName = [[NSBundle mainBundle]pathForResource:@"fourpage-414w-736h@3x.jpg" ofType:nil];
            break;
        case 568:
            imageName = [[NSBundle mainBundle]pathForResource:@"fourpage-568h@2x.jpg" ofType:nil];
            break;
            
        default:
            imageName = [[NSBundle mainBundle]pathForResource:@"fourpage@2x.jpg" ofType:nil];
            break;
    }
    self.backgroundImage = [[UIImageView alloc]initWithFrame:MainBounds];
    self.backgroundImage.image = [UIImage imageWithContentsOfFile:imageName];
    [self.view addSubview:self.backgroundImage];
    
    self.startBtn = [[NoHighlightButton alloc]init];
    
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"into_home"] forState:UIControlStateNormal];
    [self.startBtn setTitle:@"开始小日子" forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startBtn.frame = CGRectMake((AppWidth - 210) * 0.5, AppHeight - 120, 210, 45);
    [self.startBtn addTarget:self action:@selector(showMainTabbar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startBtn];
}

- (void) showMainTabbar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SD_ShowMianTabbarController_Notification object: nil];
}
@end
