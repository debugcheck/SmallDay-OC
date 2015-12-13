//
//  theme.h
//  myday
//
//  Created by awd on 15/12/1.
//  Copyright © 2015年 awd. All rights reserved.
//

#ifndef theme_h
#define theme_h

#import <UIKit/UIKit.h>

#define NavigationH 64
#define AppWidth   [UIScreen mainScreen].bounds.size.width
#define AppHeight  [UIScreen mainScreen].bounds.size.height
#define MainBounds [UIScreen mainScreen].bounds

#define SDNavItemFont  [UIFont systemFontOfSize:16]
#define SDNavTitleFont [UIFont systemFontOfSize:18]
#define SDWebViewBacagroundColor [UIColor colorWithRed:245 green:245 blue:245 alpha:1]
#define SDBackgroundColor [UIColor colorWithRed:245 green:245 blue:245 alpha:1]
#define UMSharedAPPKey @"55e2f45b67e58ed4460012db"
#define ShareViewHeight 215
#define GitHubURL @"https://github.com/ZhongTaoTian"
#define JianShuURL @"http://www.jianshu.com/users/5fe7513c7a57/latest_articles"
#define cachesPath (NSString*)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask, YES) lastObject]
#define appShare [UIApplication sharedApplication]
#define sinaURL @"http://weibo.com/u/5622363113/home?topnav=1&wvr=6"
#define GaoDeAPPKey @"2e6b9f0a88b4a79366a13ce1ee9688b8"


#endif /* theme_h */
