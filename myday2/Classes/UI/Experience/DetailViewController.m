//
//  DetailViewController.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "DetailViewController.h"
#import "ShareView.h"
#import "theme.h"
#import "ExperienceWebView.h"
#import "UIImageView+wnxImage.h"
#import "ShareModel.h"
#import "NSString+wnxString.h"
#import "ExploreBottomView.h"
#import "SignUpViewController.h"
#import "BuyDetailViewController.h"
#import "NavigatorViewController.h"

#define DetailViewController_TopImageView_Height 225

@interface DetailViewController ()<UIActionSheetDelegate, UIScrollViewDelegate, UIWebViewDelegate>
@property(nonatomic)BOOL showBlackImage;
@property(nonatomic, strong)NSMutableString* htmlNewString;
@property(nonatomic)CGFloat scrollShowNavH;
@property(nonatomic)CGFloat imageW;
@property(nonatomic, strong)UIButton* signUpBtn;
@property(nonatomic)BOOL isLoadFinish;
@property(nonatomic)BOOL isAddBottomView;
@property(nonatomic)CGFloat loadFinishScrollHeight;
@property(nonatomic, strong)NSMutableArray* bottomViews; //ExploreBottomView;
@property(nonatomic, strong)ShareView* shareView;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UIButton* likeBtn;
@property(nonatomic, strong)UIButton* sharedBtn;
@property(nonatomic, strong)UIWebView* webView;
@property(nonatomic, strong)UIImageView* topImageView;
@property(nonatomic, strong)UIActionSheet* phoneActionSheet;
@property(nonatomic, strong)UIView* customNav;
@end

@implementation DetailViewController
- (id) init
{
    self = [super init];
    self.showBlackImage = NO;
    self.htmlNewString = [[NSMutableString alloc]init];
    self.scrollShowNavH = DetailViewController_TopImageView_Height - NavigationH;
    self.imageW = AppWidth - 23.0;
    self.signUpBtn = [[UIButton alloc]init];
    self.isLoadFinish = NO;
    self.isAddBottomView = NO;
    self.loadFinishScrollHeight = 0;
    self.bottomViews = [[NSMutableArray alloc]init];
    self.shareView = [ShareView shareViewFromXib];
    self.backBtn = [[UIButton alloc]init];
    self.likeBtn= [[UIButton alloc]init];
    self.sharedBtn = [[UIButton alloc]init];
    self.webView = [[ExperienceWebView alloc]initWithFrame:MainBounds webViewDelegate:self webViewScrollViewDelegate:self];
    
    return self;
}

#pragma mark - lazy attributes
- (UIImageView*) topImageView
{
    if(_topImageView == nil) {
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, DetailViewController_TopImageView_Height)];
        _topImageView.image = [UIImage imageNamed:@"quesheng"];
        _topImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _topImageView;
}

- (UIActionSheet*) phoneActionSheet
{
    if(_phoneActionSheet == nil) {
        _phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:self.model.telephone otherButtonTitles:nil];
    }
    return _phoneActionSheet;
}

- (UIView*) customNav
{
    if(_customNav == nil) {
        _customNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, NavigationH)];
        _customNav.backgroundColor = [UIColor whiteColor];
        _customNav.alpha = 0.0;
    }
    return _customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    [self setCustomNavigationItem];
    
    [self setUpBottomView];
}

- (void) setUpBottomView
{
    // 添加底部报名View
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, AppHeight - 49, AppWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.signUpBtn = [[UIButton alloc]init];
    [self.signUpBtn setBackgroundImage:[UIImage imageNamed:@"registration_1"] forState:UIControlStateNormal];
    self.signUpBtn.frame = CGRectMake((AppWidth - 158) * 0.5, (49 - 36) * 0.5, 158, 36);
    [self.signUpBtn setTitle:@"报 名" forState:UIControlStateNormal];
    [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.signUpBtn];
}

- (void) setUpUI
{
    self.view.backgroundColor = SDWebViewBacagroundColor;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.topImageView];
    self.view.clipsToBounds = YES;
}

