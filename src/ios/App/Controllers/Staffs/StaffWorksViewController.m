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

#import "BrickView.h"
#import "DoubleCoverCell.h"
#import "StaffWorkCell.h"
#import "StaffWorksViewController.h"
#import "UploadWorkFormViewController.h"
#import "UserManager.h"
#import "Work.h"
#import "WorkDetailViewController.h"

@interface StaffWorksViewController ()<BrickViewDelegate, BrickViewDataSource, UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) int currentRemovedWorkId;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) BrickView *tableView;

@end

@implementation StaffWorksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"作品集";
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

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[UploadWorkFormViewController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.staffId <= 0 || self.staffId != [[UserManager SharedInstance] userLogined].id) {
        self.rightNavItemImg = nil;
    }
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[BrickView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.padding = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getWorks];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getWorks];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 145 + 28;
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
    static NSString * cellIdentifier = @"StaffWorkCellIdentifier";
    StaffWorkCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StaffWorkCell alloc] initWithReuseIdentifier:cellIdentifier];
    }

    [cell setupWithData:[self.datasource objectAtIndex:index] tapHandler:^(id model){
        Work *work = (Work *)model;
        self.currentRemovedWorkId = work.id;

        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"确认要删除该作品么？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
        [alert show];
    }];

    return cell;
}

- (void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    Work *work = [self.datasource objectAtIndex:index];

    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}

- (void)getWorks
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_WORKS, self.staffId]] andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetWorks:)];
    [request setDidFailSelector:@selector(failGetWorks:)];
    [request startAsynchronous];
}

- (void)finishGetWorks:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"works"];

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
        [arr addObject:[[Work alloc] initWithDic:dicData]];
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

- (void)failGetWorks:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];


        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WORKS_REMOVE, self.currentRemovedWorkId]]
                                                                    andData:nil];
        [self.requests addObject:request];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(removeWorkFinish:)];
        [request setDidFailSelector:@selector(removeWorkFail:)];
        [request startAsynchronous];
    }
}

- (void)removeWorkFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if (![responseMessage objectForKey:@"success"]) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [self.tableView triggerPullToRefresh];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"删除作品失败，请重试！"];
}

- (void)removeWorkFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"删除作品失败，请重试！"];
}

@end
