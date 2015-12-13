//
//  SearchViewController.m
//  myday2
//
//  Created by awd on 15/12/11.
//  Copyright © 2015年 awd. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "ClassifyModel.h"
#import "DetailCell.h"
#import "EveryDayModel.h"
#import "EventViewController.h"
#import "theme.h"

#define searchViewH  50
#define SD_DetailCell_Identifier @"DetailCell"

@interface SearchViewController () <SearchViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)SearchView* searchView;
@property(nonatomic, strong)SearchsModel* searchModel;
@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)NSArray* hotSearchs;
@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)NSMutableArray* hotBtns;
@property(nonatomic, strong)UILabel* hotLabel;
@end

@implementation SearchViewController

- (UITableView*) tableView
{
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchViewH, AppWidth, AppHeight - searchViewH) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 230;
        _tableView.hidden = YES;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:SD_DetailCell_Identifier];
    }
    return _tableView;
}

- (NSMutableArray*) hotBtns
{
    if(_hotBtns == nil) {
        _hotBtns = [[NSMutableArray alloc]init];
    }
    return _hotBtns;
}

- (NSArray*) hotSearchs
{
    if(_hotSearchs == nil) {
        _hotSearchs = [[NSArray alloc]initWithObjects:@"北京", @"东四", @"南锣鼓巷", @"798", @"三里屯", @"维尼的小熊", nil];
    }
    return _hotSearchs;
}
- (UILabel*) hotLabel
{
    if(_hotLabel == nil) {
        _hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50)];
        _hotLabel.textAlignment = NSTextAlignmentCenter;
        _hotLabel.textColor = [UIColor blackColor];
        _hotLabel.font = [UIFont systemFontOfSize:16];
        _hotLabel.text = @"热门搜索";
    }
    return _hotLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = SDBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillshow) name: UIKeyboardWillShowNotification object:nil];
    // 添加顶部的searchView
    [self setUpSearchView];
    
    [self setUpScrollView];
    
    [self setUpTableView];
}

- (void) setUpScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, searchViewH, AppWidth, AppHeight - searchViewH)];
    self.scrollView.backgroundColor = SDBackgroundColor;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    [self.view addSubview:self.scrollView];
    
    if(self.hotSearchs.count > 0) {
        [self.scrollView addSubview:self.hotLabel];
        CGFloat margin = 10;
        CGFloat btnH = 32;
        
        CGFloat btnY = CGRectGetMaxY(self.hotLabel.frame);
        CGFloat btnW = 0;
        CGFloat textMargin = 35;
        for(NSInteger i = 0; i < self.hotSearchs.count; i++) {
            UIButton* btn = [[UIButton alloc]init];
            [btn setTitle:self.hotSearchs[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel sizeToFit];
            [btn setBackgroundImage:[UIImage imageNamed:@"populartags"] forState:UIControlStateNormal];
            btnW = btn.titleLabel.frame.size.width + textMargin;
            [btn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if(self.hotBtns.count > 0) {
                UIButton* lastBtn = [self.hotBtns lastObject];
                CGFloat freeW = AppWidth - CGRectGetMaxX(lastBtn.frame);
                if(freeW > btnW + 2 * margin) {
                    btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame) + margin, btnY, btnW, btnH);
                } else {
                    btnY = CGRectGetMaxY(lastBtn.frame) + margin;
                    btn.frame = CGRectMake(margin, btnY, btnW, btnH);
                }
                [self.hotBtns addObject:btn];
                [self.scrollView addSubview:btn];
            } else {
                btn.frame = CGRectMake(margin, btnY, btnW, btnH);
                [self.hotBtns addObject:btn];
                [self.scrollView addSubview:btn];
            }
        }
    }
}

- (void) setUpTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void) setUpSearchView
{
    self.searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, searchViewH)];
    self.searchView.backgroundColor = [UIColor colorWithRed:24 green: 247 blue: 247 alpha: 1];
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
}

- (void) searchBtnClick:(UIButton*)sender
{
    NSString* text = sender.titleLabel.text;
    [self searchDetail:text];
    
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

- (void) searchDetail:(NSString*)title
{
    self.searchView.searchTextField.text = title;
    self.searchModel = nil;
    [self.searchView.searchTextField resignFirstResponder];
    
    __weak SearchViewController* tmpSelf = self;
    [SearchsModel loadSearchsModel:title completion:^(SearchsModel* data, NSError* error){
        if(error != nil) {//添加搜索失败view
            return;
        }
        
        tmpSelf.searchModel = data;
        tmpSelf.tableView.hidden = NO;
        tmpSelf.scrollView.hidden = YES;
        [tmpSelf.tableView reloadData];
        tmpSelf.searchView.searchBtn.selected = YES;
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchView.searchTextField becomeFirstResponder];
}

- (void) keyBoardWillshow
{
    self.scrollView.hidden = NO;
    self.tableView.hidden = YES;
    self.searchModel = nil;
    [self.tableView reloadData];
}

- (void) hideKeyboard
{
    [self.searchView.searchTextField resignFirstResponder];
    [self.searchView resumeSearchTextField];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchModel.list.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DetailCell* cell = (DetailCell*)[tableView dequeueReusableCellWithIdentifier:SD_DetailCell_Identifier];
    EventModel* everyModel = self.searchModel.list[indexPath.row];
    cell.model = everyModel;
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    EventModel* eventModel = self.searchModel.list[indexPath.row];
    EventViewController *searchDetailVC = [[EventViewController alloc]init];
    searchDetailVC.model = eventModel;
    [self.navigationController pushViewController:searchDetailVC animated:YES];
}
#pragma mark - SearchViewDelegate
- (void) searchView:(SearchView*)searchView searchTitle:(NSString*)searchTitle
{
    [self searchDetail:searchTitle];
}
@end
