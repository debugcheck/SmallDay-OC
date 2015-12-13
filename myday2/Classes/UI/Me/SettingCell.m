//
//  SettingCell.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell()
@end

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.alpha = 0.3;
    self.sizeLabel.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (SettingCell*) settingCellWithTableView:(UITableView*)tableView
{
    SettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    return cell;
}

@end
