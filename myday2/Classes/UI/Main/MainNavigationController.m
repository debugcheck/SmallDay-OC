//
//  MainNavigationController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MainNavigationController.h"
#import "theme.h"

@interface MainNavigationController()
@property(nonatomic, strong)UIButton* backBtn;
@end
@implementation MainNavigationController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (UIButton*) backBtn
{
    NSLog(@"MainNavigationController backBtn");
    if(_backBtn == nil){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_backBtn setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        _backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        CGFloat btnW = AppWidth > 375.0 ? 50 : 44;
        _backBtn.frame = CGRectMake(0, 0, btnW, 40);
    }
    
    return _backBtn;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0) {
        UIViewController* vc = self.childViewControllers[0];
        
        if(self.childViewControllers.count == 1) {
            [self.backBtn setTitle:vc.tabBarItem.title forState:UIControlStateNormal];
        } else {
            [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
        }
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void) backBtnClick
{
    [self popViewControllerAnimated:YES];
}
@end
