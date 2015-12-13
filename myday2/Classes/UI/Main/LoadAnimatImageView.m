//
//  LoadAnimatImageView.m
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "LoadAnimatImageView.h"

static LoadAnimatImageView* sharedInstance = nil;

@interface LoadAnimatImageView()
@property(nonatomic, strong)UIImageView* loadImageView;
@end

@implementation LoadAnimatImageView
+ (LoadAnimatImageView*) sharedInstance
{
    if(sharedInstance == nil){
        sharedInstance = [[LoadAnimatImageView alloc]init];
    }
    return sharedInstance;
}

- (UIImageView*) loadImageView
{
    UIImageView* loadImageView = [[UIImageView alloc]init];
    loadImageView.animationImages = self.loadAnimImages;
    loadImageView.animationRepeatCount = 10000;
    loadImageView.animationDuration = 1.0;
    loadImageView.frame = CGRectMake(0, 0, 44, 51);
    return loadImageView;
}

- (NSArray*) loadAnimImages
{
    NSMutableArray* images = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 92; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"wnx%02ld", (long)i]];
        [images addObject:image];
    }
    
    return images;
}

- (void) startLoadAnimatImageViewInView:(UIView*)view center:(CGPoint)center
{
    self.loadImageView.center = center;
    [view addSubview:self.loadImageView];
    [self.loadImageView startAnimating];
}

- (void) stopLoadAnimatImageView
{
    [self.loadImageView removeFromSuperview];
    [self.loadImageView stopAnimating];
}
@end
