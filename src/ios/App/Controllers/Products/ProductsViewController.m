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
#import "CityListViewController.h"
#import "CityManager.h"
#import "DropDownView.h"
#import "Product.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "ProductsViewController.h"
#import "WelQRReaderViewController.h"

@interface ProductsViewController () <BrickViewDelegate, BrickViewDataSource, DropDownDelegate, WelQRReaderDelegate, CityPickViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) BrickView *tableView;

@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;

@property (nonatomic, strong) NSMutableArray *areaDatasource;
@property (nonatomic, strong) NSMutableArray *areaIdDatasource;
@property (nonatomic, strong) NSArray *sortDatasource;

@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int sortSelectedIndex;

@end

@implementation ProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProductsViewController.Title", nil);
        self.currentPage = 1;

        FAKIcon *searchIcon = [FAKFontAwesome qrcodeIconWithSize:NAV_BAR_ICON_SIZE];
        [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg = [searchIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.areaDatasource = [NSMutableArray array];
        self.areaIdDatasource = [NSMutableArray array];
        
    }

    return self;
}

- (void)rightNavItemClick
{
    WelQRReaderViewController *scanner = [WelQRReaderViewController new];
    scanner.delegate = self;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:scanner] animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view), TOP_TAB_BAR_HEIGHT)];
    topTabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topTabView];

    UIView *topTabBottomShadowView = [[UIView alloc] initWithFrame:topTabView.frame];
    topTabBottomShadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabBottomShadowView drawBottomShadowOffset:1 opacity:1];
    [self.view addSubview:topTabBottomShadowView];

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

    self.tableView = [[BrickView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset + topTabView.height,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:YES] - topTabView.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.padding = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getGoods];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getGoods];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self fillAreaDropdown:[[CityManager SharedInstance] getSelectedCity].id];
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
    
    [self.tableView triggerPullToRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTopLeftCityName];
    [super viewWillAppear:animated];
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

#pragma mark code capture delegate

- (void)didCaptureText:(NSString *)result welQRReaderViewController:(WelQRReaderViewController *)readerVc
{
    NSArray *firstSplit = [result componentsSeparatedByString:@"?"];
    if (firstSplit.count < 2) {
        [SVProgressHUD showErrorWithStatus:@"无法解析该二维码！"];
        return;
    }

    NSDictionary *paramList = [Util parametersDictionaryFromQueryString:firstSplit[1]];
    if ([[paramList objectForKey:@"goods_id"] intValue] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"无法解析该二维码！"];
    }

    Product *prod = [[Product alloc] init];
    prod.id = [[paramList objectForKey:@"goods_id"] intValue];

    if ([[paramList objectForKey:@"company_id"] intValue] > 0) {
        prod.group = [[Group alloc] init];
        prod.group.id = [[paramList objectForKey:@"company_id"] intValue];
    }

    ProductDetailViewController *vc = [ProductDetailViewController new];
    vc.product = prod;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didCancelWelQRReaderViewController:(WelQRReaderViewController *)readerVc
{
    [readerVc dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark UITableView delegate

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 210;
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
    static NSString * cellIdentifier = @"ProductCellIdentifier";
    ProductCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductCell alloc] initWithReuseIdentifier:cellIdentifier];
    }

    CardTapHandler tapHandler = ^(id model) {
        Product *product = (Product *)model;
        [self pushToDetial:product];
    };

    Product *prod = [self.datasource objectAtIndex:index];
    [cell setupWithData:prod tapHandler:tapHandler];

    return cell;
}

- (void)pushToDetial:(Product *)product
{
    ProductDetailViewController *productVc = [[ProductDetailViewController alloc] init];;
    productVc.product = product;
    productVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVc animated:YES];
}


#pragma mark Goods Search API

- (void)getGoods
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[CityManager SharedInstance] getSelectedCity].id] forKey:@"city"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.areaSelectedIndex] forKey:@"district"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.sortSelectedIndex] forKey:@"sort"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_GOODS_SEARCH] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetGoods:)];
    [request setDidFailSelector:@selector(failGetGoods:)];
    [request startAsynchronous];
}

- (void)finishGetGoods:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"goods"];

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
        [arr addObject:[[Product alloc] initWithDic:dicData]];
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

- (void)failGetGoods:(ASIHTTPRequest *)request
{
    [self.tableView stopRefreshAnimation];
}

- (void)checkEmpty
{
    
}

@end