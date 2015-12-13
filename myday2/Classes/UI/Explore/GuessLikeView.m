//
//  GuessLikeView.m
//  myday2
//
//  Created by awd on 15/12/7.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "GuessLikeView.h"

@interface GuessLikeView()

@end

@implementation GuessLikeView
+ (GuessLikeView*) guessLikeViewFromXib
{
    GuessLikeView *guessLike = (GuessLikeView*)[[[NSBundle mainBundle]loadNibNamed:@"GuessLikeView" owner:nil options:nil] lastObject];
    return guessLike;
}
@end
