//
//  SDRefreshHeader.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SDRefreshHeader.h"

@implementation SDRefreshHeader
- (void) prepare
{
    [super prepare];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    NSMutableArray* idleImages = [[NSMutableArray alloc]init];
    UIImage* idImage = [UIImage imageNamed:@"wnx00"];
    [idleImages addObject:idImage];
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray* refreshingImages = [[NSMutableArray alloc]init];
    UIImage* refreshingImage = [UIImage imageNamed:@"wnx00"];
    [refreshingImages addObject:refreshingImage];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    NSMutableArray* refreshingStartImages = [[NSMutableArray alloc]init];
    for(NSInteger i = 0; i < 93; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"wnx%02ld", (long)i]];
        [refreshingStartImages addObject:image];
    }
    [self setImages:refreshingStartImages forState:MJRefreshStateRefreshing];
}
@end
