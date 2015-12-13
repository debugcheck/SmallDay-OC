//
//  NSString+wnxString.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface NSString (wnxString)
- (BOOL) validateEmail;
- (BOOL) validateMobile;
- (CLLocationCoordinate2D) stringToCLLocationcoordinate2D:(NSString*)separator;
@end

@interface NSMutableString (wnxString)
+ (NSMutableString*) changeHeightAndWidthWithString:(NSMutableString*)searchStr;
@end