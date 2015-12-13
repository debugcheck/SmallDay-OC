//
//  IconView.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "IconView.h"
#import "UIImage+wnxImage.h"

@interface IconView()
@end

@implementation IconView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
}

- (void) setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.iconButton setImage:[UIImage imageNamed:@"my"] forState:UIControlStateNormal];
    [self.iconButton addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.iconButton.clipsToBounds = YES;
    [self addSubview:self.iconButton];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat mrgin = 8;
    self.iconButton.frame = CGRectMake(mrgin, mrgin, self.frame.size.width - mrgin * 2, self.frame.size.height - mrgin * 2);
    [self.iconButton setBackgroundImage:[[UIImage imageNamed:@"white"] imageClipOvalImage] forState:UIControlStateNormal];
}

- (void) drawRect:(CGRect)rect
{
    CGFloat circleWidth = 2;
    // 圆角矩形
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(circleWidth, circleWidth, rect.size.width - circleWidth * 2, rect.size.width - circleWidth * 2) cornerRadius: rect.size.width];
    path.lineWidth = circleWidth;
    [[UIColor whiteColor] set];
    [path stroke];
}

- (void) iconBtnClick
{
    [self.delegate iconView:self didClick:self.iconButton];
}


@end
