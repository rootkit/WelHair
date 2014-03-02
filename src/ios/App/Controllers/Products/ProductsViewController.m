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
#import "WorkCell.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
@interface ProductsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProductsViewController.Title", nil);
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset - kBottomBarHeight);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeHairWorkImgs]];
    
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
    return (WIDTH(self.view) - 20)/2;
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
    }
    imgTapHandler tapHandler = ^(int workId){
        [self pushToDetial];
    };
    
    NSString *left = [self.datasource objectAtIndex: (2 * indexPath.row)];
    NSString *right = nil;
    if(2 * (indexPath.row + 1) <= self.datasource.count){
        right = [self.datasource objectAtIndex: (2 * indexPath.row)];
    }
    [cell setupWithLeftData:left rightData:right tapHandler:tapHandler];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)pushToDetial
{
    ProductDetailViewController *workVc = [[ProductDetailViewController alloc] init];;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}
@end