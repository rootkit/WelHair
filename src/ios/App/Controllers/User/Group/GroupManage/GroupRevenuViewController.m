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

#import "GroupRevenuViewController.h"
#import "GroupRevenuCell.h"
#import "StaffRevenuViewController.h"

@interface GroupRevenuViewController ()<UITableViewDataSource, UITableViewDelegate, GroupRevenuCellDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableDictionary *secDatasource;

@end

@implementation GroupRevenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙收益";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.secDatasource = [NSMutableDictionary dictionary];
    }

    return self;
}

-(void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getRevenues];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getRevenues];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    
    
    UILabel *monthLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0,100,50)];
    monthLbl.text = [self.secDatasource.allKeys objectAtIndex:section];
    monthLbl.font = [UIFont systemFontOfSize:16];
    monthLbl.numberOfLines = 1;
    monthLbl.backgroundColor = [UIColor clearColor];
    monthLbl.textColor = [UIColor blackColor];
    [headerView addSubview:monthLbl];
    
    UIView *verticalLiner = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 30)];
    verticalLiner.backgroundColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    [headerView addSubview:verticalLiner];

    NSArray *revenueList = [self.secDatasource objectForKey:[self.secDatasource.allKeys objectAtIndex:section]];
    float monthTotal = 0.0;
    for (NSDictionary *dicRevenue in revenueList) {
        monthTotal += [[dicRevenue objectForKey:@"Amount"] floatValue];
    }

    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 200, 50)];
    priceLbl.text = [NSString stringWithFormat:@"+￥%.2f", monthTotal];
    priceLbl.font = [UIFont systemFontOfSize:16];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.numberOfLines = 1;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textColor = [UIColor lightGrayColor];
    [headerView addSubview:priceLbl];

    return headerView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.secDatasource.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *revenueList = [self.secDatasource objectForKey:[self.secDatasource.allKeys objectAtIndex:section]];
    return revenueList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GroupRevenuCellIdentifier";

    GroupRevenuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupRevenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }

    NSArray *revenueList = [self.secDatasource objectForKey:[self.secDatasource.allKeys objectAtIndex:indexPath.section]];
    [cell setup:[revenueList objectAtIndex:indexPath.row]];

    return cell;
}

- (void)didTapStaff:(int)staffId
{
//    StaffRevenuViewController *vc= [StaffRevenuViewController new];
//    vc.staffId = staffId;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark Revenue List API

- (void)getRevenues
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_REVENUES, self.group.id]]
                                                          andParam:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetRevenues:)];
    [request setDidFailSelector:@selector(failGetRevenues:)];
    [request startAsynchronous];
}

- (void)finishGetRevenues:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"revenues"];

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

    [arr addObjectsFromArray:dataList];
    self.datasource = arr;

    self.secDatasource = [NSMutableDictionary dictionary];

    for (NSDictionary *dicRevenue in self.datasource) {
        NSDate *dateRevenue = [[NSDate dateFormatter] dateFromString:[dicRevenue objectForKey:@"CreateTime"]];
        NSString *groupMonthKey = [[NSDate dateWithYMFormatter] stringFromDate:dateRevenue];

        NSMutableArray *groupMonthArr = [NSMutableArray array];
        if ([self.secDatasource objectForKey:groupMonthKey]) {
            groupMonthArr = [[NSMutableArray alloc] initWithArray:[self.secDatasource objectForKey:groupMonthKey]];
        }
        [groupMonthArr addObject:dicRevenue];

        [self.secDatasource setObject:groupMonthArr forKey:groupMonthKey];
    }

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

- (void)failGetRevenues:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}


@end
