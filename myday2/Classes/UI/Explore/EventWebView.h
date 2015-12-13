//
//  EventWebView.h
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventWebView : UIWebView
- (id) init:(CGRect)rect webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate webViewScrollViewDelegate:(id<UIScrollViewDelegate>)webViewScrollViewDelegate;
@end
