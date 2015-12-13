//
//  CityCollectionViewCell.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "CityCollectionViewCell.h"

@interface CityCollectionViewCell()
@property(nonatomic, strong)UILabel* textLabel;
@end

@implementation CityCollectionViewCell
- (void) setCityName:(NSString *)cityName
{
    self.textLabel.text = cityName;
}

- (NSString*) cityName
{
    return self.textLabel.text;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = [UIColor redColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}
@end
