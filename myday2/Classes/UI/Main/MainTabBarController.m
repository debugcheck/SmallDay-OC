//
//  MainTabBarController.m
//  myday2
//
//  Created by awd on 15/12/3.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "ExploreViewController.h"
#import "ExperienceViewController.h"
#import "ClassifyViewController.h"
#import "MeViewController.h"
#import "theme.h"

@implementation MainTabBarController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
    
    [self setValue:[[MainTabBar alloc]init] forKey:@"tabBar"];
}

- (void) setUpAllChildViewController {
    //探店
    [self tabBarAddChildViewController:[[ExploreViewController alloc]init] withTitle:@"探店" imageName:@"recommendation_1" selectedImageName:@"recommendation_2"];
    // 体验
    [self tabBarAddChildViewController:[[ExperienceViewController alloc]init] withTitle:@"体验"imageName:@"broadwood_1" selectedImageName:@"broadwood_2"];
    // 分类
    [self tabBarAddChildViewController:[[ClassifyViewController alloc]init] withTitle:@"分类" imageName: @"classification_1" selectedImageName:@"classification_2"];
    // 我的
    [self tabBarAddChildViewController:[[MeViewController alloc]init] withTitle:@"我的" imageName:@"my_1" selectedImageName:@"my_2"];
}

- (void) tabBarAddChildViewController:(UIViewController*)vc withTitle:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName {
    vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
    vc.view.backgroundColor = SDBackgroundColor;
    MainNavigationController* nav = [[MainNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
@end

@implementation MainTabBar
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.translucent = NO;
    self.backgroundImage = [UIImage imageNamed:@"tabbar"];
    
    return self;
}
@end