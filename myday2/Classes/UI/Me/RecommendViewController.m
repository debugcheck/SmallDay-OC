//
//  RecommendViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "RecommendViewController.h"
#import "LoadAnimatImageView.h"
#import "theme.h"

@interface RecommendViewController () <UIWebViewDelegate>
@property(nonatomic, strong)UIWebView* webView;
@property(nonatomic, strong)LoadAnimatImageView* loadAnimateIV;
@end

@implementation RecommendViewController

#pragma mark - lazy attributes
- (UIWebView*) webView
{
    if(_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:MainBounds];
        NSURL* url = [NSURL URLWithString:@"http://www.jianshu.com/users/5fe7513c7a57/latest_articles"];
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
        _webView.delegate = self;
    }
    return _webView;
}

- (LoadAnimatImageView*) loadAnimateIV
{
    if(_loadAnimateIV == nil) {
        _loadAnimateIV = [LoadAnimatImageView sharedInstance];
    }
    return _loadAnimateIV;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"应用推荐";
    self.view.backgroundColor = SDWebViewBacagroundColor;
    [self.view addSubview:self.webView];
}


#pragma mark - UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView*)webView
{
    [self.loadAnimateIV startLoadAnimatImageViewInView:self.view center:self.view.center];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView
{
    [self.loadAnimateIV stopLoadAnimatImageView];
}

@end
