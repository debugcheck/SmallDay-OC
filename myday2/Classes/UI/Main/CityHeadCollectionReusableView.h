//
//  CityHeadCollectionReusableView.h
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityHeadCollectionReusableView : UICollectionReusableView
@property(nonatomic, strong)NSString* headTitle;
@property(nonatomic, strong)UILabel* headTitleLabel;
@end

@interface CityFootCollectionReusableView : UICollectionReusableView
@property(nonatomic, strong)UILabel* titleLabel;
@end
