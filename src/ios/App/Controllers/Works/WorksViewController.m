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
#import "WelTabBarController.h"

@interface WorksViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftNavItemTitle = @"济南";
    float topTabButtonWidth = WIDTH(self.view)/3;
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
    [colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
    [topTabView addSubview:colorBtn];
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_TAB_BAR_HEIGHT -1, WIDTH(topTabView), 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:shadowView];
    topTabView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.7];
    
    UIButton *lengthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lengthBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    lengthBtn.frame = CGRectMake(MaxX(colorBtn), 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [lengthBtn setTitle:@"长度" forState:UIControlStateNormal];
    [topTabView addSubview:lengthBtn];
    [topTabView drawBottomShadowOffset:1 opacity:0.7];;
    self.tableView = [[UITableView alloc] init];
    float tableHeight = isIOS7 ?
    HEIGHT(self.view) - MaxY(topTabView) - kBottomBarHeight :
    HEIGHT(self.view) - kTopBarHeight - MaxY(topTabView)  - kBottomBarHeight ;
    self.tableView.frame = CGRectMake(0,
                                      MaxY(topTabView),
                                      WIDTH(self.view) ,
                                      tableHeight);
    NSLog(@"%f",MaxY(topTabView));
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
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeWorkList]];

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
    [cell setupWithLeftData:leftdata rightData:rightdata tapHandler:^(Work *work){[selfDelegate pushToDetial:work];}];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    [self.navigationController pushViewController:workVc animated:YES];
}



@end
