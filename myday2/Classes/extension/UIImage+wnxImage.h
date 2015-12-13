//
//  UIImage+wnxImage.h
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wnxImage)
+ (UIImage*) imageClipToNewImage:(UIImage*)image newSize:(CGSize)newSize;
+ (UIImage*) imageWithClipImage:(UIImage*)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
- (UIImage*) imageClipOvalImage;
@end
