//
//  EventViewController.m
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "EventViewController.h"
#import "LoadAnimatImageView.h"
#import "GuessLikeView.h"
#import "MoreView.h"
#import "EventWebView.h"
#import "ShareView.h"
#import "ShopDetailView.h"
#import "ShopDetailContentView.h"
#import "theme.h"
#import "UIImageView+wnxImage.h"
#import "NSString+wnxString.h"
#import "NavigatorViewController.h"
#import "ShopDetailContentView.h"

#define DetailViewController_TopImageView_Height 225
#define EventViewController_ShopView_Height 45

@interface EventViewController() <UIScrollViewDelegate, UIWebViewDelegate, ShopDetailViewDelegate>
@property(nonatomic, strong)LoadAnimatImageView* loadImage;
@property(nonatomic)CGFloat imageW;
@property(nonatomic)CGFloat scrollShowNavH;
@property(nonatomic)BOOL showBlackImage;
@property(nonatomic)BOOL isLoadFinish;
@property(nonatomic)BOOL isAddBottomView;
@property(nonatomic)CGFloat loadFinishScrollHeight;
@property(nonatomic, strong)GuessLikeView* guessLikeView;
@property(nonatomic, strong)NSMutableArray* moreArr;       //MoreView
@property(nonatomic, strong)ShareView* shareView;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UIButton* likeBtn;
@property(nonatomic, strong)UIButton* sharedBtn;
@property(nonatomic, strong)EventWebView* webView;
@property(nonatomic, strong)ShopDetailContentView* detailContentView;
@property(nonatomic)CGFloat lastOffsetY;
@property(nonatomic, strong)UIView* customNav;
@property(nonatomic, strong)UIImageView* topImageView;
@property(nonatomic, strong)ShopDetailView* shopView;
@property(nonatomic, strong)UIScrollView* detailSV;
@end

@implementation EventViewController
- (id) init
{
    self = [super init];
    NSLog(@"EventViewController init");
    self.loadImage = [LoadAnimatImageView sharedInstance];
    self.imageW = AppWidth - 23.0;
    self.scrollShowNavH = DetailViewController_TopImageView_Height - NavigationH;
    self.showBlackImage = NO;
    self.isLoadFinish = NO;
    self.isAddBottomView = NO;
    self.loadFinishScrollHeight = 0;
    self.guessLikeView = [GuessLikeView guessLikeViewFromXib];
    self.moreArr = [[NSMutableArray alloc]init];   //MoreView
    self.shareView = [ShareView shareViewFromXib];
    self.backBtn = [[UIButton alloc]init];
    self.likeBtn = [[UIButton alloc]init];
    self.sharedBtn = [[UIButton alloc]init];
    self.webView = [[EventWebView alloc]init:MainBounds webViewDelegate:self webViewScrollViewDelegate:self];
    self.detailContentView = [ShopDetailContentView shopDetailContentViewFromXib];
    self.lastOffsetY = 0;
    
    self.customNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, NavigationH)];
    self.customNav.backgroundColor = [UIColor whiteColor];
    self.customNav.alpha = 0.0;
    
    self.topImageView = [[UIImageView alloc]init];
    
    self.shopView = [[ShopDetailView alloc]initWithFrame:CGRectMake(0, DetailViewController_TopImageView_Height, AppWidth, EventViewController_ShopView_Height)];
    self.shopView.delegate = self;
    
    self.detailSV = [[UIScrollView alloc]initWithFrame:MainBounds];
    self.detailSV.contentInset = UIEdgeInsetsMake(DetailViewController_TopImageView_Height + EventViewController_ShopView_Height, 0, 0, 0);
    self.detailSV.showsHorizontalScrollIndicator = NO;
    self.detailSV.backgroundColor = SDWebViewBacagroundColor;
    self.detailSV.alwaysBounceVertical = YES;
    self.detailSV.hidden = YES;
    self.detailSV.delegate = self;
    [self.detailSV setContentOffset:CGPointMake(0, -(DetailViewController_TopImageView_Height + EventViewController_ShopView_Height)) animated:YES];
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self setCustomNavigationItem];
}

