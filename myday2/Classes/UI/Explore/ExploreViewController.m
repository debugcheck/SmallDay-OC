//
//  ExploreViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExploreViewController.h"
#import "EventCellTableViewCell.h"
#import "MainTableView.h"
#import "DoubleTextView.h"
#import "EveryDayModel.h"
#import "EventViewController.h"
#import "ThemeViewController.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"
#import <MJRefresh.h>
#import "SDRefreshHeader.h"
#import "ThemeCell.h"
#import "theme.h"
#import "SVProgressHUD.h"

#define SD_RefreshImage_Height 40
#define SD_RefreshImage_Width 35

@interface ExploreViewController()<UITableViewDataSource, UITableViewDelegate, DoubleTextViewDelegate>
@property(nonatomic, strong)UIScrollView* backgroundScrollView;
@property(nonatomic, strong)DoubleTextView* doubleTextView;
@property(nonatomic, strong)EveryDays* everyDays;
@property(nonatomic, strong)MainTableView* albumTableView;
@property(nonatomic, strong)MainTableView* dayTableView;
@property(nonatomic, strong)ThemeModels* themes;
@property(nonatomic, strong)EveryDays* events;
@end

@implementation ExploreViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ExplorViewController viewDidLoad");
    
    // 初始化导航条内容
    [self setNav];
    
    // 设置scrollView
    [self setScrollView];
    
    // 初始化美天tablieView
    [self setdayTableView];
    
    // 初始化美辑tableView
    [self setalbumTableView];
    
    // 下拉加载数据
    [self.dayTableView.mj_header beginRefreshing];
    [self.albumTableView.mj_header beginRefreshing];
}

- (void) setNav
{
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"附近" titleColor:[UIColor blackColor] target:self action:nil];
    
    self.doubleTextView = [[DoubleTextView alloc] initWithLeftText:@"美天" right:@"美辑"];
    self.doubleTextView.frame = CGRectMake(0, 0, 120, 44);
    self.doubleTextView.delegate = self;
    self.navigationItem.titleView = self.doubleTextView;
}

- (void) setScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, AppHeight - NavigationH - 49)];
    self.backgroundScrollView.backgroundColor = SDBackgroundColor;
    self.backgroundScrollView.contentSize = CGSizeMake(AppWidth * 2.0, 0);
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.delegate = self;
    [self.view addSubview:self.backgroundScrollView];
}

- (void) setdayTableView
{
    self.dayTableView = [[MainTableView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, AppHeight - NavigationH) style:UITableViewStyleGrouped dataSource:self delegate:self];
    self.dayTableView.sectionHeaderHeight = 0.1;
    self.dayTableView.sectionFooterHeight = 0.1;
    self.dayTableView.contentInset = UIEdgeInsetsMake(-35, 0, 35, 0);
    [self.backgroundScrollView addSubview:self.dayTableView];
    
    [self setTableViewHeader:self refreshingAction:@selector(pullLoadDayDate) imageFrame:CGRectMake((AppWidth - SD_RefreshImage_Width) * 0.5, 47, SD_RefreshImage_Width, SD_RefreshImage_Height) tableView:self.dayTableView];
}

- (void) setalbumTableView
{
    self.albumTableView = [[MainTableView alloc]initWithFrame:CGRectMake(AppWidth, 0, AppWidth, self.backgroundScrollView.frame.size.height) style:UITableViewStylePlain dataSource:self delegate:self];
    [self.backgroundScrollView addSubview:self.albumTableView];
    
    [self setTableViewHeader:self refreshingAction:@selector(pullLoadAlbumData) imageFrame:CGRectMake((AppWidth - SD_RefreshImage_Width) * 0.5, 10, SD_RefreshImage_Width, SD_RefreshImage_Height) tableView:self.albumTableView];
}

