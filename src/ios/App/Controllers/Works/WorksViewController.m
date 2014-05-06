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

#import "BrickView.h"
#import "City.h"
#import "CityListViewController.h"
#import "CityManager.h"
#import "Comment.h"
#import "DropDownView.h"
#import "StaffDetailViewController.h"
#import "WorkCell.h"
#import "WorkDetailViewController.h"
#import "WorksViewController.h"

@interface WorksViewController ()<BrickViewDelegate, BrickViewDataSource, DropDownDelegate,CityPickViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) BrickView *tableView;

@property (nonatomic, strong) UIButton *hairStyleBtn;
@property (nonatomic, strong) UIButton *genderBtn;
@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;

@property (nonatomic, strong) NSArray *hairStyleDatasource;
@property (nonatomic, strong) NSArray *genderDatasource;
@property (nonatomic, strong) NSArray *sortDatasource;

@property (nonatomic) int hairStyleSelectedIndex;
@property (nonatomic) int genderSelectedIndex;
@property (nonatomic) int sortSelectedIndex;

@end

@implementation WorksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"WorksViewController.Title", nil);

        self.currentPage = 1;

        self.hairStyleDatasource = @[@"所有发质", @"短发", @"长发", @"编发", @"中发"];
        self.genderDatasource = @[@"所有人", @"男士", @"女士"];
        self.sortDatasource = @[@"默认排序", @"最新发型", @"最受欢迎"];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
}

- (void)leftNavItemClick
{
    CityListViewController *picker = [CityListViewController new];
    picker.selectedCity = [[CityManager SharedInstance] getSelectedCity];
    picker.enableLocation = YES;
    picker.delegate = self;

    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
                                            animated:YES completion:nil];
}

- (void)didPickCity:(City *)city
{
    [[CityManager SharedInstance] setSelectedCity:city.id];
    [self setTopLeftCityName];

    [self.dropDownPicker hide];

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopLeftCityName];

    float topTabButtonWidth = WIDTH(self.view)/3;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    topTabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topTabView];

    UIView *topTabBottomShadowView = [[UIView alloc] initWithFrame:topTabView.frame];
    topTabBottomShadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabBottomShadowView drawBottomShadowOffset:1 opacity:1];
    [self.view addSubview:topTabBottomShadowView];

    self.hairStyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hairStyleBtn.backgroundColor = [UIColor whiteColor];
    [self.hairStyleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.hairStyleBtn.frame = CGRectMake(0, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.hairStyleBtn setTitle:@"发质" forState:UIControlStateNormal];
    self.hairStyleBtn.tag = 0;
    [self.hairStyleBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.hairStyleBtn];

    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.hairStyleBtn), 10, 1, 20)];
    separatorView1.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:separatorView1];
    
    self.genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.genderBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.genderBtn.frame = CGRectMake(MaxX(self.hairStyleBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.genderBtn setTitle:@"性别" forState:UIControlStateNormal];
    self.genderBtn.tag = 1;
    self.genderBtn.backgroundColor = [UIColor whiteColor];
    [self.genderBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.genderBtn];

    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.genderBtn), 10, 1, 20)];
    separatorView2.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:separatorView2];
    
    self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sortBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.sortBtn.frame = CGRectMake(MaxX(self.genderBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.sortBtn setTitle:@"排序" forState:UIControlStateNormal];
    self.sortBtn.tag = 2;
    self.sortBtn.backgroundColor = [UIColor whiteColor];
    [self.sortBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.sortBtn];

    
    self.tableView = [[BrickView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset + topTabView.height,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:YES] - topTabView.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.padding = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getWorks];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getWorks];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    
    float dropDownHeight = [self contentHeightWithNavgationBar:YES withBottomBar:YES] + kBottomBarHeight;
    self.dropDownPicker = [[DropDownView alloc] initWithFrame:CGRectMake(0,
                                                                        self.topBarOffset + HEIGHT(self.hairStyleBtn),
                                                                         WIDTH(self.view),
                                                                         dropDownHeight)
                                                contentHeight:dropDownHeight/2];
    self.dropDownPicker.delegate = self;

    [self.view bringSubviewToFront:topTabBottomShadowView];
    [self.view addSubview:self.dropDownPicker];
    [self.view bringSubviewToFront:topTabView];

    [self.tableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTopLeftCityName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dropDownBtnClick:(id)sender
{
    [self.dropDownPicker hide];
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
            [self.dropDownPicker showData:self.hairStyleDatasource
                            selectedIndex:self.hairStyleSelectedIndex
                              pointToView:btn];
            break;
        case 1:
            [self.dropDownPicker showData:self.genderDatasource
                            selectedIndex:self.genderSelectedIndex
                          pointToView:btn];
            break;
        case 2:
            [self.dropDownPicker showData:self.sortDatasource
                            selectedIndex:self.sortSelectedIndex
                              pointToView:btn];
            break;
        default:
            break;
    }
}

- (void)didPickItemAtIndex:(int)index forView:(UIView *)view
{
    if([view isEqual:self.hairStyleBtn]){
        self.hairStyleSelectedIndex  = index;
        NSString *title = [self.hairStyleDatasource objectAtIndex:index];
        [self.hairStyleBtn setTitle:title forState:UIControlStateNormal];
    } else if ([view isEqual:self.genderBtn]) {
        self.genderSelectedIndex  = index;
        NSString *title = [self.genderDatasource objectAtIndex:index];
        [self.genderBtn setTitle:title forState:UIControlStateNormal];
    } else if ([view isEqual:self.sortBtn]) {
        self.sortSelectedIndex  = index;
        NSString *title = [self.sortDatasource objectAtIndex:index];
        [self.sortBtn setTitle:title forState:UIControlStateNormal];
    }

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}

#pragma mark UITableView delegate

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 206;
}

- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 2;
}

- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return  self.datasource.count;
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    static NSString * cellIdentifier = @"WorkCellIdentifier";
    WorkCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WorkCell alloc] initWithReuseIdentifier:cellIdentifier];
    }

    __weak WorksViewController *selfDelegate = self;
    [cell setupWithData:[self.datasource objectAtIndex:index] tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetial:work];
    }];

    return cell;
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}

#pragma mark Work Search API

- (void)getWorks
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.genderSelectedIndex] forKey:@"gender"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.hairStyleSelectedIndex] forKey:@"hairStyle"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.sortSelectedIndex] forKey:@"sort"];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[CityManager SharedInstance] getSelectedCity].id] forKey:@"city"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_WORKS_SEARCH] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetWorks:)];
    [request setDidFailSelector:@selector(failGetWorks:)];
    [request startAsynchronous];
}

- (void)finishGetWorks:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"works"];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datasource];

    if (self.currentPage == 1) {
        [arr removeAllObjects];
    } else {
        if (self.currentPage % TABLEVIEW_PAGESIZE_DEFAULT > 0) {
            int i;

            for (i = 0; i < arr.count; i++) {
                if (i >= (self.currentPage - 1) * TABLEVIEW_PAGESIZE_DEFAULT) {
                    [arr removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }

    for (NSDictionary *dicData in dataList) {
        [arr addObject:[[Work alloc] initWithDic:dicData]];
    }

    self.datasource = arr;

    BOOL enableInfinite = total > self.datasource.count;
    if (self.tableView.showsInfiniteScrolling != enableInfinite) {
        self.tableView.showsInfiniteScrolling = enableInfinite;
    }

    if (self.currentPage == 1) {
        [self.tableView stopRefreshAnimation];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }

    [self checkEmpty];

    [self.tableView reloadData];
}

- (void)failGetWorks:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{

}

@end