- (void) setUpUI
{
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = SDWebViewBacagroundColor;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.detailSV];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.shopView];
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
    //TODO: 将设置模型数据的代码封装到模型的方法里
    [self.loadImage startLoadAnimatImageViewInView:self.view center:self.view.center];
    self.webView.hidden = YES;
    // 将模型传入给店铺详情页
    self.detailContentView.detailModel = model;
    // 设置地图按钮点击回调闭包
    __weak EventViewController* tmpSelf = self;
    
    self.detailContentView.mapBtnClickCallback = ^(){
        NavigatorViewController* navVC = [[NavigatorViewController alloc]init];
        navVC.model = tmpSelf.model;
        [tmpSelf.navigationController pushViewController:navVC animated:YES];
    };
    
    [self.detailSV addSubview:self.detailContentView];
    self.detailSV.contentSize = CGSizeMake(AppWidth, self.detailContentView.frame.size.height - EventViewController_ShopView_Height);
    
    NSString* imageStr = [model.imgs lastObject];
    if(imageStr) {
        [self.topImageView wxn_setImageWithUrl:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"quesheng"]];
    }
    self.shareView.shareModel = [[ShareModel alloc]init:model.title shareURL:model.shareURL image:nil shareDetail:model.detail];
    NSString* htmlStr = model.mobileURL;
    
    if(htmlStr != nil) {
        NSString* titleStr = nil;
        
        if(model.title != nil) {
            titleStr = [NSString stringWithFormat:@"<p style='font-size:20px;'> %@</p>", model.title];
        }
        
        if(model.tag != nil) {
            titleStr = [titleStr stringByAppendingFormat:@"<p style='font-size:13px; color: gray';>%@</p>", model.tag];
        }
        
        if(titleStr != nil) {
            NSMutableString* newStr = [[NSMutableString alloc] initWithString:htmlStr];
            [newStr insertString:titleStr atIndex:31];
            htmlStr = newStr;
        }
    }
    
    NSString* newStr = [NSMutableString changeHeightAndWidthWithString:[NSMutableString stringWithString:htmlStr]];
    [self.webView loadHTMLString:newStr baseURL:nil];
    self.webView.hidden = NO;
    
    if(model.more.count > 0) {
        self.guessLikeView.hidden = YES;
        [self.webView.scrollView addSubview:self.guessLikeView];
        for(NSInteger i = 0; i < model.more.count; i++) {
            GuessLikeModel* moreModel = model.more[i];
            MoreView* moreView = [MoreView moreViewWithGuessLikeModel:moreModel];
            moreView.hidden = YES;
            moreView.frame = CGRectMake(0, self.webView.scrollView.contentSize.height, AppWidth, 0);
            [self.webView.scrollView addSubview:moreView];
            [self.moreArr addObject:moreView];
        }
    }
    
    [self.loadImage stopLoadAnimatImageView];
}

- (UIImageView*) getTopImageView
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, DetailViewController_TopImageView_Height)];
    imageView.image = [UIImage imageNamed:@"quesheng"];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

#pragma mark button action
- (void) backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) likeBtnClick
{
    self.likeBtn.selected = !self.likeBtn.selected;
}

