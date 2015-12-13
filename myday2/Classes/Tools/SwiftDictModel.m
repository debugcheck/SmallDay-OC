//
//  SwiftDictModel.m
//  myday2
//
//  Created by awd on 15/12/5.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SwiftDictModel.h"
#import "EveryDayModel.h"
#import <objc/runtime.h>

static DictModelManager * instance = nil;


@implementation DictModelManager
+(id) sharedManager
{
    if(instance == nil) {
        instance = [[super alloc]init];
        instance.modelCache = [[NSMutableDictionary alloc]init];
    }
    return instance;
}

///  字典转模型
///  - parameter dict: 数据字典
///  - parameter cls:  模型类
///
///  - returns: 模型对象
- (NSObject*)objectWithDictionary:(NSDictionary*)dict cls:(Class)cls
{
    //获取命名空间
    //NSString* ns = (NSString*)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    //模型信息
    NSDictionary* infoDict = [self fullModelInfo:cls];
    
    id obj = [[cls alloc] init];
    
    NSArray* keys;
    NSInteger i, count;
    NSString *key, *v;
    NSDictionary *value;
    
    keys = [infoDict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++) {
        key = [keys objectAtIndex:i];
        v = [infoDict objectForKey:key];
        value = (NSDictionary*)[dict objectForKey:key];
        
        if(value == nil)
            continue;
        
        if(v != nil && [v isKindOfClass:[NSString class]] && [v length] == 0) {
            if(value != nil) {
                [obj setValue:value forKey:key];
            }
        } else {
            NSString* type = [NSString stringWithFormat:@"%@", value.classForCoder];
            
            if ([type  isEqual: @"NSDictionary"]) {
                NSObject* subObj = [self objectWithDictionary:value cls:NSClassFromString([NSString stringWithFormat:@"%@", v])];
                if(subObj) {
                    [obj setValue:subObj forKey:key];
                }
            } else if( [type  isEqual: @"NSArray"]) {
                NSObject* subObj = [self objectsWithArray:(NSArray*)value cls:NSClassFromString([NSString stringWithFormat:@"%@", v])];
                [obj setValue:subObj forKey:key];
            }
        }
    }
    
    return obj;
}

///  创建自定义对象数组
///
///  - parameter NSArray: 字典数组
///  - parameter cls:     模型类
///
///  - returns: 模型数组
- (NSArray*) objectsWithArray:(NSArray*)array cls:(Class)cls
{
    NSMutableArray* list = [[NSMutableArray alloc]init];
    
    for (NSDictionary* value in array) {
        NSString* type = [NSString stringWithFormat:@"%@", value.classForCoder];
        
        if([type  isEqual: @"NSDictionary"]) {
            NSObject* subObj = [self objectWithDictionary:value cls:cls];
            if(subObj) {
                [list addObject:subObj];
            }
        } else if([type  isEqual: @"NSArray"]) {
            NSObject* subObj = [self objectsWithArray:(NSArray*)value cls:cls];
            if(subObj) {
                [list addObject:subObj];
            }
        }
    }
    
    if([list count] > 0) {
        return list;
    } else {
        return nil;
    }
}

///  模型转字典
///
///  - parameter obj: 模型对象
///
///  - returns: 字典信息
- (NSDictionary*) objectDictionary:(NSObject*)obj
{
    NSDictionary* infoDict = [self fullModelInfo:[obj classForCoder]];
    
    NSDictionary* result = [[NSDictionary alloc]init];
    
    NSArray *keys;
    NSInteger i, count;
    NSString *key;
    NSArray *value;
    
    keys = [infoDict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [infoDict objectForKey: key];
        
        if(value == nil) {
            //value = NSNull
        }
        
        if(!value || [value count] == 0) {
            [result setValue:value forKey:key];
        } else {
            NSString* type = [NSString stringWithFormat:@"%@", value.classForCoder];
            
            NSObject* subValue = nil;
            if([type isEqual:@"NSArray"]) {
                subValue = [self objectArray:value];
            } else {
                subValue = [self objectDictionary:value];
            }
            if(subValue) {
                //subValue = NSNull();
            }
            [result setValue:subValue forKey:key];
        }
    }
    
    if([result count] > 0) {
        return result;
    } else {
        return nil;
    }
}

- (NSArray*) objectArray:(NSArray*)array
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSArray* value in array) {
        NSString* type = [NSString stringWithFormat:@"%@", value.classForCoder];
        
        NSString* subValue;
        if([type isEqual:@"NSArray"]) {
            subValue = (NSString*)[self objectArray:value];
        } else {
            subValue = (NSString*)[self objectDictionary:value];
        }
        if(subValue) {
            [result addObject:subValue];
        }
    }
    
    if([result count] > 0) {
        return result;
    } else {
        return nil;
    }
}

- (NSDictionary*)fullModelInfo:(Class)cls
{
    //检测缓冲池
    NSDictionary* cache = [self.modelCache objectForKey:[NSString stringWithFormat:@"%@", cls]];
    if(cache) return cache;
    
    Class currentCls = cls;
    
    NSMutableDictionary* infoDict = [[NSMutableDictionary alloc]init];
    Class parent = [currentCls superclass];
    while (parent) {
        [infoDict merge:[self modelInfo:currentCls]];
        currentCls = parent;
        parent = [currentCls superclass];
    }
    
    // 写入缓冲池
    [self.modelCache setValue:infoDict forKey:[NSString stringWithFormat:@"%@", cls]];
    return infoDict;
}

///  加载类信息
///
///  - parameter cls: 模型类
///
///  - returns: 模型类信息
- (NSDictionary*) modelInfo:(Class)cls
{
    // 检测缓冲池
    NSDictionary* cache = [self.modelCache objectForKey:[NSString stringWithFormat:@"%@", cls]];
    if(cache) return cache;
    
    // 拷贝属性列表
    uint32_t count = 0;
    objc_property_t* properties = class_copyPropertyList(cls, &count);
    
    // 检查类是否实现了协议
    NSDictionary* mappingDict = [[NSDictionary alloc]init];
    if ([cls respondsToSelector:@selector(customClassMapping)]) {
        mappingDict = [cls performSelector:@selector(customClassMapping)];
    }
        
    NSMutableDictionary* infoDict = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        //属性名称
        const char* cname = property_getName(property);
        //NSString* name = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
        NSString* name = [NSString stringWithCString:cname];
        if([name isEqual:@"hash"] || [name isEqual:@"superclass"] || [name isEqual:@"description"] || [name isEqual:@"debugDescription"] )
            continue;
        
        NSString* type = nil;
        if(mappingDict[name]) {
            type = mappingDict[name];
        } else {
            type = @"";
        }
        [infoDict setObject:type forKey:name];
        
    }
    free(properties);
    
    //写入缓冲池
    //[self.modelCache setValue:infoDict forKey:[NSString stringWithFormat:@"%@", cls]];
    [self.modelCache setValue:@"change" forKey:@"list"];
    return infoDict;
}
@end


@implementation NSMutableDictionary(merge)
- (void) merge:(NSDictionary*)dict
{
    NSArray *keys;
    NSInteger i, count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        //NSLog (@"SwiftDictModel merge: Key: %@ for value: %@", key, value);
        
        [self setValue:value forKey:key];
    }
}
@end

