//
//  SimpleNetwork.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SimpleNetwork.h"
#import "NSString+Hash.h"

#define imageCachePath @"com.wnx.imagecache"
#define errorDomain @"com.itheima.error"

@interface SimpleNetwork()
@property(nonatomic, strong)NSURLSession* session;
@property(nonatomic, strong)NSString* cachePath;
@end

@implementation SimpleNetwork
///  下载多张图片
///
///  - parameter urls:       图片 URL 数组
///  - parameter completion: 所有图片下载完成后的回调
- (void) downloadImages:(NSArray*)urls completion:(Completion)completion
{
    // 希望所有图片下载完成，统一回调！
    
    // 利用调度组统一监听一组异步任务执行完毕
    dispatch_group_t group = dispatch_group_create();
    
    // 遍历数组
    for (NSString*url in urls) {
        // 进入调度组
        dispatch_group_enter(group);
        [self downloadImage:url completion:^(NSObject* result, NSError* error){
            dispatch_group_leave(group);
        }];
    }
    
    // 在主线程回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        // 所有任务完成后的回调
        completion(nil, nil);
    });
}

///  下载图像并且保存到沙盒
///
///  - parameter urlString:  urlString
///  - parameter completion: 完成回调
- (void) downloadImage:(NSString*)urlString completion:(Completion)completion
{
    // 1. 将下载的图像 url 进行 md5
    NSString* path = [urlString md5];
    // 2. 目标路径
    NSString* tmpPath = self.cachePath;
    path = [tmpPath stringByAppendingPathComponent:path];
    
    // 2.1 缓存检测，如果文件已经下载完成直接返回
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        completion(nil, nil);
        return;
    }
    
    // 3. 下载图像
    NSURL* url = [NSURL URLWithString:urlString];
    if(url) {
        [[self.session downloadTaskWithURL:url completionHandler:^(NSURL*location, NSURLResponse* response, NSError*error){
            //错误处理
            if(error != nil) {
                completion(nil, error);
                return;
            }
            
            // 将文件复制到缓存路径
            @try{
                [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:path error:nil];
            }@catch(NSException* e){
            }
            
            // 直接回调，不传递任何参数
            completion(nil, nil);
        }] resume];
    }
}

/// 完整图像缓存路径
- (NSString*) getCachePath
{
    // 1. cache
    NSString* path = (NSString*)NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* tmpPath = path;
    
    path = [tmpPath stringByAppendingPathComponent:imageCachePath];
    
    // 2. 检查缓存路径是否存在 － 注意：必须准确地指出类型 ObjCBool
    BOOL isDirectory = YES;
    // 无论存在目录还是文件，都会返回 true，是否是路径由 isDirectory 来决定
    BOOL exists = [[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&isDirectory];
    // 3. 如果有同名的文件－干掉
    // 一定需要判断是否是文件，否则目录也同样会被删除
    if(exists && !isDirectory) {
        @try {
            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    
    // 4. 直接创建目录，如果目录已经存在，就什么都不做
    // withIntermediateDirectories -> 是否智能创建层级目录
    @try {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return path;
}

// MARK: - 请求 JSON
///  请求 JSON
///
///  - parameter method:     HTTP 访问方法
///  - parameter urlString:  urlString
///  - parameter params:     可选参数字典
///  - parameter completion: 完成回调
- (void) requestJSON:(HTTPMethod)method urlString:(NSString*)urlString params:(NSDictionary*)params completion:(Completion)completion
{
    // 实例化网络请求
    NSURLRequest* request = [self request:method urlString:urlString params:params];
    if(request) {
        // 访问网络 － 本身的回调方法是异步的
        [[self.session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* reponse, NSError* error){
            // 如果有错误，直接回调，将网络访问的错误传回
            if(error != nil) {
                completion(nil, error);
                return;
            }
            
            // 反序列化 -> 字典或者数组
            NSData* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            // 判断是否反序列化成功
            if(json == nil) {
                NSError* error = [[NSError alloc]initWithDomain:errorDomain code:-1 userInfo:@{@"error":@"反序列化失败"}];
                completion(nil, error);
            } else {
                //有结果
                dispatch_async(dispatch_get_main_queue(), ^(){
                    completion(json, nil);
                });
            }
        }] resume];
        return;
    }
    // 如果网络请求没有创建成功，应该生成一个错误，提供给其他的开发者
    /**
     domain: 错误所属领域字符串 com.itheima.error
     code: 如果是复杂的系统，可以自己定义错误编号
     userInfo: 错误信息字典
     */
    NSError* error = [[NSError alloc]initWithDomain:errorDomain code:-1 userInfo:@{@"error": @"请求建立失败"}];
    completion(nil, error);
}


///  返回网络访问的请求
///
///  - parameter method:    HTTP 访问方法
///  - parameter urlString: urlString
///  - parameter params:    可选参数字典
///
///  - returns: 可选网络请求
- (NSURLRequest*) request:(HTTPMethod)method urlString:(NSString*)urlString params:(NSDictionary*)params
{
    if(urlString == nil || [urlString isEqual:@""]) {
        return nil;
    }
    
    // 记录 urlString，因为传入的参数是不可变的
    NSString* urlStr = urlString;
    NSMutableURLRequest* r = nil;
    
    if(method == GET) {
        // URL 的参数是拼接在URL字符串中的
        // 1. 生成查询字符串
        NSString* query = [self queryString:params];
        
        // 2. 如果有拼接参数
        if(query != nil) {
            urlStr = [NSString stringWithFormat:@"%@?%@", urlStr, query];
        }
        
        // 3. 实例化请求
        r = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    } else {
        // 设置请求体，提问：post 访问，能没有请求体吗？=> 必须要提交数据给服务器
        NSString* query = [self queryString:params];
        if(query) {
            r = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            
            // 设置请求方法
            // swift 语言中，枚举类型，如果要去的返回值，需要使用一个 rawValue
            if(method == GET) {
                r.HTTPMethod = @"GET";
            } else {
                r.HTTPMethod = @"POST";
            }
            //设置数据体
            r.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        }
    }
    
    return r;
}

///  生成查询字符串
///
///  - parameter params: 可选字典
///
///  - returns: 拼接完成的字符串
- (NSString*) queryString:(NSDictionary*)params
{
    // 0. 判断参数
    if(params == nil) {
        return nil;
    }
    
    // 涉及到数组的使用技巧
    // 1. 定义一个数组
    NSMutableArray* array = [[NSMutableArray alloc]init];
    // 2. 遍历字典
    NSArray* keys = [params allKeys];
    NSString *key, *value;
    for(NSInteger i = 0; i < keys.count; i++) {
        key = keys[i];
        value = [params objectForKey:key];
        NSString* str = [NSString stringWithFormat:@"%@=%@", key, [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
        [array addObject:str];
    }
    
    return [array componentsJoinedByString:@"&"];
}

/// 取消全部网络活动
- (void) cancleAllNetwork
{
    [self.session.delegateQueue cancelAllOperations];
}

///  公共的初始化函数，外部就能够调用了
- (id) init
{
    self = [super init];
    return self;
}

///  全局网络会话，提示，可以利用构造函数，设置不同的网络会话配置
- (NSURLSession*) getSession
{
    return [NSURLSession sharedSession];
}
@end
