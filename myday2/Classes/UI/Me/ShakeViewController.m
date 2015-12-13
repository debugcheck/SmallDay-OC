//
//  ShakeViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

@import AVFoundation;
#import "ShakeViewController.h"
#import "ClassifyModel.h"
#import "DetailCell.h"
#import "EventViewController.h"
#import "theme.h"

#define DetailCellHeight 220

@interface ShakeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)DetailModel* detailModel;
@property(nonatomic, strong)UIView* foodView;
@property(nonatomic)SystemSoundID soundID;
@property (weak, nonatomic) IBOutlet UIImageView *yaoImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *yaoImage2;
@property (weak, nonatomic) IBOutlet UIView *bottomLoadView;
@property(nonatomic, strong) UITableView* tableView;
@end

@implementation ShakeViewController

#pragma mark - lzay attributes
- (SystemSoundID) soundID
{
    if(_soundID == 0) {
        NSURL* url = [[NSBundle mainBundle]URLForResource:@"glass.wav" withExtension:nil];
        CFURLRef urlRef = (__bridge CFURLRef)url;
        _soundID = 100;
        AudioServicesCreateSystemSoundID(urlRef, &_soundID);
    }
    return _soundID;
}

- (DetailModel*) detailModel
{
    if(_detailModel == nil) {
        _detailModel = [[DetailModel alloc]init];
    }
    return _detailModel;
}

- (UIView*) foodView
{
    if(_foodView == nil) {
        _foodView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, 80)];
        _foodView.backgroundColor = [UIColor clearColor];
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake((AppWidth - 120) * 0.5, 20, 120, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"fsyzm"] forState:UIControlStateNormal];
        [button setTitle:@"再摇一次" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(aginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_foodView addSubview:button];
    }
    return _foodView;
}

- (UITableView*) tableView
{
    if(_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:MainBounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.rowHeight = DetailCellHeight;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.foodView;
        [_tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
    }
    return _tableView;
}

- (id) init
{
    self = [super initWithNibName:@"ShakeViewController" bundle:nil];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"摇一摇";
    [self.view addSubview:self.tableView];
}



- (void) motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
    self.tableView.hidden = YES;
    NSTimeInterval animateDuration = 0.3;
    CGFloat offsetY = 50;
    
    [UIView animateWithDuration:animateDuration animations:^() {
        self.yaoImageView1.transform = CGAffineTransformMakeTranslation(0, -offsetY);
        self.yaoImage2.transform = CGAffineTransformMakeTranslation(0, offsetY);
        
    } completion:^(BOOL finish){
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^() {
            
            [UIView animateWithDuration:animateDuration animations: ^() {
                self.yaoImageView1.transform = CGAffineTransformIdentity;
                self.yaoImage2.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finish) {
                
                [self loadShakeData];
                // 音效
                AudioServicesPlayAlertSound(self.soundID);
            }];
        });
    }];
}


- (void) loadShakeData
{
    self.bottomLoadView.hidden = NO;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^() {
        [DetailModel loadDetails: ^(DetailModel* data, NSError* error) {
            self.bottomLoadView.hidden = YES;
            self.tableView.hidden = NO;
            self.detailModel = data;
            [self.tableView reloadData];
        }];
    });
}

#pragma mark button action
- (void) aginButtonClick
{
    [self motionBegan:UIEventSubtypeMotionShake withEvent:[[UIEvent alloc]init]];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailModel.list.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    DetailCell* cell = (DetailCell*)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    EventModel* everyModel = self.detailModel.list[indexPath.row];
    cell.model = everyModel;
    return cell;

}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    EventModel* everyModel = self.detailModel.list[indexPath.row];
    EventViewController* vc = [[EventViewController alloc]init];
    vc.model = everyModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
