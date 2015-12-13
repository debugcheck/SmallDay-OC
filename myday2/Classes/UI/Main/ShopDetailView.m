//
//  ShopDetailView.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ShopDetailView.h"

@interface ShopDetailView()
@property(nonatomic, strong)UILabel* findLabel;
@property(nonatomic, strong)UILabel* detailLabel;
@property(nonatomic, strong)UIView* middleLineView;
@property(nonatomic, strong)UIView* bottomLineView;
@property(nonatomic)CGFloat bottomLineScale;
@property(nonatomic, strong)UIView* blackLineView;
@property(nonatomic, strong)UIView* bottomBlackLineView;
@end

@implementation ShopDetailView

- (id) initWithFrame:(CGRect)frame
{
    NSLog(@"ShopDetailView initWithFrame");
    self = [super initWithFrame:frame];
    
    self.bottomLineScale = 0.6;
    self.backgroundColor = [UIColor whiteColor];
    
    self.blackLineView = [[UIView alloc]init];
    self.blackLineView.alpha = 0.05;
    self.blackLineView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.blackLineView];
    
    self.bottomBlackLineView = [[UIView alloc]init];
    self.bottomBlackLineView.alpha = 0.03;
    self.bottomBlackLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.bottomBlackLineView];
    
    self.findLabel = [[UILabel alloc]init];
    [self setLabel:self.findLabel text:@"店 · 发现" action:@selector(labelClick:) tag:0];
    
    self.detailLabel = [[UILabel alloc]init];
    [self setLabel:self.detailLabel text:@"店 · 详情" action:@selector(labelClick:) tag:1];
    
    self.middleLineView = [[UIView alloc]init];
    self.middleLineView.backgroundColor = [ UIColor grayColor];
    [self addSubview:self.middleLineView];
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomLineView];
    
    return self;
}

- (void) setLabel:(UILabel*)label text:(NSString*)text action:(SEL)action tag:(NSInteger)tag
{
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    label.userInteractionEnabled = YES;
    label.tag = tag;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [label addGestureRecognizer:tap];
    [self addSubview:label];
}

- (void) labelClick:(UITapGestureRecognizer*) tap
{
    NSLog(@"shop detail view: lableClick");
    NSInteger index = tap.view.tag;
    
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(shopDetailView:didSelectedLableAtIndex:)]) {
            [self.delegate shopDetailView:self didSelectedLableAtIndex:index];
        }
    }
    
    CGFloat labelW = self.frame.size.width * 0.5;
    CGFloat bottomLineW = labelW * self.bottomLineScale;
    CGFloat bottomLineH = 1.5;
    CGFloat bottomLineX = index * labelW + (labelW - bottomLineW) * 0.5;
    CGFloat bottomLineY = self.frame.size.height - bottomLineH;
    [UIView animateWithDuration:0.25 animations:^(void){
        self.bottomLineView.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    }];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"ShopDetailView layoutSubviews");
    
    CGFloat labelW = self.frame.size.width * 0.5;
    CGFloat labelH = self.frame.size.height;
    self.findLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.detailLabel.frame = CGRectMake(labelW, 0, labelW, labelH);
    
    CGFloat lineH = labelH * 0.5;
    self.middleLineView.frame = CGRectMake(labelW-0.5, (labelH-lineH)*0.5, 1, lineH);
    
    CGFloat bottomLineW = labelW * self.bottomLineScale;
    self.bottomLineView.frame = CGRectMake((labelW-bottomLineW)*0.5, labelH-1.5, bottomLineW, 1.5);
    
    self.blackLineView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.bottomBlackLineView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1);
}
@end
