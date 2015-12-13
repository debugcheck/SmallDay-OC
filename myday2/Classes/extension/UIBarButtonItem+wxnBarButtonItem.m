//
//  UIBarButtonItem+wxnBarButtonItem.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "UIBarButtonItem+wxnBarButtonItem.h"
#import "theme.h"

@implementation UIBarButtonItem (wxnBarButtonItem)
/// 针对导航条右边按钮的自定义item
- (id) initWithImageName:(NSString*)imageName highImageName:(NSString*)highImageName target:(NSObject*)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 50, 54);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

/// 针对导航条右边按钮有选中状态的自定义item
- (id) initWithImageName:(NSString*)imageName highImageName:(NSString *)highImageName selectedImage:(NSString*)selectedImage target:(NSObject*)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 50, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:target action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

// 针对导航条左边按钮的自定义item
- (id) initWithLeftImageName:(NSString*)leftImageName highImageName:(NSString*)highImageName target:(NSObject*)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 80, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:target action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

/// 导航条纯文字按钮
- (id) initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor target:(NSObject*)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = SDNavItemFont;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 80, 44);
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [button addTarget:target action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}
@end
