//
//  DetailCell.m
//  myday2
//
//  Created by awd on 15/12/9.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "DetailCell.h"
#import "UIImageView+wnxImage.h"

@interface DetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *disImageV;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;

@end

@implementation DetailCell

- (void) setModel:(EventModel*)model
{
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.address;
    NSString* imsStr = [model.imgs lastObject];
    if(imsStr) {
        [self.backImageView wxn_setImageWithUrl:[NSURL URLWithString:imsStr] placeholderImage:[UIImage imageNamed:@"quesheng"]];
    }
    
    if(model.isShowDis) {
        self.disImageV.hidden = NO;
        self.disLabel.hidden = NO;
        self.disLabel.text = model.distanceForUser;
    } else {
        self.disLabel.hidden = YES;
        self.disImageV.hidden = YES;
    }
    _model = model;
}

- (void)awakeFromNib {
    NSLog(@"DetailCell awakeFromNib");
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