- (void) setCustomNavigationItem
{
    [self.view addSubview:self.customNav];
    //添加返回按钮
    [self setButton:self.backBtn frame:CGRectMake(-7, 20, 44, 44) imageName:@"back_0" highImageName:@"back_2" action:@selector(backButtonClick)];
    [self.view addSubview:self.backBtn];
    // 添加收藏按钮
    [self setButton:self.likeBtn frame:CGRectMake(AppWidth - 105, 20, 44, 44) imageName:@"collect_0" highImageName:@"collect_0" action:@selector(likeBtnClick)];
    [self.likeBtn setImage:[UIImage imageNamed:@"collect_2"] forState:UIControlStateSelected];
    [self.view addSubview:self.likeBtn];
    // 添加分享按钮
    [self setButton:self.sharedBtn frame:CGRectMake(AppWidth - 54, 20, 44, 44) imageName:@"share_0" highImageName:@"share_2" action:@selector(sharedBtnClick)];
    [self.view addSubview:self.sharedBtn];
}

- (void) setButton:(UIButton*)btn frame:(CGRect)frame imageName:(NSString*)imageName highImageName:(NSString*)highImageName action:(SEL)action
{
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void) setModel:(EventModel*)model
{
    self.webView.hidden = YES;
    NSString* imageStr = [model.imgs lastObject];
    if(imageStr){
        [self.topImageView wxn_setImageWithUrl:[NSURL URLWithString:imageStr] placeholderImage: [UIImage imageNamed:@"quesheng"]];
    }
    self.shareView.shareModel = [[ShareModel alloc]init:model.title shareURL:model.shareURL image:nil shareDetail:model.detail];
    NSString* htmlSrt = model.mobileURL;
    
    if(htmlSrt != nil) {
        NSString* titleStr = nil;
        
        if(model.title != nil) {
            titleStr = [NSString stringWithFormat:@"<p style='font-size:20px;'> %@</p>", model.title];
        }
        
        if(model.tag != nil) {
            titleStr = [titleStr stringByAppendingFormat:@"<p style='font-size:13px; color: gray';>%@</p>", model.tag];
        }
        
        if(titleStr != nil) {
            NSMutableString* newStr = [NSMutableString stringWithString:htmlSrt];
            [newStr insertString:titleStr atIndex:31];
            htmlSrt = newStr;
        }
        
        self.htmlNewString = [NSMutableString changeHeightAndWidthWithString:[NSMutableString stringWithString:htmlSrt]];
    }
    
    [self.webView loadHTMLString:self.htmlNewString baseURL: nil];
    [self.webView.scrollView setContentOffset:CGPointMake(0, -DetailViewController_TopImageView_Height + 20) animated:NO];
    self.webView.hidden = NO;
    
    // 根据模型按条件添加webView底部的view
    if(![model.questionURL isEqual:@""] && model.questionURL != nil) {
        [self.bottomViews addObject:[ExploreBottomView exploreBottomViewFromXibWithTitle:@"价格" subTitle:@"购买须知" target:self action:@selector(priceBottomClick:) showBtn:NO showArror:YES]];
    }
    [self.bottomViews addObject:[ExploreBottomView exploreBottomViewFromXibWithTitle:@"提醒" subTitle:@"每天" target:self action:@selector(remindViewClick:) showBtn:YES showArror:NO]];
    
    if(model.telephone != nil && ![model.telephone isEqual:@""]) {
        [self.bottomViews addObject:[ExploreBottomView exploreBottomViewFromXibWithTitle:@"电话" subTitle:model.telephone target:self action:@selector(telephoneBottomClick:) showBtn:NO showArror:YES]];
    }
    
    if(model.position != nil && [model.position isEqual:@""] && model.address != nil && [model.address isEqual:@""]) {
        [self.bottomViews addObject:[ExploreBottomView exploreBottomViewFromXibWithTitle:@"地址" subTitle:model.address target:self action:@selector(addressBottomClick:) showBtn:NO showArror:YES]];
    }
}

