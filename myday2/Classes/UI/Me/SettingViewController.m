//
//  SettingViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "AboutWeViewController.h"
#import "ShareView.h"
#import "ShareModel.h"
#import "FileTool.h"
#import "theme.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray* images;
@property(nonatomic, strong)NSMutableArray* titles;
@property(nonatomic, strong)UITableView* tableView;
@end

@implementation SettingViewController

#pragma mark lazy attributes
- (NSMutableArray*) images
{
    if(_images == nil) {
        _images = [[NSMutableArray alloc]initWithObjects:@"score", @"recommendfriend", @"about",  @"feedback", @"score", @"remove", nil];
    }
    return _images;
}

- (NSMutableArray*) titles
{
    if(_titles == nil) {
        _titles = [[NSMutableArray alloc]initWithObjects:@"去小熊的GitHub点赞", @"推荐给朋友", @"关于我们", @"去小熊的博客评论", @"关注我的微博,和作者交流", @"清理缓存", nil];
    }
    return _titles;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpTableView];
}

- (void) setUpTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:247 green:247 blue:247 alpha:1];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SettingCell* cell = [SettingCell settingCellWithTableView:self.tableView];
    cell.imageImageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.titleLabel.text = self.titles[indexPath.row];
    
    if(indexPath.row == Clean) {
        cell.bottomView.hidden = YES;
        cell.sizeLabel.hidden = NO;
        cell.sizeLabel.text = [@"" stringByAppendingFormat:@"%.2f M", [FileTool folderSize:cachesPath]];
        
        
    } else {
        cell.bottomView.hidden = NO;
        cell.sizeLabel.hidden = YES;
    }
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(indexPath.row == About) {
        AboutWeViewController* aboutVC = [[AboutWeViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    } else if(indexPath.row == Recommend) {
        ShareView* share = [ShareView shareViewFromXib];
        share.shareVC = self;
        ShareModel* shareModel = [[ShareModel alloc]init:@"Swift开源项目:小日子" shareURL:JianShuURL image:[UIImage imageNamed:@"author"] shareDetail:@"小熊新作,Swift开源项目小日子,OC程序员学习Swift良心作品"];
        share.shareModel = shareModel;
        [self.view addSubview:share];
        [share showShareView:CGRectMake(0, AppHeight - ShareViewHeight - NavigationH, AppWidth, ShareViewHeight)];
        
    } else if(indexPath.row == Clean) {
        __weak SettingViewController* tmpSelf = self;
        [FileTool cleanFolder:cachesPath complete:^(){
            [tmpSelf.tableView reloadData];
        }];
        
    } else if(indexPath.row == GitHub) {
        [appShare openURL:[NSURL URLWithString:GitHubURL]];
        
    } else if(indexPath.row == Blog) {
        [appShare openURL:[NSURL URLWithString:JianShuURL]];
        
    } else if(indexPath.row == Sina) {
        [appShare openURL:[NSURL URLWithString:sinaURL]];
        
    }
}
@end
