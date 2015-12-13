//
//  MyCenterViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserAccountTool.h"
#import "theme.h"
#import "UIImage+wnxImage.h"
#import "IconView.h"
#define SD_UserDefaults_Account @"SD_UserDefaults_Account"
#define SD_UserDefaults_Password @"SD_UserDefaults_Password"

#define SD_UserIconData_Path [NSString stringWithFormat:@"%@/iconImage.data", cachesPath]

@interface MyCenterViewController ()
@property (weak, nonatomic) IBOutlet UIView *alterPwdView;
@property (weak, nonatomic) IBOutlet IconView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation MyCenterViewController

- (id) init
{
    self = [super initWithNibName:@"MyCenterViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterPwdViewClick)];
    self.alterPwdView.userInteractionEnabled = YES;
    [self.alterPwdView addGestureRecognizer:tap];
    self.accountLabel.text = [UserAccountTool userAccount];
    
    NSData* data = [NSData dataWithContentsOfFile:SD_UserIconData_Path];
    if(data) {
        UIImage* image = [UIImage imageWithData:data];
        [self.iconView.iconButton setImage:[image imageClipOvalImage] forState:UIControlStateNormal];
    }
}

- (void) alterPwdViewClick
{
    NSLog(@"修改密码");
}

- (IBAction)logoutBtnClick:(id)sender
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:SD_UserDefaults_Account];
    [user setObject:nil forKey:SD_UserDefaults_Password];
    if([user synchronize]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    // 将本地的icon图片data删除
    @try {
        [[NSFileManager defaultManager]removeItemAtPath:SD_UserIconData_Path error:nil];
    }@catch(NSException* e) {
    }
}


@end
