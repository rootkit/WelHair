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

#import "CityManager.h"
#import "CityListViewController.h"
#import "DropDownView.h"
#import "Group.h"
#import "GroupCell.h"
#import "GroupDetailViewController.h"
#import "GroupsViewController.h"

@interface GroupsViewController () <UITableViewDataSource, UITableViewDelegate, DropDownDelegate, CityPickViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;

@property (nonatomic, strong) NSArray *areaDatasource;
@property (nonatomic, strong) NSArray *areaIdDatasource;
@property (nonatomic, strong) NSArray *sortDatasource;

@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int sortSelectedIndex;

@end

@implementation GroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"GroupsViewController.Title", nil);
        self.currentPage = 1;
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

    [self setTopLeftCityName];

    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    UIView *topTabBottomShadowView = [[UIView alloc] initWithFrame:topTabView.frame];
    topTabBottomShadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabBottomShadowView drawBottomShadowOffset:1 opacity:1];
    [self.view addSubview:topTabBottomShadowView];
    [self.view addSubview:topTabView];
    topTabView.backgroundColor = [UIColor whiteColor];
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
    
    self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sortBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.sortBtn.frame = CGRectMake(MaxX(self.areaBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.sortBtn setTitle:@"排序" forState:UIControlStateNormal];
    self.sortBtn.backgroundColor = [UIColor whiteColor];
    self.sortBtn.tag = 1;
    [self.sortBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.sortBtn];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset + topTabView.height,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:YES] - topTabView.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getGroups];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getGroups];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    
    self.areaDatasource = @[@"全部地区"];
    self.sortDatasource = @[@"默认排序", @"离我最近", @"评分最高"];
    
    float dropDownHeight = [self contentHeightWithNavgationBar:YES withBottomBar:YES] + kBottomBarHeight;
    self.dropDownPicker = [[DropDownView alloc] initWithFrame:CGRectMake(0,
                                                                         self.topBarOffset + HEIGHT(self.areaBtn),
                                                                         WIDTH(self.view),
                                                                         dropDownHeight)
                                                contentHeight:dropDownHeight/2];
    self.dropDownPicker.delegate = self;
    [self.view bringSubviewToFront:topTabBottomShadowView];
    [self.view addSubview:self.dropDownPicker];
    [self.view bringSubviewToFront:topTabView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
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
    if ([view isEqual:self.areaBtn]) {
        self.areaSelectedIndex  = index;
        NSString *title = [self.areaDatasource objectAtIndex:index];
        [self.areaBtn setTitle:title forState:UIControlStateNormal];
    } else if ([view isEqual:self.sortBtn]) {
        self.sortSelectedIndex  = index;
        NSString *title = [self.sortDatasource objectAtIndex:index];
        [self.sortBtn setTitle:title forState:UIControlStateNormal];
    }

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}


#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GroupCellIdentifier";

    GroupCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];

    Group *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupDetailViewController *vc = [GroupDetailViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Work Search API

- (void)getGroups
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[CityManager SharedInstance] getSelectedCity].id] forKey:@"city"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.areaSelectedIndex] forKey:@"district"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.sortSelectedIndex] forKey:@"sort"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_COMPANIES_SEARCH] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetGroups:)];
    [request setDidFailSelector:@selector(failGetGroups:)];
    [request startAsynchronous];
}

- (void)finishGetGroups:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"companies"];

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
        [arr addObject:[[Group alloc] initWithDic:dicData]];
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

- (void)failGetGroups:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

@end
