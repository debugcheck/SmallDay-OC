//
//  ExperienceCell.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperienceCell.h"
#import "UIImageView+wnxImage.h"

@interface ExperienceCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation ExperienceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEventModel:(EventModel *)eventModel
{
    self.titleLabel.text = eventModel.title;
    if(eventModel.imgs.count > 0) {
        NSString* urlStr = eventModel.imgs[0];
        [self.imageImageView wxn_setImageWithUrl:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"quesheng"]];
    }
}

@end
