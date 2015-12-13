//
//  EveryDayModel.h
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EveryDay;

@interface EveryDays : NSObject
@property(nonatomic, strong)NSString* msg;
@property(nonatomic)NSInteger code;
@property(nonatomic, strong)NSArray* list; //EveryDay
+ (void) loadEventsData:(void(^)(EveryDays* data, NSError* error))completion;
@end

/// 美天model
@interface EveryDay : NSObject
@property(nonatomic, strong)NSString* date;
@property(nonatomic, strong)NSArray* themes;    //ThemeModel
@property(nonatomic, strong)NSArray* events;    //EventModel
@property(nonatomic, strong)NSString* month;
@property(nonatomic, strong)NSString* day;

+ (NSDictionary*) customClassMapping;
@end

/// 美辑model
@interface ThemeModel : NSObject
/// 美辑的url网址
@property(nonatomic, strong)NSString* themeurl;
/// 图片url
@property(nonatomic, strong)NSString* img;
/// cell主标题
@property(nonatomic, strong)NSString* title;
/// 是否有web地址 1是有, 0没有
@property(nonatomic)NSInteger hasweb;
/// cell的副标题
@property(nonatomic, strong)NSString* keywords;
/// 美辑的编号
@property(nonatomic)NSInteger id;
@property(nonatomic, strong)NSString* text;
@end

/// 美天model
@interface EventModel : NSObject
@property(nonatomic, strong)NSString* feel;
/// 分享url地址
@property(nonatomic, strong)NSString* shareURL;
@property(nonatomic, strong)NSString* note;
@property(nonatomic, strong)NSString* questionURL;
/// 电话
@property(nonatomic, strong)NSString* telephone;
/// 标签
@property(nonatomic, strong)NSString* tag;
/// 编号
@property(nonatomic)NSInteger id;
/// 标题
@property(nonatomic, strong)NSString* title;
/// 详情
@property(nonatomic, strong)NSString* detail;
/// cellTitle
@property(nonatomic, strong)NSString* feeltitle;
/// 城市
@property(nonatomic, strong)NSString* city;
/// 地址
@property(nonatomic, strong)NSString* address;
/// 店详情店名
@property(nonatomic, strong)NSString* remark;
/// 顶部图片数组
@property(nonatomic, strong)NSArray* imgs;
/// 猜你喜欢
@property(nonatomic, strong)NSArray* more;      //GuessLikeModel
/// cell内容
@property(nonatomic, strong)NSString* mobileURL;
/// 位置
@property(nonatomic, strong)NSString* position;

@property(nonatomic, strong)NSArray* themes;    //ThemeModel
@property(nonatomic, strong)NSArray* events;    //EventModel
// 辅助模型
/// 标记是否需要显示距离
@property(nonatomic)BOOL isShowDis;
/// 计算出用户当前位置距离店铺我距离,单位km
@property(nonatomic, strong)NSString* distanceForUser;
@end

/// 猜你喜欢
@interface GuessLikeModel : NSObject
/// 标题
@property(nonatomic, strong)NSString* title;
/// 图片
@property(nonatomic, strong)NSArray* imgs;      //NSString
/// 地址
@property(nonatomic, strong)NSString* address;
@end

//美辑s
@interface ThemeModels : NSObject
@property(nonatomic, strong)NSString* lastdate;
@property(nonatomic, strong)NSArray* list;      //ThemeModel

+ (void)loadThemesData:(void(^)(ThemeModels* data, NSError* error))completion;
@end

