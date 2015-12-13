//
//  FeedbackViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"
#import "theme.h"
#import "NSString+wnxString.h"

@interface FeedbackViewController () <UITextFieldDelegate>
/// 反馈留言TextView
@property(nonatomic, strong)UITextView* feedbackTextView;
/// 联系方式textField
@property(nonatomic, strong)UITextField* contactTextField;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条上的内容
    [self setNav];
    
    self.view.backgroundColor = SDWebViewBacagroundColor;
    // 设置留言框和联系框
    [self setFeedbackTextViewAndContactTextField];
}

- (void) setNav
{
    self.navigationItem.title = @"留言反馈";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
}

- (void) setFeedbackTextViewAndContactTextField
{
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, AppWidth, 130)];
    backView.backgroundColor = SDBackgroundColor;
    self.feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, AppWidth - 10, 130)];
    self.feedbackTextView.backgroundColor = SDBackgroundColor;
    self.feedbackTextView.font = [UIFont systemFontOfSize:20];
    self.feedbackTextView.allowsEditingTextAttributes = YES;
    self.feedbackTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [backView addSubview:self.feedbackTextView];
    [self.view addSubview:backView];
    
    self.contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feedbackTextView.frame) + 10, AppWidth, 50)];
    self.contactTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.contactTextField.backgroundColor = SDBackgroundColor;
    self.contactTextField.font = [UIFont systemFontOfSize:18];
    UIView* leffView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.contactTextField.leftView = leffView;
    self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
    self.contactTextField.placeholder = @"留下邮箱或电话,以方便我们给你回复";
    self.contactTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.contactTextField.delegate = self;
    [self.view addSubview:self.contactTextField];
}

- (void) sendClick
{
    NSString* contactStr = self.contactTextField.text;
    UIAlertView* alartView;
    
    if([self.feedbackTextView.text isEqual:@""]) {
        alartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的留言反馈" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alartView show];
        return;
    }
    
    if([contactStr validateEmail] || [contactStr validateMobile]) {
        // TODO 将用户反馈和联系方式发送给服务器
        alartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"感谢您的反馈" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alartView show];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        alartView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写正确的联系方式,以便我们给您回复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alartView show];
    }
}


#pragma mark - life cycle
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.feedbackTextView becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    [self sendClick];
    return YES;
}

@end
