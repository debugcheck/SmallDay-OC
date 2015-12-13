//
//  ClassDetailViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "EventViewController.h"
#import "ClassifyModel.h"
#import "EveryDayModel.h"
#import "MainTableView.h"
#import "DetailCell.h"
#import "theme.h"

#define DetailCellHeight = 220.0
#define SD_DetailCell_Identifier @"DetailCell"

@interface ClassDetailViewController()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)DetailModel* details;
@property(nonatomic, strong)MainTableView* detailTableView;
@end

@implementation ClassDetailViewController
- (MainTableView*) detailTableView
{
    if(_detailTableView == nil) {
        _detailTableView = [[MainTableView alloc] initWithFrame:MainBounds style:UITableViewStylePlain dataSource:self delegate:self];
        _detailTableView.rowHeight = 220;
        _detailTableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0);
        [_detailTableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:SD_DetailCell_Identifier];
    }
    return _detailTableView;
}

- (void) viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = SDBackgroundColor;
        [self.view addSubview:self.detailTableView];
        
        [self loadDatas];
}
    
- (void) loadDatas 
{
    __weak ClassDetailViewController* tmpSelf = self;
    [DetailModel loadDetails:^(DetailModel* data, NSError* error) {
        if(error != nil) {
            return;
        }
        tmpSelf.details = data;
        [tmpSelf.detailTableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.list.count;
}
    
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{
    EventModel* event = self.details.list[indexPath.row];
    DetailCell* cell = [tableView dequeueReusableCellWithIdentifier:SD_DetailCell_Identifier];
    cell.model = event;
        
    return cell;
}
    
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    EventModel* eventModel = self.details.list[indexPath.row];
    EventViewController* vc = [[EventViewController alloc]init];
    vc.model = eventModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end