- (void) sharedBtnClick
{
    [self.view addSubview:self.shareView];
    self.shareView.shareVC = self;
    [self.shareView showShareView:CGRectMake(0, AppHeight - 215, AppWidth, 215)];
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

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"EventViewController scrollViewDidScroll");
    // 解决弹出新的控制器后返回后contentSize自动还原的问题
    if(self.loadFinishScrollHeight > self.webView.scrollView.contentSize.height && scrollView == self.webView.scrollView) {
        CGSize size = self.webView.scrollView.contentSize;
        size.height = self.loadFinishScrollHeight;
        self.webView.scrollView.contentSize = size;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 判断顶部自定义导航条的透明度,以及图片的切换
    self.customNav.alpha = 1 + (offsetY + NavigationH + EventViewController_ShopView_Height) / self.scrollShowNavH;
    if(offsetY + EventViewController_ShopView_Height >= -NavigationH && self.showBlackImage == NO) {
        [self.backBtn setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"collect_1"] forState:UIControlStateNormal];
        [self.sharedBtn setImage:[UIImage imageNamed:@"share_1"] forState:UIControlStateNormal];
        self.showBlackImage = YES;
    } else if( offsetY < -NavigationH - EventViewController_ShopView_Height && self.showBlackImage == YES) {
        [self.backBtn setImage:[UIImage imageNamed:@"back_0"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"collect_0"] forState:UIControlStateNormal];
        [self.sharedBtn setImage:[UIImage imageNamed:@"share_0"] forState:UIControlStateNormal];
        self.showBlackImage = NO;
    }
    
    // 顶部imageView的跟随动画
    if(offsetY <= -DetailViewController_TopImageView_Height - EventViewController_ShopView_Height) {
        CGRect temp = self.topImageView.frame;
        temp.origin.y = 0;
        temp.size.height = -offsetY - EventViewController_ShopView_Height;
        temp.size.width = AppWidth - offsetY - DetailViewController_TopImageView_Height;
        temp.origin.x= (0+DetailViewController_TopImageView_Height+offsetY)*0.5;
        self.topImageView.frame = temp;
    } else {
        CGRect temp = self.topImageView.frame;
        temp.origin.y = -offsetY - DetailViewController_TopImageView_Height - EventViewController_ShopView_Height;
        self.topImageView.frame = temp;
    }
    
    // 处理shopView
    if(offsetY >= -(EventViewController_ShopView_Height + NavigationH)) {
        self.shopView.frame = CGRectMake(0, NavigationH, AppWidth, EventViewController_ShopView_Height);
    } else {
        self.shopView.frame = CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), AppWidth, EventViewController_ShopView_Height);
    }
    
    // 记录scrollView最后的偏移量,用于切换scrollView时同步俩个scrollView的偏移值
    self.lastOffsetY = offsetY;
}

#pragma mark - UIWebViewDelegate
- (void) webViewDidFinishLoad:(UIWebView*)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F5F5F5';"];
    self.isLoadFinish = YES;
    self.guessLikeView.frame = CGRectMake(0, webView.scrollView.contentSize.height, AppWidth, 50);
    self.guessLikeView.hidden = NO;
    CGSize scrollSize = webView.scrollView.contentSize;
    scrollSize.height += 50;
    self.webView.scrollView.contentSize = scrollSize;
    for (MoreView* more in self.moreArr) {
        more.frame = CGRectMake(0, webView.scrollView.contentSize.height, AppWidth, 230);
        more.hidden = NO;
        CGSize scrollSize = webView.scrollView.contentSize;
        scrollSize.height += 235;
        webView.scrollView.contentSize = scrollSize;
        self.isAddBottomView = YES;
    }
    self.loadFinishScrollHeight = webView.scrollView.contentSize.height;
}

#pragma mark - ShopDetailViewDelegate
- (void) shopDetailView:(ShopDetailView *)shopDetailView didSelectedLableAtIndex:(NSInteger)index
{
    NSLog(@"EventViewController ShopDetailViewDelegate");
    if(index == 0) {
        self.detailSV.hidden = YES;
        self.webView.hidden = NO;
        if(self.lastOffsetY > self.webView.scrollView.contentSize.height + AppHeight) {
            [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height) animated:NO];
        } else {
            [self.webView.scrollView setContentOffset:CGPointMake(0, self.lastOffsetY) animated:NO];
        }
    } else {
        self.detailSV.hidden = NO;
        self.webView.hidden = YES;
        if(self.lastOffsetY > self.detailSV.contentSize.height - AppHeight) {
            [self.detailSV setContentOffset:CGPointMake(0, self.detailSV.contentSize.height - AppHeight) animated:NO];
        } else {
            [self.detailSV setContentOffset:CGPointMake(0, self.lastOffsetY) animated:NO];
        }
    }
}
@end
