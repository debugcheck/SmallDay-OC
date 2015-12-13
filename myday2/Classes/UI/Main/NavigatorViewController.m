//
//  NavigatorViewController.m
//  myday2
//
//  Created by awd on 15/12/9.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "NavigatorViewController.h"
#import "NSString+wnxString.h"

@interface NavigatorViewController ()
@property(nonatomic, strong)NSString* addressTitle;
@end

@implementation NavigatorViewController

- (void)setModel:(EventModel *)model
{
    //CLLocationCoordinate2D shopLocation = [model.position stringToCLLocationcoordinate2D:@","];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"位置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
