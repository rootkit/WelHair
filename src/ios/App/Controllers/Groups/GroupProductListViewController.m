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

#import <FontAwesomeKit.h>

#import "BrickView.h"
#import "Product.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "GroupProductListViewController.h"

@interface GroupProductListViewController ()<BrickViewDelegate, BrickViewDataSource>


@property (nonatomic, strong) BrickView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation GroupProductListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProductsViewController.Title", nil);
        self.currentPage = 1;

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
    
    self.title = [NSString stringWithFormat:@"%@的商品", self.group.name];

    self.tableView = [[BrickView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
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

    [self.tableView triggerPullToRefresh];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_GOODS, self.group.id]] andParam:reqData];
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
        Product *product = [[Product alloc] initWithDic:dicData];
        product.distance = -1;
        [arr addObject:product];
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
}

- (void)checkEmpty
{
    
}

@end