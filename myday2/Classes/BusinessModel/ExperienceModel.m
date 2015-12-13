//
//  ExperienceModel.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperienceModel.h"
#import "SwiftDictModel.h"
#import "EveryDayModel.h"

@interface ExperienceModel()<DictModelProtocol>

@end
@implementation ExperienceModel

- (id) init
{
    self = [super init];
    self.head = [[NSArray alloc]init];
    self.list = [[NSArray alloc]init];
    return self;
}

+ (NSDictionary*) customClassMapping
{
    Class head = [ExperienceHeadModel self];
    Class list = [EventModel self];
    NSString* tmp = [NSString stringWithFormat:@"%@", head];
    NSString* tmp2 = [NSString stringWithFormat:@"%@", list];
    return [[NSDictionary alloc]initWithObjects:@[tmp, tmp2] forKeys:@[@"head", @"list"]];
}

+ (void) loadExperienceModel:(void(^)(ExperienceModel* data, NSError* error))completion
{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"Experience" ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    if(data) {
        NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:
                                             NSJSONReadingAllowFragments error:nil];
        DictModelManager* modelTool = [DictModelManager sharedManager];
        ExperienceModel* data = (ExperienceModel*)[modelTool objectWithDictionary:dict cls:[self class]];
        completion(data, nil);
    }
}
@end

@implementation ExperienceHeadModel
- (id) init
{
    self = [super init];
    self.id = -1;
    return self;
}
@end

