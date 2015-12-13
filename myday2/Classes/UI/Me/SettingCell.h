//
//  SettingCell.h
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingCellType) {
    GitHub = 0,
    Recommend = 1,
    About = 2,
    Blog = 3,
    Sina = 4,
    Clean = 5,
};

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;

+ (SettingCell*) settingCellWithTableView:(UITableView*)tableView;
@end
