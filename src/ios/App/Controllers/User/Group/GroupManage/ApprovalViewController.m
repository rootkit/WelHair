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

#import "ApprovalCell.h"
#import "ApprovalViewController.h"
#import "Staff.h"
#import "StaffDetailViewController.h"

@interface ApprovalViewController ()<ApprovalCellDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ApprovalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"审批";
        self.currentPage = 1;

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
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
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset ,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
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

    if (self.group.id > 0) {
        [self.tableView triggerPullToRefresh];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"ApprovalCellIdentifier";
    ApprovalCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ApprovalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor =  cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    cell.delegate = self;

    Staff *staff = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:staff];

    return cell;
}

- (void)didTapStaff:(Staff *)staff
{
    StaffDetailViewController *vc = [StaffDetailViewController new];
    vc.staff = staff;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didApproveStaff:(Staff *)staff
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"IsApproved"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_STAFFS_STATUS, self.group.id, staff.id]]
                                                                andData:reqData];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(approveStaffFinish:)];
    [request setDidFailSelector:@selector(approveStaffFail:)];
    [request startAsynchronous];
}

- (void)approveStaffFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"操作失败。"];
                return;
            }

            [self.tableView triggerPullToRefresh];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"操作失败。"];
    }
}

- (void)approveStaffFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败。"];
}

- (void)didRemoveStaff:(Staff *)staff
{
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_STAFFS_REMOVE, self.group.id, staff.id]]
                                                                andData:nil];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(removeStaffFinish:)];
    [request setDidFailSelector:@selector(removeStaffFail:)];
    [request startAsynchronous];
}

- (void)removeStaffFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"操作失败。"];
                return;
            }

            [self.tableView triggerPullToRefresh];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"操作失败。"];
    }
}

- (void)removeStaffFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败。"];
}

#pragma mark Group Search API

- (void)getStaffs
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.group.id] forKey:@"companyId"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_STAFFS, self.group.id]] andParam:reqData];
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
    NSArray *dataList = [rst objectForKey:@"staffes"];

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
    [self.tableView stopRefreshAnimation];
}


- (void)checkEmpty
{
    
}

@end
