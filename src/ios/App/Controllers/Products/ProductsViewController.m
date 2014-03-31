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
#import "DropDownView.h"

@interface ProductsViewController ()<UITableViewDataSource, UITableViewDelegate,DropDownDelegate, WelQRReaderDelegate>
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *hotBtn;

@property (nonatomic, strong) DropDownView *dropDownPicker;
@property (nonatomic, strong) NSArray *areaDatasource;
@property (nonatomic, strong) NSArray *hotDatasource;

@property (nonatomic) int areaSelectedIndex;
@property (nonatomic) int hotSelectedIndex;

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
    [self setTopLeftCityName];
    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),TOP_TAB_BAR_HEIGHT)];
    topTabView.backgroundColor = [UIColor whiteColor];
    UIView *topTabBottomShadowView = [[UIView alloc] initWithFrame:topTabView.frame];
    topTabBottomShadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabBottomShadowView drawBottomShadowOffset:1 opacity:1];
    [self.view addSubview:topTabBottomShadowView];
    [self.view addSubview:topTabView];
    
    self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.areaBtn.frame = CGRectMake(0, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.areaBtn setTitle:@"地区" forState:UIControlStateNormal];
    self.areaBtn.tag = 0;
    [self.areaBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.areaBtn];
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.areaBtn), 10, 1, 20)];
    separatorView1.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:separatorView1];
    
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.hotBtn.frame = CGRectMake(MaxX(self.areaBtn)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.hotBtn setTitle:@"热度" forState:UIControlStateNormal];
    self.hotBtn.tag = 1;
    [self.hotBtn addTarget:self action:@selector(dropDownBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.hotBtn];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset + topTabView.height,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:YES] - topTabView.height );
    debugLog(@"%f",MaxY(topTabView));
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
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    [self.view addSubview:self.tableView];

    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeProductList]];
    
    self.areaDatasource = @[@"高新区",@"历下区",@"历城区",@"市中区"];
    self.hotDatasource = @[@"销量",@"好评",@"价格"];
    
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
        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
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
    productVc.product = [self.datasource objectAtIndex:0];
    productVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVc animated:YES];
}
@end