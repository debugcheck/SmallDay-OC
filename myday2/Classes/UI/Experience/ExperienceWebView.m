//
//  ExperienceWebView.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperienceWebView.h"
#import "theme.h"

#define DetailViewController_TopImageView_Height 225

@implementation ExperienceWebView
- (id) initWithFrame:(CGRect)frame webViewDelegate:(id<UIWebViewDelegate>)webDelegate webViewScrollViewDelegate:(id<UIScrollViewDelegate>)scrollDelegate
{
    self = [super initWithFrame:frame];
    
    CGFloat contentH = DetailViewController_TopImageView_Height - 20;
    self.scrollView.contentInset = UIEdgeInsetsMake(contentH, 0, 49, 0);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.delegate = webDelegate;
    self.scrollView.delegate = scrollDelegate;
    self.backgroundColor = SDWebViewBacagroundColor;
    CGSize size = self.scrollView.contentSize;
    size.width = AppWidth;
    self.scrollView.contentSize = size;
    self.paginationBreakingMode = UIWebPaginationBreakingModeColumn;
    
    return self;
}

@end
