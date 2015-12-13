//
//  UIImage+wnxImage.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "UIImage+wnxImage.h"

@implementation UIImage (wnxImage)
/// 按尺寸裁剪图片大小
+ (UIImage*) imageClipToNewImage:(UIImage*)image newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 将传入的图片裁剪成带边缘的原型图片
+ (UIImage*) imageWithClipImage:(UIImage*)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor
{
    CGFloat imageWH = image.size.width;
    //        let border = borderWidth
    CGFloat ovalWH = imageWH + 2 * borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), false, 0);
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [borderColor set];
    [path fill];
    
    UIBezierPath* clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageWH, imageWH)];
    [clipPath addClip];
    [image drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    UIImage* clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/// 将传入的图片裁剪成圆形图片
- (UIImage*) imageClipOvalImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    [self drawInRect:rect];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
