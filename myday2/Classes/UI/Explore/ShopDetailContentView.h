//
//  ShopDetailContentView.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryDayModel.h"

typedef void(^mapCallback)();

@interface ShopDetailContentView : UIView
@property(nonatomic, strong)mapCallback mapBtnClickCallback;
@property(nonatomic, strong)EventModel* detailModel;

+ (ShopDetailContentView*) shopDetailContentViewFromXib;
@end
