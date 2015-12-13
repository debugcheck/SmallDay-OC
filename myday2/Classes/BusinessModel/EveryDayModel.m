//
//  EveryDayModel.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "EveryDayModel.h"
#import "SwiftDictModel.h"

@interface EveryDays() <DictModelProtocol>

@end

@implementation EveryDays

- (id) init
{
    self = [super init];
    self.code = -1;
    self.list = [[NSArray alloc]init];
    return self;
}

+ (void) loadEventsData:(void(^)(EveryDays* data, NSError* error))completion
{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"events" ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    if(data) {
        NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:
                                             NSJSONReadingAllowFragments error:nil];
        DictModelManager* modelTool = [DictModelManager sharedManager];
        EveryDays* data = (EveryDays*)[modelTool objectWithDictionary:dict cls:[self class]];
        completion(data, nil);
    }
}

+ (NSDictionary*) customClassMapping
{
    Class temp = [EveryDay self];
    NSString* tmp = [NSString stringWithFormat:@"%@", temp];
    return [[NSDictionary alloc]initWithObjects:@[tmp] forKeys:@[@"list"]];
}
@end

@interface EveryDay() <DictModelProtocol>

@end
@implementation EveryDay
- (id) init
{
    self = [super init];
    self.themes = [[NSArray alloc]init];
    self.events = [[NSArray alloc]init];
    return self;
}
- (void) setDate:(NSString*)newValue
{
    NSString* tmpDate = newValue;
    if( tmpDate.length == 10) {
        NSInteger tmpM = [tmpDate substringWithRange:(NSRange){.location =  5, .length = 2}].intValue;
        switch (tmpM) {
            case 1:
                self.month = @"Jan.";
                break;
            case 2:
                self.month = @"Feb.";
                break;
            case 3:
                self.month = @"Mar.";
                break;
            case 4:
                self.month = @"Apr.";
                break;
            case 5:
                self.month = @"May.";
                break;
            case 6:
                self.month = @"Jun.";
                break;
            case 7:
                self.month = @"Jul.";
                break;
            case 8:
                self.month = @"Aug.";
                break;
            case 9:
                self.month = @"Sep.";
                break;
            case 10:
                self.month = @"Oct.";
                break;
            case 11:
                self.month = @"Nov.";
                break;
            case 12:
                self.month = @"Dec.";
                break;
                
            default:
                self.month = [NSString stringWithFormat:@"%ld", (long)tmpM];
                break;
        }
        self.day = [tmpDate substringWithRange:(NSRange){.location = 8, .length = 2}];
    } else {
        self.month = @"Aug.";
        //self.date = newValue;
        return;
    }
    
    //self.date = newValue;
}

+ (NSDictionary*) customClassMapping
{
    NSArray* values = [[NSArray alloc]initWithObjects:ThemeModel.self, EventModel.self, nil];
    NSArray* keys   = [[NSArray alloc]initWithObjects:@"themes", @"events", nil];
    
    return [[NSDictionary alloc]initWithObjects:values forKeys:keys];
}
@end

///美辑 model
@implementation ThemeModel
- (id) init
{
    self = [super init];
    self.hasweb = -1;
    self.id = -1;
    return self;
}
@end


///美天model
@interface EventModel() <DictModelProtocol>

@end
@implementation EventModel
- (id) init
{
    self = [super init];
    self.id = -1;
    self.more = [[NSArray alloc]init];  //GuessLikeModel
    self.isShowDis = NO;
    return self;
}
+ (NSDictionary*) customClassMapping
{
    return [[NSDictionary alloc] initWithObjects:@[GuessLikeModel.self] forKeys:@[@"more"]];
}
@end

///猜你喜欢
@implementation GuessLikeModel
- (id) init
{
    self = [super init];
    self.imgs = [[NSArray alloc]init];
    return self;
}
@end

///美辑s
@interface ThemeModels() <DictModelProtocol>

@end

@implementation ThemeModels
- (id) init
{
    self = [super init];
    self.list = [[NSArray alloc]init];
    return self;
}
+ (void)loadThemesData:(void(^)(ThemeModels* data, NSError* error))completion
{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"themes" ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    if(data) {
        NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:
                                             NSJSONReadingAllowFragments error:nil];
        DictModelManager* modelTool = [DictModelManager sharedManager];
        ThemeModels* data = (ThemeModels*)[modelTool objectWithDictionary:dict cls:[ThemeModels class]];
        completion(data, nil);
    }
}

+ (NSDictionary*) customClassMapping
{
    return [[NSDictionary alloc] initWithObjects:@[ThemeModel.self] forKeys:@[@"list"]];
}
@end

