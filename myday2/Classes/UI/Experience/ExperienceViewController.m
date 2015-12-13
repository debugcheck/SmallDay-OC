//
//  ExperienceViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperienceViewController.h"
#import "MainTableView.h"
#import "ExperHeadView.h"
#import "ExperienceCell.h"
#import "MainTableView.h"
#import <MJRefresh.h>
#import "theme.h"
#import "SDRefreshHeader.h"
#import "ExperHeadPushViewController.h"
#import "DetailViewController.h"

#define cellIdentifier @"experienceCell"

@interface ExperienceViewController() <UITableViewDataSource, UITableViewDelegate, ExperHeadViewDelegate>
@property(nonatomic, strong)MainTableView* tableView;
@property(nonatomic, strong)ExperHeadView* headView;
@end

@implementation ExperienceViewController
- (void) setExperModel:(ExperienceModel *)experModel
{
    self.headView.experModel = experModel;
    _experModel = experModel;
}

- (MainTableView*) tableView
{
    if(_tableView == nil) {
        _tableView = [[MainTableView alloc]initWithFrame:MainBounds style:UITableViewStylePlain dataSource:self delegate:self];
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH + 49, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"ExperienceCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        SDRefreshHeader* diyHeader = [SDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDatas)];
        diyHeader.lastUpdatedTimeLabel.hidden = YES;
        diyHeader.stateLabel.hidden = YES;
        //diyHeader.gifView!.frame = CGRectMake((AppWidth - SD_RefreshImage_Width) * 0.5, 10, SD_RefreshImage_Width, SD_RefreshImage_Height)
        _tableView.mj_header = diyHeader;
    }
    return _tableView;
}

- (ExperHeadView*) headView
{
    if(_headView == nil) {
        _headView = [[ExperHeadView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, 170)];
        _headView.delegate = self;
    }
    return _headView;
}

- (void) setTableView
{
    self.headView.experModel = self.experModel;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.title = @"体验";
    [self.tableView.mj_header beginRefreshing];
    [self setTableView];
}

- (void) loadDatas
{
    __weak ExperienceViewController* tmpSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(){
        [ExperienceModel loadExperienceModel:^(ExperienceModel* data, NSError* error){
            if(error != nil) {
                [tmpSelf.tableView.mj_header endRefreshing];
                return ;
            }
            tmpSelf.experModel = data;
            [tmpSelf.tableView.mj_header endRefreshing];
            [tmpSelf.tableView reloadData];
        }];
    });
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.experModel.list.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExperienceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EventModel* eventModel = self.experModel.list[indexPath.row];
    cell.eventModel = eventModel;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController* detailVC = [[DetailViewController alloc]init];
    EventModel* eventModel = self.experModel.list[indexPath.row];
    detailVC.model = eventModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ExperHeadViewDelegate
- (void) experHeadView:(ExperHeadView*)headView didClickImageViewAtIndex:(NSInteger)index
{
    ExperienceHeadModel* headModel = self.experModel.head[index];
    ExperHeadPushViewController* pushVC = [[ExperHeadPushViewController alloc]init];
    pushVC.model = headModel;
    [self.navigationController pushViewController:pushVC animated:YES];
}
@end
