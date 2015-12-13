//
//  IconView.h
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  IconView;

@protocol IconViewDelegate <NSObject>
- (void) iconView:(IconView*)iconView didClick:(UIButton*)iconButton;
@end

@interface IconView : UIView
@property(nonatomic, strong)id<IconViewDelegate> delegate;
@property(nonatomic, strong)UIButton* iconButton;
@end
