//
//  ThemeCell.h
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryDayModel.h"

@interface ThemeCell : UITableViewCell
@property (strong, nonatomic) ThemeModel* model;
+ (ThemeCell*) themeCellWithTableView:(UITableView*)tableView;
@end
