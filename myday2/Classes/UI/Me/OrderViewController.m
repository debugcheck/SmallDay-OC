//
//  OrderViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "OrderViewController.h"
#import "theme.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id) init
{
    self = [super initWithNibName:@"OrderViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    self.view.backgroundColor = SDBackgroundColor;
}


@end
