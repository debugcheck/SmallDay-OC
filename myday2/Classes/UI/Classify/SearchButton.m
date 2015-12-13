
#import "SearchButton.h"


@implementation SearchButton
- (id) initWithFrame:(CGRect)frame target:(NSObject*)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    
    [self setTitle:@"搜索" forState:UIControlStateNormal];
    [self setTitle:@"取消" forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.alpha = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}
@end