//
//  UIImageView+wnxImage.m
//  myday2
//
//  Created by awd on 15/12/6.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "UIImageView+wnxImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (wnxImage)
- (void) wxn_setImageWithUrl:(NSURL*)url placeholderImage:(UIImage*)image
{
    [self sd_setImageWithURL:url placeholderImage:image];
}
@end
