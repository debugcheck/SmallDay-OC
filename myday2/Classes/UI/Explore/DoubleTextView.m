//
//  DoubleTextView.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "DoubleTextView.h"
#import "theme.h"

@class NoHighlightButton;

@interface DoubleTextView()
@property(nonatomic, strong)NoHighlightButton* leftTextButton;
@property(nonatomic, strong)NoHighlightButton* rightTextButton;
@property(nonatomic, strong)UIColor* textColorForNormal;
@property(nonatomic, strong)UIFont* textFont;
@property(nonatomic, strong)UIView* bottomLineView;
@property(nonatomic, strong)UIButton* selectedBtn;
@end

@implementation DoubleTextView
- (id) initWithLeftText:(NSString*)leftText right:(NSString*)rightText
{
    self = [super init];
    self.textColorForNormal = [UIColor colorWithRed:100/255 green:100/255 blue:100/255 alpha:1];
    self.textFont = SDNavTitleFont;
    self.bottomLineView = [[UIView alloc]init];
    self.leftTextButton = [[NoHighlightButton alloc]init];
    self.rightTextButton = [[NoHighlightButton alloc]init];
    
    [self setButton:self.leftTextButton title:leftText tag:100];
    [self setButton:self.rightTextButton title:rightText tag:101];
    [self setBottomLineView];
    
    [self titleButtonClick:self.leftTextButton];
    
    return self;
}

- (void) setButton:(UIButton*)button title:(NSString*)title tag:(NSInteger)tag
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:self.textColorForNormal forState:UIControlStateNormal];
    button.titleLabel.font = self.textFont;
    button.tag = tag;
    [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [self addSubview:button];
}

- (void) setBottomLineView
{
    self.bottomLineView.backgroundColor = [UIColor colorWithRed:60/255 green:60/255 blue:60/255 alpha:1];
    [self addSubview:self.bottomLineView];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.frame.size.width * 0.5;
    self.leftTextButton.frame = CGRectMake(0, 0, btnW, self.frame.size.height);
    self.rightTextButton.frame = CGRectMake(btnW, 0, btnW, self.frame.size.height);
    self.bottomLineView.frame = CGRectMake(0, self.frame.size.height-2, btnW, 2);
}

- (void) titleButtonClick:(UIButton*)sender
{
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    [self bottomViewScrollTo:(sender.tag - 100)];
    if(self.delegate) {
        [self.delegate doubleTextView:self didClickBtn:sender forIndex:(sender.tag -100)];
    }
}

- (void) bottomViewScrollTo:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect temp = self.bottomLineView.frame;
        temp.origin.x = (float)index * self.bottomLineView.frame.size.width;
        self.bottomLineView.frame = temp;
    }];
}

- (void) clickBtnToIndex:(NSInteger)index
{
    NoHighlightButton* btn = (NoHighlightButton*)[self viewWithTag:index+100];
    [self titleButtonClick:btn];
}
@end


@implementation NoHighlightButton
- (BOOL) isHighlighted
{
    //[super setHighlighted:NO];
    return NO;
}
@end