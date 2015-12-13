//
//  ClassifyModel.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ClassifyModel.h"
#import "EveryDayModel.h"
#import "UserInfoManager.h"
#import "NSString+wnxString.h"

@interface ClassifyModel() <DictModelProtocol>

@end
@implementation ClassifyModel
- (id) init
{
    self = [super init];
    self.code = -1;
    self.list = [[NSArray alloc]init];  //ClassModel
    return self;
}
+ (NSDictionary*) customClassMapping
{
    Class temp = [ClassModel self];
    NSString* tmp = [NSString stringWithFormat:@"%@", temp];
    return [[NSDictionary alloc]initWithObjects:@[tmp] forKeys:@[@"list"]];
}

+ (void) loadClassifyModel:(void(^)(ClassifyModel* data, NSError* error))completion
{
    NSString* path = (NSString*)[[NSBundle mainBundle] pathForResource:@"Classify" ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    if(data) {
        NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:
                                             NSJSONReadingAllowFragments error:nil];
        DictModelManager* modelTool = [DictModelManager sharedManager];
        ClassifyModel* data = (ClassifyModel*)[modelTool objectWithDictionary:dict cls:[self class]];
        completion(data, nil);
    }
}
@end

@interface ClassModel() <DictModelProtocol>
@end

@implementation ClassModel
- (id) init
{
    self = [super init];
    self.id = -1;
    self.tags = [[NSArray alloc] init]; //EveryClassModel
    return self;
}
+ (NSDictionary*) customClassMapping
{
    Class temp = [EveryClassModel self];
    NSString* tmp = [NSString stringWithFormat:@"%@", temp];
    return [[NSDictionary alloc]initWithObjects:@[tmp] forKeys:@[@"tags"]];
}
@end


@implementation EveryClassModel
- (id) init
{
    self = [super init];
    self.ev_count = -1;
    self.id = -1;
    
    return self;
}
@end



@interface DetailModel() <DictModelProtocol>
@end

@implementation DetailModel
- (id) init
{
    self = [super init];
    self.code = -1;
    self.list = [[NSArray alloc]init]; //EventModel
    return self;
}
+ (NSDictionary*) customClassMapping
{
    Class temp = [EventModel self];
    NSString* tmp = [NSString stringWithFormat:@"%@", temp];
    return [[NSDictionary alloc]initWithObjects:@[tmp] forKeys:@[@"list"]];
}

/// 加载详情模型
+ (void) loadDetails:(void(^)(DetailModel* data, NSError* error))completion
{
    [self loadDatas:@"Details" isShowDis:NO completion:completion];
}

 /// 加载美辑点击按钮的更多模型
+ (void) loadMore:(void(^)(DetailModel* data, NSError* error))completion
{
    [self loadDatas:@"More" isShowDis:NO completion:completion];
}

/// 加载附近店铺数据
+ (void) loadNearDatas:(void(^)(DetailModel* data, NSError* error))completion
{
    [self loadDatas:@"Nears" isShowDis:YES completion:completion];
}

+ (void) loadDatas:(NSString*)fileName isShowDis:(BOOL)isShowDis completion:(void(^)(DetailModel* data, NSError* error))completion
{
    NSString* path = (NSString*)[[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    DictModelManager* modelTool = [DictModelManager sharedManager];
    DetailModel* datas = (DetailModel*)[modelTool objectWithDictionary:dict cls:[DetailModel class]];
    if(isShowDis) {
        for (EventModel* event in datas.list) {
            event.isShowDis = YES;
            if(CLLocationCoordinate2DIsValid([UserInfoManager sharedUserInfoManager].userPosition)) {
                //CLLocationCoordinate2D userL = [UserInfoManager sharedUserInfoManager].userPosition;
                //CLLocationCoordinate2D shopL = [event.position stringToCLLocationcoordinate2D:@","];
                //TODO
            }
        }
    }
    completion(datas, nil);
}
@end



@interface SearchsModel() <DictModelProtocol>
@end

@implementation SearchsModel
- (id) init
{
    self = [super init];
    self.list = [[NSArray alloc]init];  //EventModel
    return self;
}
+ (NSDictionary*) customClassMapping
{
    Class temp = [EventModel self];
    NSString* tmp = [NSString stringWithFormat:@"%@", temp];
    return [[NSDictionary alloc]initWithObjects:@[tmp] forKeys:@[@"list"]];
}

+ (void) loadSearchsModel:(NSString*)title completion:(void(^)(SearchsModel* data, NSError* error))completion
{
    NSString* path;
    if([title isEqual:@"南锣鼓巷"] || [title isEqual:@"798"] || [title isEqual:@"三里屯"] ) {
        path = [[NSBundle mainBundle]pathForResource:title ofType:nil];
    } else {
        path = [[NSBundle mainBundle]pathForResource:@"南锣鼓巷" ofType:nil];
    }
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    if(data) {
        NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:
                                             NSJSONReadingAllowFragments error:nil];
        DictModelManager* modelTool = [DictModelManager sharedManager];
        SearchsModel* data = (SearchsModel*)[modelTool objectWithDictionary:dict cls:[self class]];
        completion(data, nil);
    }
}

@end

