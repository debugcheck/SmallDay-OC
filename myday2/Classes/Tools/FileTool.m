//
//  FileTool.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "FileTool.h"
#import "SVProgressHUD.h"

@implementation FileTool
+ (double) fileSize:(NSString*)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        NSDictionary* dict = [fileManager attributesOfItemAtPath:path error:nil];
        NSInteger fileSize = (NSInteger)[dict objectForKey:NSFileSize];
        return fileSize/1024/1024;
    }
    return 0.0;
}

/// 计算整个文件夹的大小
+ (double) folderSize:(NSString*)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    double folderSize = 0;
    if([fileManager fileExistsAtPath:path]) {
        NSArray* childFiles = [fileManager subpathsAtPath:path];
        for (NSString* fileName in childFiles) {
            NSString* tmpPath = path;
            NSString* fileFullPathName = [tmpPath stringByAppendingPathComponent:fileName];
            folderSize += [FileTool fileSize:fileFullPathName];
        }
        return folderSize;
    }
    return 0.0;
}

/// 彻底清除文件夹,异步
+ (void) cleanFolder:(NSString*)path complete:(void(^)())complete
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [SVProgressHUD showWithStatus:@"正在清理缓存" maskType:SVProgressHUDMaskTypeClear];
    dispatch_queue_t queue = dispatch_queue_create([@"cleanQueue" UTF8String], nil);
    
    dispatch_async(queue, ^() {
        NSArray* childFiles = [fileManager subpathsAtPath:path];
        for(NSString* fileName in childFiles) {
            NSString* tmpPath = path;
            NSString* fileFullPathName = [tmpPath stringByAppendingPathComponent:fileName];
            if([fileManager fileExistsAtPath:fileFullPathName]) {
                @try {
                    [fileManager removeItemAtPath:fileFullPathName error:nil];
                }@catch (NSException* e) {
                }
            }
        }
        
        // 线程睡1秒 测试,实际用到是将下面代码删除即可
        [NSThread sleepForTimeInterval:1.0];
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            [SVProgressHUD dismiss];
            complete();
        });
    });
}
@end
