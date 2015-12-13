//
//  ClassifyCell.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ClassifyCell.h"
#import "ClassifyModel.h"
#import "UIImageView+wnxImage.h"

@interface ClassifyCell()
@property (weak, nonatomic) IBOutlet UIImageView *classifyImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation ClassifyCell
- (void) setModel:(EveryClassModel *)model
{
    self.titleLabel.text = model.name;
    [self.classifyImageView wxn_setImageWithUrl:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"quesheng"]];
    _model = model;
}

@end
