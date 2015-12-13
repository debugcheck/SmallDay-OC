//
//  FileTool.h
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTool : NSObject
+ (double) fileSize:(NSString*)path;
+ (double) folderSize:(NSString*)path;
+ (void) cleanFolder:(NSString*)path complete:(void(^)())complete;
@end