#pragma mark - button action
- (void) priceBottomClick:(UITapGestureRecognizer*)tap
{
    BuyDetailViewController* buyVC = [[BuyDetailViewController alloc]init];
    buyVC.htmlStr = self.model.questionURL;
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (void) remindViewClick:(UITapGestureRecognizer*)tap
{
    NSLog(@"提醒");
}

- (void) telephoneBottomClick:(UITapGestureRecognizer*)tap
{
    [self.phoneActionSheet showInView:self.view];
}

- (void) addressBottomClick:(UITapGestureRecognizer*)tap
{
    NavigatorViewController* navVC = [[NavigatorViewController alloc]init];
    navVC.model = self.model;
    [self.navigationController pushViewController:navVC animated:YES];
}

/// 返回
- (void) backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 收藏
- (void) likeBtnClick
{
    self.likeBtn.selected = !self.likeBtn.selected;
}

/// 分享
- (void) sharedBtnClick
{
    [self.view addSubview:self.shareView];
    self.shareView.shareVC = self;
    [self.shareView showShareView:CGRectMake(0, AppHeight - 215, AppWidth, 215)];
}

/// 报名
- (void) signUpBtnClick
{
    SignUpViewController* suVC = [[SignUpViewController alloc]init];
    [self.navigationController pushViewController:suVC animated: YES];
    suVC.topTitle = self.model.title;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.isLoadFinish && self.isAddBottomView) {
        CGSize size = self.webView.scrollView.contentSize;
        size.height = self.loadFinishScrollHeight;
        self.webView.scrollView.contentSize = size;
    }
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}
#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.model.telephone]];
        [[UIApplication sharedApplication]openURL:url];
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 解决弹出新的控制器后返回后contentSize自动还原的问题
    if(self.loadFinishScrollHeight > self.webView.scrollView.contentSize.height && scrollView == self.webView.scrollView) {
        CGSize size = self.webView.scrollView.contentSize;
        size.height = self.loadFinishScrollHeight;
        self.webView.scrollView.contentSize = size;
    }
    
    // 加标记的作用为了优化性能
    // 判断顶部自定义导航条的透明度,以及图片的切换
    self.customNav.alpha = 1 + (offsetY + NavigationH) / self.scrollShowNavH;
    if(offsetY >= -NavigationH && self.showBlackImage == NO) {
        [self.backBtn setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"collect_1"] forState:UIControlStateNormal];
        [self.sharedBtn setImage:[UIImage imageNamed:@"share_1"] forState:UIControlStateNormal];
        self.showBlackImage = YES;
    } else if(offsetY < -NavigationH && self.showBlackImage == YES) {
        [self.backBtn setImage:[UIImage imageNamed:@"back_0"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"collect_0"] forState:UIControlStateNormal];
        [self.sharedBtn setImage:[UIImage imageNamed:@"share_0"] forState:UIControlStateNormal];
        self.showBlackImage = NO;
    }
    
    // 顶部imageView的跟随动画
    if(offsetY <= -DetailViewController_TopImageView_Height) {
        CGRect frame = self.topImageView.frame;
        frame.origin.y = 0;
        frame.size.height = -offsetY;
        frame.size.width = AppWidth - offsetY - DetailViewController_TopImageView_Height;
        frame.origin.x = (0 + DetailViewController_TopImageView_Height + offsetY) * 0.5;
        self.topImageView.frame = frame;
    } else {
        CGRect frame = self.topImageView.frame;
        frame.origin.y = -offsetY - DetailViewController_TopImageView_Height;
        self.topImageView.frame = frame;
    }
    
    if(self.isLoadFinish && !self.isAddBottomView && scrollView.contentSize.height > AppHeight)  {
        self.isAddBottomView = YES;
        for(ExploreBottomView* bottomView in self.bottomViews) {
            CGFloat bottomViewH = CGRectGetMaxY(bottomView.bottomLineView.frame);
            bottomView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height, AppWidth, bottomViewH);
            [self.webView.scrollView addSubview:bottomView];
            CGSize size = self.webView.scrollView.contentSize;
            size.height += bottomViewH;
            self.webView.scrollView.contentSize = size;
        }
        CGSize size = scrollView.contentSize;
        size.height += 20;
        scrollView.contentSize = size;
        self.loadFinishScrollHeight = scrollView.contentSize.height;
    }

}
#pragma mark - UIWebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F5F5F5';"];
    self.webView.hidden = NO;
    self.isLoadFinish = YES;
}
@end
