//
//  UIImageView+wnxImage.h
//  myday2
//
//  Created by awd on 15/12/6.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (wnxImage)
- (void) wxn_setImageWithUrl:(NSURL*)url placeholderImage:(UIImage*)image;
@end
