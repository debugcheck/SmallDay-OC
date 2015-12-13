
#import "SearchTextField.h"

@interface SearchTextField()
@property(nonatomic, strong)UIView* leftV;
@property(nonatomic, strong)UIImageView* leftImageView;
@end

@implementation SearchTextField
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    self.leftV = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 10 * 2 + self.leftImageView.frame.size.width, 30)];
    frame = self.leftImageView.frame;
    frame.origin = CGPointMake(5, (self.leftV.frame.size.height - self.leftImageView.frame.size.height) * 0.5);
    self.leftImageView.frame = frame;
    [self.leftV addSubview:self.leftImageView];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.leftView = self.leftV;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.background = [UIImage imageNamed:@"searchbox"];
    self.placeholder = @"爱好 主题 标签 店名";
        
    self.clearButtonMode = UITextFieldViewModeAlways;
    
    return self;
}

 - (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.leftView.frame;
    frame.origin.x = 10;
    self.leftView.frame = frame;
}
@end