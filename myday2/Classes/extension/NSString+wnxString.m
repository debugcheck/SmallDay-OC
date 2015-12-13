//
//  NSString+wnxString.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "NSString+wnxString.h"
#import "theme.h"
#import "RegExCategories.h"

@implementation NSString (wnxString)
- (BOOL) validateEmail
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL) validateMobile
{
    NSString* phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (CLLocationCoordinate2D) stringToCLLocationcoordinate2D:(NSString*)separator
{
    NSArray* arr = [self componentsSeparatedByString:separator];
    if(arr.count != 2) {
        return kCLLocationCoordinate2DInvalid;
    }
    
    double latitude = [NSString stringWithString:arr[1]].doubleValue;
    double longitude = [NSString stringWithString:arr[0]].doubleValue;
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
@end

@implementation NSMutableString (wnxString)
+ (NSMutableString*) changeHeightAndWidthWithString:(NSMutableString*)searchStr
{
    NSMutableArray* mut = [[NSMutableArray alloc]init]; //CGFloat
    NSMutableArray* mutH = [[NSMutableArray alloc]init]; //CGFloat
    CGFloat imageW = AppWidth - 23;
    NSRegularExpression* rxHeight = [[NSRegularExpression alloc]initWithPattern:@"?<= height=\")\\d*"];
    NSRegularExpression* rxWidth = [[NSRegularExpression alloc]initWithPattern:@"(?<=width=\")\\d*"];
    NSArray* widthArray = (NSArray*)[rxWidth matches:searchStr];
    
    for (NSString* width in widthArray) {
        float value = imageW/width.floatValue;
        [mut addObject:[[NSNumber alloc]initWithFloat:value]];
    }
    
    NSArray* widthMatches = [rxWidth matchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, [searchStr length])];
    
    for(NSInteger i = widthMatches.count-1; i >= 0; i--) {
        NSTextCheckingResult* widthMatch = (NSTextCheckingResult*)widthMatches[i];
        [searchStr replaceCharactersInRange:widthMatch.range withString:[NSString stringWithFormat:@"%f", imageW]];
    }
    
    NSMutableString* newString = [searchStr mutableCopy];
    NSArray* heightArray = (NSArray*)[rxHeight matches:newString];
    for (NSInteger i = 0; i < mut.count; i++) {
        float temp = ((NSNumber*)mut[i]).floatValue * ((NSString*)heightArray[i]).floatValue;
        [mutH addObject:[NSNumber numberWithFloat:temp]];
    }
    
    NSArray* matches = [rxHeight matchesInString:newString options:NSMatchingReportProgress range:NSMakeRange(0, newString.length)];
    
    for(NSInteger i = matches.count - 1; i >= 0; i--) {
        NSTextCheckingResult* match = matches[i];
        [newString replaceCharactersInRange:match.range withString:[NSString stringWithFormat:@"%@", mutH[i]]];
    }
    
    return newString;
}
@end
