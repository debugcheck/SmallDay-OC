//
//  MoreView.h
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryDayModel.h"

@interface MoreView : UIView
@property(nonatomic, strong)GuessLikeModel* model;
+ (MoreView*) moreViewWithGuessLikeModel:(GuessLikeModel*)model;
@end
