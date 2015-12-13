//
//  ClassifyModel.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwiftDictModel.h"

@interface ClassifyModel : NSObject
@property(nonatomic)NSInteger code;
@property(nonatomic, strong)NSArray* list;//ClassModel

+ (void) loadClassifyModel:(void(^)(ClassifyModel* data, NSError* error))completion;
@end


@interface ClassModel : NSObject
@property(nonatomic, strong)NSString* title;
@property(nonatomic)NSInteger id;
@property(nonatomic, strong)NSArray* tags;  //EveryClassModel
@end

@interface EveryClassModel : NSObject
@property(nonatomic)NSInteger ev_count;
@property(nonatomic)NSInteger id;
@property(nonatomic, strong)NSString* img;
@property(nonatomic, strong)NSString* name;
@end

@interface DetailModel : NSObject
@property(nonatomic, strong)NSString* msg;
@property(nonatomic)NSInteger code;
@property(nonatomic, strong)NSArray* list;  //EventModel

+ (void) loadDetails:(void(^)(DetailModel* data, NSError* error))completion;
+ (void) loadMore:(void(^)(DetailModel* data, NSError* error))completion;
@end

@interface SearchsModel : NSObject
@property(nonatomic, strong)NSArray* list;  //EventModel

+ (void) loadSearchsModel:(NSString*)title completion:(void(^)(SearchsModel* data, NSError* error))completion;
@end



