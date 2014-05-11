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
#import "Staff.h"
#import "StaffCell.h"
#import "StaffDetailViewController.h"
#import "StaffsViewController.h"

@interface StaffsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, DropDownDelegate, CityPickViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;

@property (nonatomic, strong) NSMutableArray *areaDatasource;
@property (nonatomic, strong) NSMutableArray *areaIdDatasource;
@property (nonatomic, strong) NSArray *sortDatasource;

@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int sortSelectedIndex;

@end

@implementation StaffsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"StaffsViewController.Title", nil);
        self.currentPage = 1;

        self.areaDatasource = [NSMutableArray array];
        self.areaIdDatasource = [NSMutableArray array];
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

    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsBookmarkButton = NO;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;

    [self.tableView.panGestureRecognizer addTarget:self action:@selector(panHandler:)];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getStaffs];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getStaffs];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self fillAreaDropdown:[[CityManager SharedInstance] getSelectedCity].id];
    self.sortDatasource = @[@"默认排序", @"离我最近", @"评分最高", @"作品数量"];

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

- (void)leftNavItemClick
{
    CityListViewController *picker = [CityListViewController new];
    picker.selectedCity = [[CityManager SharedInstance] getSelectedCity];
    picker.enableLocation = YES;
    picker.delegate = self;

    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
                                            animated:YES completion:nil];
}

- (void)fillAreaDropdown:(int)cityId
{
    [self.areaDatasource removeAllObjects];
    [self.areaIdDatasource removeAllObjects];

    [self.areaDatasource addObject:@"全部区域"];
    [self.areaIdDatasource addObject:@"0"];

    [self.areaBtn setTitle:@"全部区域" forState:UIControlStateNormal];
    self.areaSelectedIndex = 0;

    NSArray *cityArray = [[CityManager SharedInstance] getAreaListByCity:cityId];
    for (City *c in cityArray) {
        [self.areaDatasource addObject:c.name];
        [self.areaIdDatasource addObject:@(c.id)];
    }
}

- (void)didPickCity:(City *)city
{
    [[CityManager SharedInstance] setSelectedCity:city.id];
    [self setTopLeftCityName];

    [self.dropDownPicker hide];

    [self fillAreaDropdown:[[CityManager SharedInstance] getSelectedCity].id];

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}

- (void)dropDownBtnClick:(id)sender
{
    [self.searchBar resignFirstResponder];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}

- (void)panHandler:(UIPanGestureRecognizer *)pan
{
    [self.searchBar resignFirstResponder];
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
    static NSString * cellIdentifier = @"StaffCellIdentifier";
    StaffCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0 ?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Staff *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffDetailViewController *vc = [StaffDetailViewController new];
    vc.staff = [self.datasource objectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffCell * cell = (StaffCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = [UIColor colorWithHexString:@"#eee"];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffCell * cell = (StaffCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0 ?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
}

#pragma mark Staff Search API

- (void)getStaffs
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:self.searchBar.text forKey:@"searchText"];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[CityManager SharedInstance] getSelectedCity].id] forKey:@"city"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.areaSelectedIndex] forKey:@"district"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.sortSelectedIndex] forKey:@"sort"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_STAFFS_SEARCH] andParam:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetStaffs:)];
    [request setDidFailSelector:@selector(failGetStaffs:)];
    [request startAsynchronous];
}

- (void)finishGetStaffs:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"staffs"];

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
        [arr addObject:[[Staff alloc] initWithDic:dicData]];
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

- (void)failGetStaffs:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

@end
