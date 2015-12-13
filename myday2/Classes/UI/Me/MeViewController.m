//
//  MeViewController.m
//  myday2
//
//  Created by awd on 15/12/4.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "MeViewController.h"
#import "IconView.h"
#import "UIBarButtonItem+wxnBarButtonItem.h"
#import "SettingViewController.h"
#import "theme.h"
#import "UserAccountTool.h"
#import "SVProgressHUD.h"
#import "UIImage+wnxImage.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "MyCenterViewController.h"
#import "OrderViewController.h"
#import "RecommendViewController.h"
#import "ShakeViewController.h"

#define SD_UserIconData_Path [NSString stringWithFormat:@"%@/iconImage.data", cachesPath]


typedef NS_ENUM(NSInteger, SDMineCellType) {
    /// 个人中心
    MyCenter = 0,
    /// 我的订单
    MyOrder = 1,
    /// 我的收藏
    MyCollect = 2,
    ///  反馈留言
    Feedback = 3,
    ///  应用推荐
    RecommendApp = 4
};

@interface MeViewController()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, IconViewDelegate>
@property(nonatomic, strong)UILabel* loginLabel;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)UIImagePickerController* pickVC;
@property(nonatomic, strong)NSMutableArray* mineIcons;
@property(nonatomic, strong)UIActionSheet* iconActionSheet;
@property(nonatomic, strong)NSMutableArray* mineTitles;
@property(nonatomic, strong)IconView* iconView;
@end

@implementation MeViewController

#pragma mark - lazy attributes
- (UIImagePickerController*)pickVC
{
    if(_pickVC == nil) {
        _pickVC = [[UIImagePickerController alloc]init];
        _pickVC.delegate = self;
        _pickVC.allowsEditing = YES;
    }
    return _pickVC;
}

- (NSMutableArray*) mineIcons
{
    if(_mineIcons == nil) {
        _mineIcons = [NSMutableArray arrayWithObjects:@"usercenter", @"orders", @"setting_like", @"feedback", @"recomment", nil];
    }
    return _mineIcons;
}

- (UIActionSheet*) iconActionSheet
{
    if(_iconActionSheet == nil) {
        _iconActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    }
    return _iconActionSheet;
}

- (NSMutableArray*)mineTitles
{
    if(_mineTitles == nil) {
        _mineTitles = [NSMutableArray arrayWithObjects:@"个人中心", @"我的订单", @"我的收藏", @"留言反馈", @"应用推荐", nil];
    }
    return _mineTitles;
}

- (IconView*) iconView
{
    if(_iconView == nil) {
        _iconView = [[IconView alloc]init];
    }
    return _iconView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
}

- (void) setNav
{
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"settinghhhh" highImageName:@"settingh" target:self action:@selector(settingClick)];
}

- (void) setTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, AppHeight - NavigationH - 49) style: UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.sectionFooterHeight = 0.1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    // 设置tableView的headerView
    CGFloat iconImageViewHeight = 180;
    UIImageView* iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AppWidth, iconImageViewHeight)];
    iconImageView.image = [UIImage imageNamed:@"quesheng"];
    iconImageView.userInteractionEnabled = YES;
    
    // 添加未登录的文字
    CGFloat loginLabelHeight = 40;
    self.loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImageViewHeight - loginLabelHeight, AppWidth, loginLabelHeight)];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    self.loginLabel.text = @"登陆,开始我的小日子";
    self.loginLabel.font = [UIFont systemFontOfSize:16];
    self.loginLabel.textColor = [UIColor colorWithRed:80 green:80 blue:80 alpha:1];
    [iconImageView addSubview:self.loginLabel];
    
    // 添加iconImageView
    self.iconView = [[IconView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.iconView.delegate = self;
    self.iconView.center = CGPointMake(iconImageView.frame.size.width * 0.5, (iconImageViewHeight - loginLabelHeight) * 0.5 + 8);
    [iconImageView addSubview:self.iconView];
    
    self.tableView.tableHeaderView = iconImageView;
}

- (void) settingClick
{
    SettingViewController* settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated: YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginLabel.hidden = [UserAccountTool userIsLogin];
    if([UserAccountTool userIsLogin]) {
        NSData* data = [NSData dataWithContentsOfFile:SD_UserIconData_Path];
        if(data) {
            [self.iconView.iconButton setImage:[[UIImage imageWithData:data] imageClipOvalImage] forState:UIControlStateNormal];
        } else {
            [self.iconView.iconButton setImage:[UIImage imageNamed:@"my"] forState:UIControlStateNormal];
        }
    } else {
        [self.iconView.iconButton setImage:[UIImage imageNamed:@"my"] forState:UIControlStateNormal];
    }
}


#pragma mark - iconViewDelegate
- (void) iconView:(IconView*)iconView didClick:(UIButton*)iconButton
{
    // TODO 判断用户是否登录了
    if([UserAccountTool userIsLogin]) {
        [self.iconActionSheet showInView:self.view];
    } else {
        LoginViewController* login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //print(buttonIndex, terminator: "");
    switch (buttonIndex) {
        case 1:
            [self openCamera];
            break;
        case 2:
            [self openUserPhotoLibrary];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void) openCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.pickVC animated:YES completion:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"模拟器没有摄像头,请链接真机调试" maskType: SVProgressHUDMaskTypeBlack];
    }
}

