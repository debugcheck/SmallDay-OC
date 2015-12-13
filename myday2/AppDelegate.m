//
//  AppDelegate.m
//  myday2
//
//  Created by awd on 15/12/3.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "AppDelegate.h"
#import "theme.h"

#import "MainTabBarController.h"
#import "LeadpageViewController.h"

#import "MainViewController.h"
#import "MainNavigationController.h"

#define SD_ShowMianTabbarController_Notification @"SD_Show_MianTabbarController_Notification"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setKeyWindow];
    [self setAppAppearance];
    [self setShared];
    [self setuserMapInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewController) name:SD_ShowMianTabbarController_Notification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark private
- (void) setKeyWindow {
    self.window = [[UIWindow alloc] initWithFrame:MainBounds];
    self.window.rootViewController = [self showLeadpage];
    
}

- (void) setAppAppearance {
    UITabBarItem* baritemAppearance = [UITabBarItem appearance];
    [baritemAppearance setTitleTextAttributes:@{NSFontAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    [baritemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
    //设置导航栏主题
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    //设置导航title
    [navAppearance setTranslucent:NO];
    [navAppearance setTitleTextAttributes:@{NSFontAttributeName:SDNavTitleFont, NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIBarButtonItem* item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSFontAttributeName:SDNavItemFont, NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
}

- (void) setShared {
    
}

- (void) setuserMapInfo {
    
}

- (UIViewController*) showLeadpage {
    NSString* versionStr = @"CFBundleShortVersionString";
    NSString* currentVersion = (NSString*)[NSBundle mainBundle].infoDictionary[versionStr];
    NSString* oldVersion = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:versionStr];
    if( oldVersion == nil ) {
        oldVersion = @"";
    }
    NSLog(@"old version : %@", oldVersion);
    
    if( [currentVersion compare:oldVersion] == NSOrderedDescending ) {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[LeadpageViewController alloc] init];
    }
    
    return [[MainTabBarController alloc] init];
}

- (void) showMainViewController {
    NSLog(@"showMainViewController");
    MainTabBarController* mainTabBarVC = [[MainTabBarController alloc]init];
    self.window.rootViewController = mainTabBarVC;
    MainNavigationController* nav = (MainNavigationController*) mainTabBarVC.viewControllers[0];
    
    MainViewController* mainC = (MainViewController*)nav.viewControllers[0];
    [mainC pushcityView];
}
@end
