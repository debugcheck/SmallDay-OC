//
//  EventWebView.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "EventWebView.h"
#import "theme.h"

#define DetailViewController_TopImageView_Height 225
#define EventViewController_ShopView_Height 45

@implementation EventWebView
- (id) init:(CGRect)rect webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate webViewScrollViewDelegate:(id<UIScrollViewDelegate>)webViewScrollViewDelegate
{
    self = [super initWithFrame:rect];
    
    CGFloat topImageShopViewHeight = DetailViewController_TopImageView_Height - 20 + EventViewController_ShopView_Height;
    self.scrollView.contentInset = UIEdgeInsetsMake(topImageShopViewHeight, 0, 0, 0);
    [self.scrollView setContentOffset:CGPointMake(0, -topImageShopViewHeight) animated:NO];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = webViewScrollViewDelegate;
    self.delegate = webViewDelegate;
    self.backgroundColor = SDWebViewBacagroundColor;
    self.paginationBreakingMode = UIWebPaginationBreakingModeColumn;
    return self;
}
@end
