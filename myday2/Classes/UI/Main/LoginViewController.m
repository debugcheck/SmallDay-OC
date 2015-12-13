//
//  LoginViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "LoginViewController.h"
#import "theme.h"
#import "SVProgressHUD.h"
#import "NSString+wnxString.h"
#import "NSString+Hash.h"

#define SD_UserLogin_Notification @"SD_UserLogin_Notification"
#define SD_UserDefaults_Account @"SD_UserDefaults_Account"
#define SD_UserDefaults_Password @"SD_UserDefaults_Password"

@interface LoginViewController()
@property(nonatomic, strong)UIView* bottomView;
@property(nonatomic, strong)UIScrollView* backScrollView;
@property(nonatomic, strong)UIView* topView;
@property(nonatomic, strong)UITextField* phoneTextField;
@property(nonatomic, strong)UITextField* psdTextField;
@property(nonatomic, strong)UIImageView* loginImageView;
@property(nonatomic, strong)UIButton* quickLoginBtn;
@property(nonatomic, strong)UIImageView* forgetPwdImageView;
@property(nonatomic, strong)UIImageView* registerImageView;
@property(nonatomic, strong)UIColor* textColor;
@property(nonatomic)CGFloat loginW;
@end

@implementation LoginViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = SDWebViewBacagroundColor;
    //添加scrollView
    [self addScrollView];
    // 添加手机文本框和密码文本框
    [self addTextField];
    // 添加登录View
    [self addLoginImageView];
    // 添加快捷登录按钮
    [self addQuictLoginBtn];
    // 添加底部忘记密码和注册view
    [self addBottomView];
    // 添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) addScrollView
{
    self.backScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.backScrollView.backgroundColor = SDWebViewBacagroundColor;
    self.backScrollView.alwaysBounceVertical = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backScrollViewTap)];
    [self.backScrollView addGestureRecognizer:tap];
    [self.view addSubview:self.backScrollView];
}

- (void) backScrollViewTap
{
    [self.view endEditing:YES];
}

- (void) addLoginImageView
{
    CGFloat loginH = 50;
    UIImageView* loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake((AppWidth - self.loginW) * 0.5, CGRectGetMaxY(self.topView.frame) + 10, self.loginW, loginH)];
    loginImageView.userInteractionEnabled = YES;
    loginImageView.image = [UIImage imageNamed:@"signin_1"];
    
    UILabel* loginLabel = [[UILabel alloc]initWithFrame:loginImageView.bounds];
    loginLabel.text = @"登  录";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.textColor = self.textColor;
    loginLabel.font = [UIFont systemFontOfSize:22];
    [loginImageView addSubview:loginLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginClick)];
    [loginImageView addGestureRecognizer:tap];
    
    [self.backScrollView addSubview:loginImageView];
}

- (void) addTextField
{
    CGFloat textH = 55;
    CGFloat leftMargin = 10;
    CGFloat alphaV = 0.2;
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, AppWidth, textH * 2)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.topView];
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, 1)];
    line1.backgroundColor = [UIColor grayColor];
    line1.alpha = alphaV;
    [self.topView addSubview:line1];
    
    self.phoneTextField = [[UITextField alloc]init];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addTextFieldToTopViewWith:self.phoneTextField frame:CGRectMake(leftMargin, 1, AppWidth - leftMargin, textH - 1) placeholder:@"请输入手机号"];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, textH, AppWidth, 1)];
    line2.backgroundColor = [UIColor grayColor];
    line2.alpha = alphaV;
    [self.topView addSubview:line2];
    
    self.psdTextField = [[UITextField alloc]init];
    [self addTextFieldToTopViewWith:self.psdTextField frame:CGRectMake(leftMargin, textH + 1, AppWidth - leftMargin, textH - 1) placeholder:@"密码"];
}

