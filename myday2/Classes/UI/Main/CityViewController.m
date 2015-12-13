//
//  CityViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "CityViewController.h"
#import "CityCollectionViewCell.h"
#import "CityHeadCollectionReusableView.h"
#import "theme.h"

#define SD_Current_SelectedCity @"SD_Current_SelectedCity"
#define SD_CurrentCityChange_Notification @"SD_CurrentCityChange_Notification"

@interface CityViewController() <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView* collView;
@property(nonatomic, strong)UICollectionViewFlowLayout* layout;
@property(nonatomic, strong)NSMutableArray* domesticCitys;
@property(nonatomic, strong)NSMutableArray* overseasCitys;
@end

@implementation CityViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.domesticCitys = [[NSMutableArray alloc]initWithObjects:@"北京", @"上海", @"成都", @"广州", @"杭州", @"西安", @"重庆", @"厦门", @"台北", nil];
    self.overseasCitys = [[NSMutableArray alloc] initWithObjects:@"罗马", @"迪拜", @"里斯本", @"巴黎", @"柏林", @"伦敦", nil];
    
    [self setNav];
    [self setCollectionView];
    
    NSIndexPath* lastSelectedCityIndexPath = [self selectedCurrentCity];
    [self.collView selectItemAtIndexPath:lastSelectedCityIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void) setNav {
    [self.view setBackgroundColor:SDBackgroundColor];
    [self.navigationItem setTitle:@"选择城市"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}

- (void) setCollectionView {
    //设置布局
    CGFloat itemW = AppWidth / 3.0 - 1.0;
    CGFloat itemH = 50;
    self.layout.itemSize = CGSizeMake(itemW, itemH);
    self.layout.minimumLineSpacing = 1;
    self.layout.minimumInteritemSpacing = 1;
    self.layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 60);
    
    //设置collectionView
    self.collView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    [self.collView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collView setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247 alpha:1]];
    [self.collView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.collView registerClass:[CityHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [self.collView registerClass:[CityFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    self.collView.alwaysBounceVertical = YES;
    
    [self.view addSubview:self.collView];
}

- (NSIndexPath*) selectedCurrentCity {
    NSString* currentCityName = self.cityName;
    if(self.cityName) {
        for( NSInteger i = 0; i < self.domesticCitys.count; i++) {
            if([currentCityName isEqual:(NSString*)self.domesticCitys[i]] ) {
                return [NSIndexPath indexPathForItem:i inSection:0];
            }
        }
        for(NSInteger i = 0; i < self.overseasCitys.count; i++) {
            if([currentCityName isEqual:(NSString*)self.overseasCitys[i]]) {
                return [NSIndexPath indexPathForItem:i inSection:1];
            }
        }
    }
    
    return [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void) cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0) {
        return self.domesticCitys.count;
    } else {
        return self.overseasCitys.count;
    }
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityCollectionViewCell* cell = (CityCollectionViewCell*)[self.collView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if(indexPath.section == 0) {
        cell.cityName = (NSString*)[self.domesticCitys objectAtIndex:indexPath.row];
    } else {
        cell.cityName = (NSString*)[self.overseasCitys objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionFooter && indexPath.section == 1) {
        CityFootCollectionReusableView* footView = (CityFootCollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        
        CGRect temp = footView.frame;
        temp.size.height = 80;
        footView.frame = temp;
        return footView;
    }
    
    CityHeadCollectionReusableView* headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        headView.headTitle = @"国内城市";
    } else {
        headView.headTitle = @"国外城市";
    }
    return headView;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 拿出当前选择的cell
    CityCollectionViewCell* cell = (CityCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString* currentCity = cell.cityName;
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setObject:currentCity forKey: SD_Current_SelectedCity];
    if([user synchronize]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SD_CurrentCityChange_Notification object: currentCity];
        [self dismissViewControllerAnimated:YES completion: nil];
    }
}

/// 这方法是UICollectionViewDelegateFlowLayout 协议里面的， 我现在是 默认的flow layout， 没有自定义layout，所以就没有实现UICollectionViewDelegateFlowLayout协议,需要完全手敲出来方法,对应的也有设置header的尺寸方法
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    if(section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(self.view.frame.size.width, 120);
    }
}
@end
