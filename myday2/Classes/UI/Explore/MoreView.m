//
//  MoreView.m
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MoreView.h"
#import "EveryDayModel.h"
#import "UIImageView+wnxImage.h"
#import <Foundation/Foundation.h>

@interface MoreView()
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation MoreView
- (void) model:(GuessLikeModel*)model
{
    self.titleLabel.text = model.title;
    self.addressLabel.text = model.address;
    NSString* imgStr = [model.imgs lastObject];
    [self.imageImageView wxn_setImageWithUrl:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"quesheng"]];
}

+ (MoreView*) moreViewWithGuessLikeModel:(GuessLikeModel*)model
{
    MoreView* moreView = (MoreView*)[[[NSBundle mainBundle]loadNibNamed:@"MoreView" owner:nil options:nil] lastObject];
    moreView.model = model;
    return moreView;
}
@end
