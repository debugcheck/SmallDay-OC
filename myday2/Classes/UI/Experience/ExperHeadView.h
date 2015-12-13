//
//  ExperHeadView.h
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExperienceModel.h"

@class ExperHeadView;

@protocol ExperHeadViewDelegate <NSObject>
- (void) experHeadView:(ExperHeadView*)headView didClickImageViewAtIndex:(NSInteger)index;
@end

@interface ExperHeadView : UIView
@property(nonatomic, strong)ExperienceModel* experModel;
@property(nonatomic)id<ExperHeadViewDelegate> delegate;
@end
