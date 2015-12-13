//
//  ShopDetailView.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopDetailView;

@protocol ShopDetailViewDelegate <NSObject>
- (void) shopDetailView:(ShopDetailView*)shopDetailView didSelectedLableAtIndex:(NSInteger)index;
@end


@interface ShopDetailView : UIView
@property(nonatomic, weak)id<ShopDetailViewDelegate> delegate;
@end

