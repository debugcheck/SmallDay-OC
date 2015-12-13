//
//  ClassifyViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ClassifyViewController.h"
#import "EveryDayModel.h"
#import "ClassifyModel.h"
#import <MJRefresh/MJRefresh.h>
#import "SDRefreshHeader.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"
#import "SearchViewController.h"
#import "CityHeadCollectionReusableView.h"
#import "SVProgressHUD.h"
#import "ClassDetailViewController.h"
#import "ClassifyCell.h"
#import "ClassifyModel.h"
#import "theme.h"

#define SD_RefreshImage_Width 50
#define SD_RefreshImage_Height 40

@interface ClassifyViewController()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView* collView;
@property(nonatomic, strong)NSArray* headTitles;
@property(nonatomic, strong)ClassifyModel* classData;
@end

@implementation ClassifyViewController
- (void) viewDidLoad
{
	[super viewDidLoad];
        
    // 初始化导航条上的内容
    [self setNav];
        
    // 初始化collView
    [self setCollectionView];
       
    // 加载分类数据
    [self.collView.mj_header beginRefreshing];
}

- (void) setNav 
{
    self.navigationItem.title = @"分类";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"search_1" highImageName:@"search_2" target:self action:@selector(searchClick)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void) searchClick 
{
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
    
- (void) setCollectionView 
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat margin = 10;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    CGFloat itemH = 80;
    CGFloat itemW = (AppWidth - 4 * margin) / 3 - 2;
    if(AppWidth > 375) {
        itemW -= 3;
    }
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.headerReferenceSize = CGSizeMake(AppWidth, 50);
        
    self.collView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collView.backgroundColor = SDBackgroundColor;
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.alwaysBounceVertical = YES;
    [self.collView registerClass:[CityHeadCollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [self.collView registerNib:[UINib nibWithNibName:@"ClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"classifyCell"];
    self.collView.showsHorizontalScrollIndicator = NO;
    self.collView.showsVerticalScrollIndicator = NO;
    self.collView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH + 49, 0);
    [self.view addSubview:self.collView];
        
    SDRefreshHeader* diyHeader = [SDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
    diyHeader.lastUpdatedTimeLabel.hidden = YES;
    diyHeader.stateLabel.hidden = YES;
    //diyHeader.gifView.frame = CGRectMake((AppWidth - SD_RefreshImage_Width) * 0.5, 10, SD_RefreshImage_Width, SD_RefreshImage_Height);
    self.collView.mj_header = diyHeader;
}

- (void) loadDatas
{
    __weak ClassifyViewController* tmpSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(){
        [ClassifyModel loadClassifyModel:^(ClassifyModel* data, NSError* error) {
            if(error != nil) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                [tmpSelf.collView.mj_header endRefreshing];
                return;
            }
            tmpSelf.classData = data;
            [tmpSelf.collView.mj_header endRefreshing];
            [tmpSelf.collView reloadData];
        }];
    });
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger) collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((ClassModel*)self.classData.list[section]).tags.count;
}
                                         
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return self.classData.list.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*) indexPath
{
    ClassifyCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifyCell" forIndexPath:indexPath];
    cell.model = ((ClassModel*)self.classData.list[indexPath.section]).tags[indexPath.row];
    return cell;
}
                   
- (UICollectionReusableView*) collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    CityHeadCollectionReusableView* headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
    
    headView.headTitle = ((ClassModel*)self.classData.list[indexPath.section]).title;
    return headView;
}
                                         
- (void) collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    EveryClassModel* every = ((ClassModel*)self.classData.list[indexPath.section]).tags[indexPath.row];
    ClassDetailViewController* detailVC = [[ClassDetailViewController alloc]init];
    detailVC.title = every.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
