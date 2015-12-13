//
//  UIBarButtonItem+wxnBarButtonItem.h
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (wxnBarButtonItem)
- (id) initWithImageName:(NSString*)imageName highImageName:(NSString*)highImageName target:(NSObject*)target action:(SEL)action;
- (id) initWithImageName:(NSString*)imageName highImageName:(NSString *)highImageName selectedImage:(NSString*)selectedImage target:(NSObject*)target action:(SEL)action;
- (id) initWithLeftImageName:(NSString*)leftImageName highImageName:(NSString*)highImageName target:(NSObject*)target action:(SEL)action;
- (id) initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor target:(NSObject*)target action:(SEL)action;
@end
