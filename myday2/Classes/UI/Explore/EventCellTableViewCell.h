//
//  EventCellTableViewCell.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryDayModel.h"

@interface EventCellTableViewCell : UITableViewCell
@property(nonatomic, strong)EveryDay* eventModel;
+ (EventCellTableViewCell*) eventCell:(UITableView*)tableView;
@end
