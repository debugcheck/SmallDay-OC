//
//  ShopDetailContentView.m
//  myday2
//
//  Created by awd on 15/12/8.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "ShopDetailContentView.h"
#import "SVProgressHUD.h"
#import "theme.h"

@interface ShopDetailContentView() <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *correctBtn;
@property (nonatomic) CGFloat shopDetailContentViewHeight;
@end

@implementation ShopDetailContentView
- (id) init
{
    self = [super init];
    self.shopDetailContentViewHeight = 0;
    return self;
}

- (void) setDetailModel:(EventModel *)detailModel
{
    NSLog(@"ShopDetailContentView setDetailModel");
    self.shopName.text = detailModel.remark;
    self.phoneNumberLabel.text = detailModel.telephone;
    self.addressLabel.text = detailModel.address;
    // 计算出contentView的高度
    self.shopDetailContentViewHeight = CGRectGetMaxY(self.correctBtn.frame);
}

+ (ShopDetailContentView*) shopDetailContentViewFromXib
{
    ShopDetailContentView* shopView = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetailContentView" owner:nil options:nil] lastObject];
    
    NSLog(@"shopDetailContentView formxib");
    CGRect frame = shopView.frame;
    frame.size.width = AppWidth;
    shopView.backgroundColor = SDWebViewBacagroundColor;
    shopView.shopDetailContentViewHeight = 0;
    return shopView;
}

- (IBAction)callBtnClick:(id)sender {
    if([self.detailModel.telephone isEqual:@""]) {
        return;
    }
    [self.callActionSheet showInView:self];
}

- (IBAction)mapBtnClick:(id)sender {
    //[self mapBtnClickCallback];
}

- (UIActionSheet*) callActionSheet
{
    UIActionSheet* call = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:self.phoneNumberLabel.text otherButtonTitles:nil];
    return call;
}

- (UIActionSheet*) correctActionSheet
{
    UIActionSheet* correct = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"地址错误", @"电话错误", @"店名/店铺介绍/图片错误", @"关门/歇业/即将转让", nil];
    return correct;
}


#pragma mark UIActionSheetDelegates
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.callActionSheet) {
        if(buttonIndex == 0) {
            NSString* numURL = [NSString stringWithFormat:@"tel://%@", self.phoneNumberLabel.text];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:numURL]];
        }
    } else if (actionSheet == self.correctActionSheet) {
        switch (buttonIndex) {
            case 1:
            case 2:
            case 3:
            case 4:
                [SVProgressHUD showSuccessWithStatus:@"反馈成功" maskType:SVProgressHUDMaskTypeBlack];
                break;
            default:
                break;
        }
    }
}
@end
