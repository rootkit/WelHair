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

#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "Product.h"
#import <FontAwesomeKit.h>
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "WelQRReaderViewController.h"

@interface ProductsViewController ()<UITableViewDataSource, UITableViewDelegate,WelQRReaderDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProductsViewController.Title", nil);
        FAKIcon *searchIcon = [FAKFontAwesome qrcodeIconWithSize:NAV_BAR_ICON_SIZE];
        [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg = [searchIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
    }
    return self;
}

- (void)rightNavItemClick
{
    WelQRReaderViewController *scanner = [WelQRReaderViewController new];
    scanner.delegate = self;
    [self.navigationController presentViewController:scanner animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftNavItemTitle = @"济南";
    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    [self.view addSubview:topTabView];
    topTabView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    areaBtn.frame = CGRectMake(0, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [areaBtn setTitle:@"地区" forState:UIControlStateNormal];
    [topTabView addSubview:areaBtn];
    
    UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [colorBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    colorBtn.frame = CGRectMake(MaxX(areaBtn), 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [colorBtn setTitle:@"热度" forState:UIControlStateNormal];
    [topTabView addSubview:colorBtn];

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
    debugLog(@"%f",MaxY(topTabView));
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:topTabView.bounds];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:topTabView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeProductList]];
    
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

#pragma mark code capture delegate
- (void)didCaptureText:(NSString *)result
           welQRReaderViewController:(WelQRReaderViewController *)readerVc
{
    [readerVc dismissViewControllerAnimated:YES completion:nil];
    [[[UIAlertView alloc] initWithTitle:@"qrcode content"
                                message:result
                               delegate:self
                      cancelButtonTitle:@"I see"
                      otherButtonTitles:nil] show];
    
}

- (void)didCancelWelQRReaderViewController:(WelQRReaderViewController *)readerVc
{
    [readerVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ceil(self.datasource.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"ProductCellIdentifier";
    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    CardTapHandler tapHandler = ^(id model){
        Product *product = (Product *)model;
        [self pushToDetial:product];
    };
    
    Product *left = [self.datasource objectAtIndex: (2 * indexPath.row)];
    Product *right = nil;
    if(2 * (indexPath.row + 1) <= self.datasource.count){
        right = [self.datasource objectAtIndex: (2 * indexPath.row)];
    }
    [cell setupWithLeftData:left rightData:right tapHandler:tapHandler];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)pushToDetial:(Product *)product
{
    ProductDetailViewController *productVc = [[ProductDetailViewController alloc] init];;
    productVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVc animated:YES];
}
@end