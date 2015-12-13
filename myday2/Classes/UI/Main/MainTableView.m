//
//  MainTableView.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MainTableView.h"
#import "theme.h"

@implementation MainTableView
- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate
{
    self = [super initWithFrame:frame style:style];
    self.dataSource = dataSource;
    self.delegate = delegate;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = SDBackgroundColor;
    
    return self;
}
@end
