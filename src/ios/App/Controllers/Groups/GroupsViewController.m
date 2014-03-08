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

#import "GroupsViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "GroupDetailViewController.h"
#import "GroupCell.h"
#import "Group.h"

@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"GroupsViewController.Title", nil);
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
    [topTabView drawBottomShadowOffset:1 opacity:0.7];
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
//    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
//        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeGroupList]];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString * cellIdentifier = @"GroupCellIdentifier";
    GroupCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Group *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//- (void)pushToDetial:(Group *)work
//{
//    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
//    workVc.work = work;
//    [self.navigationController pushViewController:workVc animated:YES];
//}


@end
