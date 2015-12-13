//
//  ThemeViewController.m
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ThemeViewController.h"
#import "MainTableView.h"
#import "ShareModel.h"
#import "ShareView.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"
#import "EveryDayModel.h"
#import "theme.h"
#import "ClassifyModel.h"
#import "SVProgressHUD.h"
#import "DetailCell.h"
#import "EventViewController.h"

#define SD_DetailCell_Identifier @"DetailCell"
#define DetailCellHeight 220

@interface ThemeViewController() <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)DetailModel* more;
@property(nonatomic, strong)UIView* backView;
@property(nonatomic, strong)MainTableView* moreTableView;
@property(nonatomic, strong)ShareView* shareView;
@property(nonatomic, strong)UIWebView* webView;
@property(nonatomic, strong)UIButton* modalBtn;

@end

@implementation ThemeViewController
- (void) setThemeModel:(ThemeModel*)themeModle
{
    if(themeModle.hasweb == 1) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:themeModle.themeurl]]];
        self.shareView.shareModel = [[ShareModel alloc]init:self.themeModel.title shareURL:self.themeModel.themeurl image:nil shareDetail:self.themeModel.text];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self loadMore];
    [self addModalBtn];
}

- (UIView*) backView
{
    if(_backView == nil) {
        NSLog(@"ThemeViewController get backView");
        _backView = [[UIView alloc]initWithFrame:MainBounds];
        _backView.backgroundColor = SDBackgroundColor;
    }
    return _backView;
}

- (MainTableView*) moreTableView
{
    if(_moreTableView == nil) {
        NSLog(@"ThemeViewController get moreTableView");
        _moreTableView = [[MainTableView alloc]initWithFrame:MainBounds style:UITableViewStylePlain dataSource:self delegate:self];
        _moreTableView.rowHeight = DetailCellHeight;
        _moreTableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0);
        [_moreTableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:SD_DetailCell_Identifier];
    }
    return _moreTableView;
}

- (ShareView*) shareView
{
    if(_shareView == nil) {
        NSLog(@"ThemeViewController get shareView");
        _shareView = [ShareView shareViewFromXib];
    }
    
    return _shareView;
}

- (UIWebView*) webView
{
    if(_webView == nil) {
        NSLog(@"ThemeViewController get webView");
        _webView = [[UIWebView alloc]initWithFrame:MainBounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
    }
    
    return _webView;
}

- (void) setUpUI
{
    NSLog(@"ThemeViewController setUpUI");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.moreTableView];
    [self.backView addSubview:self.webView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImageName:@"share_1" highImageName:@"share_2" target:self action:@selector(shareClick)];
}

- (void) loadMore
{
    __weak ThemeViewController* tempSelf = self;
    [DetailModel loadMore:^(DetailModel* data, NSError* error){
        if(error != nil) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            return;
        }
        tempSelf.more = data;
        [tempSelf.moreTableView reloadData];
    }];
}
- (void) addModalBtn
{
    CGFloat modalWH = NavigationH;
    self.modalBtn = [[UIButton alloc]init];
    self.modalBtn.frame = CGRectMake(10, AppHeight - modalWH - 10 - NavigationH, modalWH, modalWH);
    [self.modalBtn setImage:[UIImage imageNamed:@"themelist"] forState:UIControlStateNormal];
    [self.modalBtn setImage:[UIImage imageNamed:@"themeweb"] forState:UIControlStateSelected];
    [self.modalBtn addTarget:self action:@selector(modalClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modalBtn];
}

#pragma button action
- (void) shareClick
{
    NSLog(@"ThemeViewController shareClick");
    [self.view addSubview:self.shareView];
    [self.shareView showShareView:CGRectMake(0, AppHeight-215-64, AppWidth, 215)];
    self.shareView.shareVC = self;
}

- (void) modalClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if(sender.selected) {
        [UIView transitionFromView:self.webView toView:self.moreTableView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
    } else {
        [UIView transitionFromView:self.moreTableView toView:self.webView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    }
}

#pragma WebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.modalBtn.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.modalBtn.hidden = YES;
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.more.list.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell* cell = (DetailCell*)[tableView dequeueReusableCellWithIdentifier:SD_DetailCell_Identifier];
    EventModel* everyModel = (EventModel*)self.more.list[indexPath.row];
    cell.model = everyModel;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventModel* model = (EventModel*)self.more.list[indexPath.row];
    EventViewController* eventVC = [[EventViewController alloc]init];
    eventVC.model = model;
    [self.navigationController pushViewController:eventVC animated:YES];
}
@end
