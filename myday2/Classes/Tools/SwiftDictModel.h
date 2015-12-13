//
//  SwiftDictModel.h
//  myday2
//
//  Created by awd on 15/12/5.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DictModelProtocol <NSObject>
+ (NSDictionary*) customClassMapping;
@end


@interface  DictModelManager : NSObject
@property(nonatomic, strong)NSMutableDictionary* modelCache;   //[String: [String: String]]
+ (id) sharedManager;
- (NSObject*)objectWithDictionary:(NSDictionary*)dict cls:(Class)cls;
@end

@interface NSMutableDictionary(merge)
- (void) merge:(NSDictionary*)dict;
@end




