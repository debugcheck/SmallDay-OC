//
//  ThemeCell.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ThemeCell.h"
#import "EveryDayModel.h"
#import "UIImageView+wnxImage.h"

@interface ThemeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@end

@implementation ThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLable.shadowOffset = CGSizeMake(-1, 1);
    self.titleLable.shadowColor = [UIColor colorWithRed:20 green:20 blue:20 alpha:0.1];
    self.subTitleLable.shadowOffset = CGSizeMake(-1, 1);
    self.subTitleLable.shadowColor = [UIColor colorWithRed:20 green:20 blue:20 alpha:0.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ThemeCell*) themeCellWithTableView:(UITableView*)tableView
{
    NSLog(@"load themecell");
    NSString* identifier = @"themeCell";
    ThemeCell* cell = (ThemeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = (ThemeCell*)[[[NSBundle mainBundle] loadNibNamed:@"ThemeCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void) setModel:(ThemeModel *)model
{
    NSLog(@"ThemeCell setModel%@", model.title);
    self.titleLable.text = model.title;
    self.subTitleLable.text = model.keywords;
    [self.backImageView wxn_setImageWithUrl:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"quesheng"]];
}

@end