- (void) openUserPhotoLibrary
{
    self.pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickVC.allowsEditing = YES;
    [self presentViewController:self.pickVC animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info

{
    // 对用户选着的图片进行质量压缩,上传服务器,本地持久化存储
    NSString* typeStr = info[UIImagePickerControllerMediaType];
    if(typeStr) {
        if([typeStr isEqual:@"public.image"]) {
            UIImage* image = info[UIImagePickerControllerEditedImage];
            if(image) {
                NSData* data = nil;
                UIImage* smallImage = [UIImage imageClipToNewImage:image newSize:self.iconView.iconButton.frame.size];
                if(UIImagePNGRepresentation(smallImage) == nil) {
                    data = UIImageJPEGRepresentation(smallImage, 0.8);
                } else {
                    data = UIImagePNGRepresentation(smallImage);
                }
                
                if(data != nil) {
                    // TODO: 将头像的data传入服务器
                    // 本地也保留一份data数据
                    @try{
                        [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }@catch(NSException* e) {
                    }
                    [[NSFileManager defaultManager] createFileAtPath:SD_UserIconData_Path contents: data attributes:nil];
                    
                    [self.iconView.iconButton setImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:SD_UserIconData_Path]] imageClipOvalImage] forState:UIControlStateNormal];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"照片保存失败" maskType:SVProgressHUDMaskTypeBlack];
                }
            }
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"图片无法获取" maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [picker dismissViewControllerAnimated:YES completion: nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self.pickVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return self.mineIcons.count;
    } else {
        return 1;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString* identifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:(NSString*)self.mineIcons[indexPath.row]];
        cell.textLabel.text = (NSString*)self.mineTitles[indexPath.row];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"yaoyiyao"];
        cell.textLabel.text = @"摇一摇 每天都有小惊喜";
    }
    
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == Feedback) {         // 留言反馈
            FeedbackViewController* feedbackVC = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        } else if(indexPath.row == MyCenter) {  // 个人中心
            if([UserAccountTool userIsLogin]) {
                MyCenterViewController* myCenterVC = [[MyCenterViewController alloc]init];
                [self.navigationController pushViewController:myCenterVC animated:YES];
            } else {
                LoginViewController* login = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
            }
            
        } else if(indexPath.row == MyCollect) { // 我的收藏
            
        } else if(indexPath.row == MyOrder) {   // 我的订单
            if([UserAccountTool userIsLogin]) {
                OrderViewController* orderVC = [[OrderViewController alloc]init];
                [self.navigationController pushViewController:orderVC animated:YES];
            } else {
                LoginViewController* login = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
            }
        } else {                                                        // 应用推荐
            RecommendViewController* rmdVC = [[RecommendViewController alloc]init];
            [self.navigationController pushViewController:rmdVC animated:YES];
        }
        
    } else {
        ShakeViewController* shakeVC = [[ShakeViewController alloc]init];
        [self.navigationController pushViewController:shakeVC animated:YES];
    }
}
@end
