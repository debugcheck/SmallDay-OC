//
//  ExperienceModel.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExperienceModel.h"

@interface ExperienceModel : NSObject
@property(nonatomic, strong)NSArray* head;  //ExperienceHeadModel
@property(nonatomic, strong)NSArray* list;  //EventModel
+ (void) loadExperienceModel:(void(^)(ExperienceModel* data, NSError* error))completion;
@end

@interface ExperienceHeadModel : NSObject
@property(nonatomic, strong)NSString* feel;
@property(nonatomic, strong)NSString* shareURL;
@property(nonatomic, strong)NSString* tag;
@property(nonatomic)NSInteger id;
@property(nonatomic, strong)NSString* adurl;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* mobileURL;
@end