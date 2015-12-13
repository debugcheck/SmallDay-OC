//
//  DoubleTextView.h
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleTextView;

@protocol DoubleTextViewDelegate <NSObject>
- (void) doubleTextView:(DoubleTextView*)doubleTextView didClickBtn:(UIButton*)btn forIndex:(NSInteger)index;
@end

@interface DoubleTextView : UIView
@property(nonatomic, weak)id<DoubleTextViewDelegate> delegate;
- (id) initWithLeftText:(NSString*)leftText right:(NSString*)rightText;
@end

@interface NoHighlightButton : UIButton

@end

