//
//  CityHeadCollectionReusableView.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "CityHeadCollectionReusableView.h"

@implementation CityHeadCollectionReusableView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.headTitleLabel = [[UILabel alloc]init];
    }
    self.headTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.headTitleLabel.font = [UIFont systemFontOfSize:22];
    self.headTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.headTitleLabel];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.headTitleLabel.frame = self.bounds;
}
@end

@implementation CityFootCollectionReusableView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"更多城市,敬请期待...";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.titleLabel];
    
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}
@end