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

#import "WorksViewController.h"
#import "CityListViewController.h"
#import "WorkDetailViewController.h"
#import "StaffDetailViewController.h"
#import "WorkCell.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "DropDownView.h"

@interface WorksViewController ()<UITableViewDataSource, UITableViewDelegate, DropDownDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *colorBtn;
@property (nonatomic, strong) UIButton *lengthBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;
@property (nonatomic, strong) NSArray *areaDatasource;
@property (nonatomic, strong) NSArray *colorDatasource;
@property (nonatomic, strong) NSArray *lengthDatasource;
@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int colorSelectedIndex;
@property (nonatomic) int lengthSelectedIndex;
@end

@implementation WorksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"WorksViewController.Title", nil);
    }
    return self;
}

- (void) loadView
{
    [super loadView];

}

- (void)leftNavItemClick
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[CityListViewController new]] animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftNavItemTitle = @"济南";

    float topTabButtonWidth = WIDTH(self.view)/3;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    [self.view addSubview:topTabView];
    topTabView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.areaBtn.backgroundColor = [UIColor whiteColor];
    [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.areaBtn.frame = CGRectMake(0, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.areaBtn setTitle:@"地区" forState:UIControlStateNormal];
    self.areaBtn.tag = 0;
    [self.areaBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.areaBtn];
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.areaBtn), 10, 1, 20)];
    separatorView1.backgroundColor = [UIColor grayColor];
    [topTabView addSubview:separatorView1];
    
    self.colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.colorBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.colorBtn.frame = CGRectMake(MaxX(self.areaBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
    self.colorBtn.tag = 1;
    self.colorBtn.backgroundColor = [UIColor whiteColor];
    [self.colorBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.colorBtn];
    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.colorBtn), 10, 1, 20)];
    separatorView2.backgroundColor = [UIColor grayColor];
    [topTabView addSubview:separatorView2];
    
    self.lengthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lengthBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.lengthBtn.frame = CGRectMake(MaxX(self.colorBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.lengthBtn setTitle:@"长度" forState:UIControlStateNormal];
    self.lengthBtn.tag = 2;
    self.lengthBtn.backgroundColor = [UIColor whiteColor];
    [self.lengthBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.lengthBtn];
    // draw shadow
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_TAB_BAR_HEIGHT -1, WIDTH(topTabView), 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:shadowView];
    topTabView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.7];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      self.tableViewHeight);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:topTabView.bounds];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    [self.view bringSubviewToFront:topTabView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeWorkList]];
    
    self.areaDatasource = @[@"高新区",@"历下区",@"历城区",@"市中区"];
    self.colorDatasource = @[@"红色",@"黄色",@"黑色",@"白色"];
    self.lengthDatasource = @[@"寸头",@"短发",@"刘海",@"披肩"];
    
    float dropDownHeight = self.tableViewHeight + kBottomBarHeight;
    self.dropDownPicker = [[DropDownView alloc] initWithFrame:CGRectMake(0,
                                                                        self.topBarOffset + HEIGHT(self.areaBtn),
                                                                         WIDTH(self.view),
                                                                         dropDownHeight)
                                                contentHeight:dropDownHeight/2];
    self.dropDownPicker.delegate = self;
    [self.view addSubview:self.dropDownPicker];
    [self.view bringSubviewToFront:topTabView];
}


- (void)insertRowAtTop
{
    int64_t delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView stopRefreshAnimation];
    });
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
            [self.dropDownPicker showData:self.colorDatasource
                            selectedIndex:self.colorSelectedIndex
                          pointToView:btn];
            break;
        case 2:
            [self.dropDownPicker showData:self.lengthDatasource
                            selectedIndex:self.lengthSelectedIndex
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
    }else if([view isEqual:self.colorBtn]){
        self.colorSelectedIndex  = index;
        NSString *title = [self.colorDatasource objectAtIndex:index];
        [self.colorBtn setTitle:title forState:UIControlStateNormal];
    }else if([view isEqual:self.lengthBtn]){
        self.lengthSelectedIndex  = index;
        NSString *title = [self.lengthDatasource objectAtIndex:index];
        [self.lengthBtn setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ceil(self.datasource.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"WorkCellIdentifier";
    WorkCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Work *leftdata = [self.datasource objectAtIndex: (2 * indexPath.row)];
    Work *rightdata = nil;
    if(2 * (indexPath.row + 1) <= self.datasource.count){
        rightdata = [self.datasource objectAtIndex: (2 * indexPath.row)];
    }
    __weak WorksViewController *selfDelegate = self;
    [cell setupWithLeftData:leftdata rightData:rightdata tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetial:work];}
     ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}


@end