- (void) addQuictLoginBtn
{
    self.quickLoginBtn = [[UIButton alloc]init];
    [self.quickLoginBtn setTitle:@"无账号快捷登录" forState:UIControlStateNormal];
    [self.quickLoginBtn.titleLabel sizeToFit];
    self.quickLoginBtn.contentMode = UIViewContentModeRight;
    CGFloat quickW = self.quickLoginBtn.titleLabel.frame.size.width;
    self.quickLoginBtn.frame = CGRectMake(AppWidth - quickW - 10, CGRectGetMaxY(self.loginImageView.frame) + 10, quickW, 30);
    self.quickLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.quickLoginBtn addTarget:self action:@selector(quickLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.quickLoginBtn setTitle:@"无账号快捷登录" forState:UIControlStateNormal];
    [self.quickLoginBtn setTitleColor:self.textColor forState:UIControlStateNormal];
    [self.quickLoginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.backScrollView addSubview:self.quickLoginBtn];
}

- (void) addTextFieldToTopViewWith:(UITextField*)textField frame:(CGRect)frame placeholder:(NSString*)placeholder
{
    textField.frame = frame;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = placeholder;
    [self.topView addSubview:textField];
}

- (void) addBottomView
{
    CGFloat forgetPwdImageViewH = 45;
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake((AppWidth - self.loginW) * 0.5, AppHeight - forgetPwdImageViewH - 10 - 64, self.loginW, forgetPwdImageViewH)];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.backScrollView addSubview:self.bottomView];
    
    self.forgetPwdImageView = [[UIImageView alloc]init];
    [self addBottomViewWithImageView:self.forgetPwdImageView tag:10 frame:CGRectMake(0, 0, self.loginW * 0.5, forgetPwdImageViewH) imageName:@"c1_1" title:@"忘记密码"];
    
    self.registerImageView = [[UIImageView alloc]init];
    [self addBottomViewWithImageView:self.registerImageView tag:11 frame:CGRectMake(self.bottomView.frame.size.width * 0.5, 0, self.loginW * 0.5, forgetPwdImageViewH) imageName:@"c1_2" title:@"注册"];
}


- (void) addBottomViewWithImageView:(UIImageView*)imageView tag:(NSInteger)tag frame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title
{
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    imageView.tag = tag;
    imageView.userInteractionEnabled = YES;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor;
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:label];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewColcikWith:)];
    [imageView addGestureRecognizer:tap];
    
    [self.bottomView addSubview:imageView];
    
}

/// 底部忘记密码和注册按钮点击
- (void) bottomViewColcikWith:(UIGestureRecognizer*)tap
{
    if(tap.view.tag == 10) { // 忘记密码
        NSLog(@"忘记密码");
    } else {                 // 注册
        NSLog(@"注册");
        [SVProgressHUD showErrorWithStatus:@"直接登录就行...没有注册功能" maskType:SVProgressHUDMaskTypeBlack];
    }
}

/// 登录按钮被点击
- (void) loginClick
{
    
    if(![self.phoneTextField.text validateMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的正确手机号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    } else if([self.psdTextField.text isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    //将用户的账号和密码暂时保存到本地,实际开发中光用MD5加密是不够的,需要多重加密
    NSString* account = self.phoneTextField.text;
    NSString* psdMD5 = [self.psdTextField.text md5];
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:SD_UserDefaults_Account];
    [[NSUserDefaults standardUserDefaults] setObject:psdMD5 forKey:SD_UserDefaults_Password];
    if([[NSUserDefaults standardUserDefaults] synchronize]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 快捷登录点击
- (void) quickLoginClick
{
    NSLog(@"快捷登陆");
}

- (void) keyboardWillChangeFrameNotification:(NSNotification*)note
{
    // TODO 添加键盘弹出的事件
    NSDictionary* userinfo = note.userInfo;
    CGRect rect = [userinfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat boardH = AppHeight - rect.origin.y;
    if(boardH > 0) {
        boardH = boardH + NavigationH;
    }
    self.backScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height + boardH);
}


@end
