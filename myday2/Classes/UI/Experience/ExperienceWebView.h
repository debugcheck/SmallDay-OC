//
//  ExperienceWebView.h
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceWebView : UIWebView
- (id) initWithFrame:(CGRect)frame webViewDelegate:(id<UIWebViewDelegate>)webDelegate webViewScrollViewDelegate:(id<UIScrollViewDelegate>)scrollDelegate;
@end
