// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "GroupsViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "GroupDetailViewController.h"
#import "GroupCell.h"
#import "Group.h"
#import "DropDownView.h"

@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate, DropDownDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *hotBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;
@property (nonatomic, strong) NSArray *areaDatasource;
@property (nonatomic, strong) NSArray *hotDatasource;
@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int hotSelectedIndex;
@end

@implementation GroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"GroupsViewController.Title", nil);
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftNavItemTitle = @"济南";
    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    [self.view addSubview:topTabView];
    topTabView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.areaBtn.frame = CGRectMake(0, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.areaBtn setTitle:@"地区" forState:UIControlStateNormal];
    self.areaBtn.tag = 0;
    self.areaBtn.backgroundColor = [UIColor whiteColor];
    [self.areaBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.areaBtn];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.areaBtn), 10, 1, 20)];
    separatorView.backgroundColor = [UIColor grayColor];
    [topTabView addSubview:separatorView];
    
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.hotBtn.frame = CGRectMake(MaxX(self.areaBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.hotBtn setTitle:@"热度" forState:UIControlStateNormal];
    self.hotBtn.backgroundColor = [UIColor whiteColor];
    self.hotBtn.tag = 1;
    [self.hotBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.hotBtn];

    // draw shadow
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_TAB_BAR_HEIGHT -1, WIDTH(topTabView), 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:shadowView];
    topTabView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.7];
    
    self.tableView = [[UITableView alloc] init];
    float tableHeight = isIOS7 ?
    HEIGHT(self.view) - MaxY(topTabView) - kBottomBarHeight :
    HEIGHT(self.view) - kTopBarHeight - MaxY(topTabView)  - kBottomBarHeight ;
    self.tableView.frame = CGRectMake(0,
                                      MaxY(topTabView),
                                      WIDTH(self.view) ,
                                      tableHeight);
    debugLog(@"%f",MaxY(topTabView));
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
//        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeGroupList]];

    
    self.areaDatasource = @[@"高新区",@"历下区",@"历城区",@"市中区"];
    self.hotDatasource = @[@"默认",@"好评",@"评价",@"销量"];
    
    float dropDownHeight = tableHeight + kBottomBarHeight;
    self.dropDownPicker = [[DropDownView alloc] initWithFrame:CGRectMake(0,
                                                                         self.topBarOffset + HEIGHT(self.areaBtn),
                                                                         WIDTH(self.view),
                                                                         dropDownHeight)
                                                contentHeight:dropDownHeight/2];
    self.dropDownPicker.delegate = self;
    [self.view addSubview:self.dropDownPicker];
    [self.view bringSubviewToFront:topTabView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dropDownBtnClick:(id)sender
{
    [self.dropDownPicker hide];
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
            [self.dropDownPicker showData:self.areaDatasource
                            selectedIndex:self.areaSelectedIndex
                              pointToView:btn];
            break;
        case 1:
            [self.dropDownPicker showData:self.hotDatasource
                            selectedIndex:self.hotSelectedIndex
                              pointToView:btn];
            break;
        default:
            break;
    }
}

- (void)didPickItemAtIndex:(int)index forView:(UIView *)view
{
    if([view isEqual:self.areaBtn]){
        self.areaSelectedIndex  = index;
        NSString *title = [self.areaDatasource objectAtIndex:index];
        [self.areaBtn setTitle:title forState:UIControlStateNormal];
    }else if([view isEqual:self.hotBtn]){
        self.hotSelectedIndex  = index;
        NSString *title = [self.hotDatasource objectAtIndex:index];
        [self.hotBtn setTitle:title forState:UIControlStateNormal];
    }
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GroupCellIdentifier";
    GroupCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Group *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[GroupDetailViewController new] animated:YES];
}

//- (void)pushToDetial:(Group *)work
//{
//    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
//    workVc.work = work;
//    [self.navigationController pushViewController:workVc animated:YES];
//}


@end
