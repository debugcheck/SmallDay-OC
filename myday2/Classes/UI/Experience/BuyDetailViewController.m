//
//  BuyDetailViewController.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "NSString+wnxString.h"
#import "theme.h"

@interface BuyDetailViewController ()
@property(nonatomic, strong)UIWebView* webView;
@end

@implementation BuyDetailViewController
#pragma mark - lazy attributes
- (UIWebView*) webView
{
    if(_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, AppHeight - NavigationH)];
        _webView.backgroundColor = SDBackgroundColor;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

- (void) setHtmlStr:(NSString*)htmlStr
{
    NSString* newStr = [NSMutableString changeHeightAndWidthWithString:[NSMutableString stringWithString:htmlStr]];
    [self.webView loadHTMLString:newStr baseURL:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买须知";
    
    [self.view addSubview:self.webView];
}


@end
