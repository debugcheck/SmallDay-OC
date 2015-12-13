//
//  ExperHeadPushViewController.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperHeadPushViewController.h"
#import "LoadAnimatImageView.h"
#import "ShareView.h"
#import "theme.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"

@interface ExperHeadPushViewController () <UIWebViewDelegate>
@property(nonatomic, strong)UIWebView* webView;
@property(nonatomic, strong)LoadAnimatImageView* loadImage;
@property(nonatomic, strong)ShareView* shareView;
@end

@implementation ExperHeadPushViewController

- (void) setModel:(ExperienceHeadModel *)model
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.mobileURL]]];
    self.navigationItem.title = model.title;
    self.shareView.shareModel = [[ShareModel alloc] init:model.title shareURL:model.shareURL image: nil shareDetail:model.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackgroundColor;
    [self.view addSubview:self.webView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImageName:@"share_1" highImageName:@"share_2" target:self action:@selector(sharedClick)];
}

- (UIWebView*) webView
{
    if(_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:MainBounds];
        _webView.delegate = self;
        _webView.backgroundColor = SDBackgroundColor;
        _webView.hidden = YES;
    }
    return _webView;
}

- (ShareView*) shareView
{
    if(_shareView == nil) {
        _shareView = [ShareView shareViewFromXib];
    }
    return _shareView;
}

- (LoadAnimatImageView*) loadImage
{
    if(_loadImage == nil) {
        _loadImage = [LoadAnimatImageView sharedInstance];
    }
    return _loadImage;
}


#pragma mark - button action
- (void) sharedClick
{
    [self.view addSubview:self.shareView];
    self.shareView.shareVC = self;
    [self.shareView showShareView:CGRectMake(0, AppHeight - 215 - NavigationH, AppWidth, 215)];
}

#pragma mark - UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadImage startLoadAnimatImageViewInView:self.view center:self.view.center];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.hidden = NO;
    [self.loadImage stopLoadAnimatImageView];
    CGSize size = self.webView.scrollView.contentSize;
    size.height += NavigationH;
    self.webView.scrollView.contentSize = size;
}
@end
