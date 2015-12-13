//
//  NSString+Hash.m
//  myday
//
//  Created by awd on 15/12/3.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "NSString+Hash.h"
#import<CommonCrypto/CommonDigest.h>


@implementation NSString (Hash)
- (NSString*) md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
@end
