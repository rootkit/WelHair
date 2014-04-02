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

#import "GroupProductListViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "Product.h"
#import <FontAwesomeKit.h>
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"

@interface GroupProductListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GroupProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProductsViewController.Title", nil);
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
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
    [self.navigationController pushViewController:productVc animated:YES];
}
@end