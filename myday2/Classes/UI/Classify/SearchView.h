//
//  SearchView.h
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTextField.h"

@class SearchView;

@protocol SearchViewDelegate <NSObject>
- (void) searchView:(SearchView*)searchView searchTitle:(NSString*)searchTitle;
@end

@interface SearchView : UIView
@property(nonatomic, strong)SearchTextField* searchTextField;
@property(nonatomic, strong)UIButton* searchBtn;

@property(nonatomic, strong)id<SearchViewDelegate> delegate;

- (void) resumeSearchTextField;
@end