- (void) setTableViewHeader:(NSObject*)refreshingTarget refreshingAction:(SEL)refreshingAction imageFrame:(CGRect)imageFrame tableView:(UITableView*)tableView
{
    SDRefreshHeader* header = [SDRefreshHeader headerWithRefreshingTarget:refreshingTarget refreshingAction:refreshingAction];
    //TODO header position frame
    tableView.mj_header = header;
}

- (void) pullLoadDayDate {
    __weak __typeof(&*self) tmpSelf = self;
    // 模拟延时加载
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [EveryDays loadEventsData:^(EveryDays* data, NSError* error){
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
                [tmpSelf.dayTableView.mj_header endRefreshing];
                return;
            } else {
                [SVProgressHUD showInfoWithStatus:@"加载成功"];
            }
            
            tmpSelf.everyDays = data;
            [tmpSelf.dayTableView reloadData];
            [tmpSelf.dayTableView.mj_header endRefreshing];
        }];
    });
}


- (void) pullLoadAlbumData
{
    __weak ExploreViewController* tmpSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^() {
        [ThemeModels loadThemesData:^(ThemeModels* data, NSError* error) {
            if(error != nil) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                [tmpSelf.albumTableView.mj_header endRefreshing];
                return;
            }
            tmpSelf.themes = data;
            [tmpSelf.albumTableView reloadData];
            [tmpSelf.albumTableView.mj_header endRefreshing];
        }];
    });
}

/// 附近action
- (void) nearClick
{
    NSLog(@"nearClick");
    //NearViewController* nearVC = [[NearViewController alloc]init];
    //[self.navigationController pushViewController:nearVC animated:YES];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.albumTableView) {
        if(self.themes && self.themes.list) {
            return self.themes.list.count;
        } else {
            return 0;
        }
    } else {
        EveryDay *event = self.everyDays.list[section];
        if([event.themes lastObject]) {
            return 2;
        }
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.albumTableView) {
        return 240;
    } else {
        if(indexPath.row == 1) {
            return 220;
        } else {
            return 253;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.albumTableView) {
        return 1;
    } else {
        return self.everyDays.list.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(tableView == self.albumTableView) {  // 美辑TableView
        ThemeModel* theme = self.themes.list[indexPath.row];
        cell = [ThemeCell themeCellWithTableView:tableView];
        ((ThemeCell*)cell).model = theme;
    } else {    // 美天TableView
        EveryDay* event = self.everyDays.list[indexPath.section];
        
        if(indexPath.row == 1) {
            cell = [ThemeCell themeCellWithTableView:tableView];
            ((ThemeCell*)cell).model = [event.themes lastObject];
        } else {
            cell = [EventCellTableViewCell eventCell:tableView];
            ((EventCellTableViewCell*)cell).eventModel = event;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击的themeCell，美辑cell
    if(tableView == self.albumTableView) {
        ThemeModel *theme = (ThemeModel*)self.themes.list[indexPath.row];
        ThemeViewController* themeVC = [[ThemeViewController alloc]init];
        themeVC.themeModel = theme;
        [self.navigationController pushViewController:themeVC animated:YES];
    } else { //点击的美天TableView里的美辑cell
        EventModel* event = (EventModel*)self.everyDays.list[indexPath.section];
        if(indexPath.row == 1) {
            ThemeViewController* themeVC = [[ThemeViewController alloc]init];
            themeVC.themeModel = (ThemeModel*)[event.themes lastObject];
            [self.navigationController pushViewController:themeVC animated:YES];
            
        } else {//点击的美天的cell
            EventViewController* eventVC = [[EventViewController alloc]init];
            eventVC.model = (EventModel*)event.events[indexPath.row];
            [self.navigationController pushViewController:eventVC animated:YES];
        }
    }
}

#pragma mark - DoubleTextViewDelegate
- (void) doubleTextView:(DoubleTextView *)doubleTextView didClickBtn:(UIButton *)btn forIndex:(NSInteger)index
{
    [self.backgroundScrollView setContentOffset:CGPointMake(AppWidth * index, 0) animated:YES];
}
@end
