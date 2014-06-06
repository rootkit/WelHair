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

#import "WithdrawViewController.h"
#import "AddWithdrawViewController.h"
#import "WithdrawCell.h"
#import "UserManager.h"
#import "User.h"

@interface WithdrawViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *balanceLbl;
@property (nonatomic) float currentBalance;
@end

@implementation WithdrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"提现记录";
        self.currentPage = 1;
        
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        FAKIcon *rightIcon = [FAKIonIcons ios7PlusOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
    }
    
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    AddWithdrawViewController *vc = [AddWithdrawViewController new];
    vc.balance = self.currentBalance;
    vc.groupId = self.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequestWithdraw:) name:NOTIFICATION_CANCEL_REQUEST_WITHDRAW object:nil];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 160, 30)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.text = @"当前余额:";
    titleLbl.textAlignment = TextAlignmentRight;
    [headerView addSubview:titleLbl];
    
    self.balanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(180,10, 150, 30)];
    self.balanceLbl.backgroundColor = [UIColor clearColor];
    self.balanceLbl.textColor = [UIColor redColor];
    self.balanceLbl.font = [UIFont systemFontOfSize:16];
    self.balanceLbl.textAlignment = TextAlignmentLeft;
    [headerView addSubview:self.balanceLbl];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    self.tableView.tableHeaderView = headerView;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getWithdraws];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getWithdraws];
    }];
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"WithDrawalCellIdentifier";
    WithdrawCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WithdrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *withdraw = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:withdraw];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark Group Search API

- (void)loadData
{
    [self getWithdraws];
}

- (void)getWithdraws
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.groupId] forKey:@"companyId"];
    
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WITHDRAW_LIST, [[UserManager SharedInstance] userLogined].groupId]]
                                                          andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetWithdraws:)];
    [request setDidFailSelector:@selector(failGetWithdraws:)];
    [request startAsynchronous];
}

- (void)finishGetWithdraws:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];

    self.currentBalance  = [[rst objectForKey:@"balance"] floatValue];
    self.balanceLbl.text = [NSString stringWithFormat:@"%.2f", self.currentBalance];

    NSArray *dataList = [rst objectForKey:@"companybalancelogs"];
    
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
    
    
    self.datasource = [NSMutableArray arrayWithArray:dataList];
    
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

- (void)failGetWithdraws:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

- (void)cancelRequestWithdraw:(NSNotification *)noti
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:noti.object forKey:@"id"];
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_WITHDRAW_CANCEL]
                                                                andData:reqData];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishCancelWithdraw:)];
    [request setDidFailSelector:@selector(failCancelWithdraw:)];
    [request startAsynchronous];
}

- (void)finishCancelWithdraw:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 0) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }
            
            [SVProgressHUD dismiss];
            [self loadData];
            [SVProgressHUD showSuccessWithStatus:@"操作成功！"];
            
            return;
        }
    }
    
    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

- (void)failCancelWithdraw:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

@end
