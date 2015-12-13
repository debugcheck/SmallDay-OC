//
//  SearchView.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SearchView.h"
#import "SearchTextField.h"
#import "SearchButton.h"
#import "theme.h"

@interface SearchView() <UITextFieldDelegate>
@property(nonatomic)CGFloat animationDuration;
@property(nonatomic)BOOL isScale;
@end

@implementation SearchView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.animationDuration = 0.5;
    self.searchTextField = [[SearchTextField alloc]init];
    self.searchBtn = [[UIButton alloc]init];
    self.isScale = NO;
    
    self.searchTextField = [[SearchTextField alloc]init];
    CGFloat margin = 20;
    self.searchTextField.frame = CGRectMake(margin, 20 * 0.5, AppWidth - 2 * margin, 30);
    self.searchTextField.delegate = self;
    [self addSubview:self.searchTextField];
    
    self.searchBtn = [[SearchButton alloc]initWithFrame:CGRectMake(AppWidth - 100, 0, 100, 50) target: self action:@selector(searchBtnClick:)];
    
    [self addSubview:self.searchBtn];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillshow) name: UIKeyboardWillShowNotification object:nil];
    
    return self;
}


- (void) keyBoardWillshow
{
    [UIView animateWithDuration:self.animationDuration animations:^(){
        self.searchBtn.alpha = 1;
        self.searchBtn.selected = NO;
        if(!self.isScale) {
            CGRect frame = self.searchTextField.frame;
            frame.size.width = self.searchTextField.frame.size.width - 60;
            self.searchTextField.frame = frame;
            self.isScale = YES;
        }
    }];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self endEditing:YES];
}

- (void) resumeSearchTextField
{
    [UIView animateWithDuration:self.animationDuration animations:^() {
        if(self.isScale) {
            self.searchBtn.alpha = 0;
            self.searchBtn.selected = NO;
            CGRect frame = self.searchTextField.frame;
            frame.size.width = self.searchTextField.frame.size.width + 60;
            self.searchTextField.frame= frame;
            self.isScale = NO;
        }
    }];
}

- (void) searchBtnClick:(UIButton*)sender
{
    if(sender.selected) {
        sender.selected = NO;
        [self.searchTextField becomeFirstResponder];
    } else if (self.searchTextField.text == nil || [self.searchTextField.text isEqual:@""]) {
        return;
    } else {
        sender.selected = YES;
        if(self.delegate != nil) {
            [self.delegate searchView:self searchTitle:self.searchTextField.text];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    if([textField.text isEqual:@""]) {
        return NO;
    }
    
    [self searchBtnClick:self.searchBtn];
    return YES;
}
@end
