//
//  ExperHeadView.m
//  myday2
//
//  Created by awd on 15/12/10.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ExperHeadView.h"
#import "theme.h"
#import "UIImageView+wnxImage.h"

@interface ExperHeadView() <UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView* scrollImageView;
@property(nonatomic, strong)UIPageControl* page;
@end

@implementation ExperHeadView
- (void) setExperModel:(ExperienceModel *)experModel
{
    if(experModel.head.count > 0) {
        self.page.numberOfPages = experModel.head.count;
        self.scrollImageView.contentSize = CGSizeMake(self.frame.size.width * experModel.head.count, 0);
        
        for(NSInteger i = 0; i < experModel.head.count; i++) {
            UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * AppWidth, 0, AppWidth, self.frame.size.height * 0.8)];
            ExperienceHeadModel* e = (ExperienceHeadModel*)experModel.head[i];
            [imageV wxn_setImageWithUrl:[NSURL URLWithString:e.adurl] placeholderImage:[UIImage imageNamed:@"quesheng"]];
            imageV.tag = i + 1000;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
            imageV.userInteractionEnabled = YES;
            [imageV addGestureRecognizer:tap];
            [self.scrollImageView addSubview:imageV];
        }
        _experModel = experModel;
    }
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = SDBackgroundColor;
    
    [self addSubview:self.scrollImageView];
    
    [self addSubview:self.page];
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8);
    self.page.frame = CGRectMake(0, self.frame.size.height * 0.8, self.frame.size.width, self.frame.size.height * 0.2);
}

#pragma lazy attribute
- (UIScrollView*) scrollImageView
{
    if(_scrollImageView == nil) {
        _scrollImageView = [[UIScrollView alloc]init];
        _scrollImageView.delegate = self;
        _scrollImageView.showsHorizontalScrollIndicator = NO;
        _scrollImageView.showsVerticalScrollIndicator = NO;
        _scrollImageView.pagingEnabled = YES;
    }
    return _scrollImageView;
}

- (UIPageControl*) page
{
    if(_page == nil) {
        _page = [[UIPageControl alloc]init];
        _page.pageIndicatorTintColor = [UIColor grayColor];
        _page.currentPageIndicatorTintColor = [UIColor blackColor];
        _page.hidesForSinglePage = YES;
    }
    return _page;
}

#pragma mark - button action
- (void) imageClick:(UITapGestureRecognizer*)tap
{
    [self.delegate experHeadView:self didClickImageViewAtIndex:tap.view.tag - 1000];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger flag = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.page.currentPage = flag;
}
@end
