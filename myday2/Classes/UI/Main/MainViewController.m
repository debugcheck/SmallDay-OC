//
//  MainViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MainViewController.h"
#import "MainNavigationController.h"
#import "CityViewController.h"
#import "theme.h"

#define SD_Current_SelectedCity @"SD_Current_SelectedCity"
#define SD_CurrentCityChange_Notification @"SD_CurrentCityChange_Notification"

@interface TextImageButton : UIButton
@end



@interface MainViewController ()
@property(nonatomic, strong)TextImageButton* cityRightBtn;
@end

@implementation MainViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:SD_CurrentCityChange_Notification object:nil];
    
    _cityRightBtn = [[TextImageButton alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* currentCity = [user objectForKey:SD_Current_SelectedCity];
    if(currentCity) {
        [_cityRightBtn setTitle:currentCity forState:UIControlStateNormal];
    } else {
        [_cityRightBtn setTitle:@"北京" forState:UIControlStateNormal];
    }
    
    [_cityRightBtn.titleLabel setFont:SDNavItemFont];
    [_cityRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cityRightBtn setImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateNormal];
    [_cityRightBtn addTarget:self action:@selector(pushcityView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_cityRightBtn];
}

- (void) pushcityView {
    CityViewController* cityVC = [[CityViewController alloc]init];
    cityVC.cityName = [self.cityRightBtn titleForState:UIControlStateNormal];
    MainNavigationController* nav = [[MainNavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) cityChange:(NSNotification*)noti {
    NSString* currentCityname = (NSString*)noti.object;
    NSLog(@"city value change to :d%@", currentCityname);
    if(currentCityname) {
        [self.cityRightBtn setTitle:currentCityname forState:UIControlStateNormal];
    }
}
@end


@implementation TextImageButton

@end
