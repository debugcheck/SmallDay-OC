//
//  EventCellTableViewCell.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "EventCellTableViewCell.h"
#import "UIImageView+wnxImage.h"


@interface EventCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cellTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@end

@implementation EventCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEventModel:(EveryDay *)eventModel
{
    self.cellTileLabel.text = ((EventModel*)[eventModel.events lastObject]).feeltitle;
    self.titleLabel.text = ((EventModel*)[eventModel.events lastObject]).title;
    self.subTitleLabel.text = ((EventModel*)[eventModel.events lastObject]).address;
    self.dayLabel.text = eventModel.day;
    self.monthLabel.text = eventModel.month;
    NSURL* imageUrl = [NSURL URLWithString:[((EventModel*)[eventModel.events lastObject]).imgs lastObject]];
    if(imageUrl) {
        [self.imageImageView wxn_setImageWithUrl:imageUrl placeholderImage:[UIImage imageNamed:@"quesheng"]];
    }
}

+ (EventCellTableViewCell*) eventCell:(UITableView*)tableView
{
    NSString* identifier = @"eventCell";
    
    EventCellTableViewCell* cell = (EventCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = (EventCellTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"EventCellTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
