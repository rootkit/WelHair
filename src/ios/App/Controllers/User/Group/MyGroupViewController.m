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

#import "CreateGroupViewController.h"
#import "Group.h"
#import "GroupManageViewController.h"
#import "MyGroupDetailViewController.h"
#import "MyGroupStaffListViewController.h"
#import "MyGroupViewController.h"
#import "Staff.h"
#import "UploadWorkFormViewController.h"
#import "UserManager.h"

@interface MyGroupViewController ()

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) GroupInfoFinishedHandler finishHandler;

@end

@implementation MyGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的沙龙";

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

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 416)];
    [self.view addSubview:contentView];
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(contentView),HEIGHT(contentView))];
    btnBg.image = [UIImage imageNamed:@"MyGroupViewControl_ButtonBg@2x"];
    [contentView addSubview:btnBg];
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
    staffBtn.frame = CGRectMake(0, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:staffBtn];
    
    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageBtn addTarget:self action:@selector(manageClick) forControlEvents:UIControlEventTouchDown];
    manageBtn.frame = CGRectMake(WIDTH(contentView)/2, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:manageBtn];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(infoClick) forControlEvents:UIControlEventTouchDown];
    infoBtn.frame = CGRectMake(0, MaxY(manageBtn), WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:infoBtn];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshGroupInfo:)
                                                 name:NOTIFICATION_USER_REFRESH_GROUP_INFO
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)staffClick
{
    MyGroupStaffListViewController *myGroupStaffListVC = [MyGroupStaffListViewController new];
    if (self.group) {
        myGroupStaffListVC.group = self.group;
        [self.navigationController pushViewController:myGroupStaffListVC animated:YES];
    } else {
        __weak typeof(self) weakSelf = self;
        self.finishHandler = ^() {
            myGroupStaffListVC.group = weakSelf.group;
            [weakSelf.navigationController pushViewController:myGroupStaffListVC animated:YES];
        };

        [self getStaffDetail];
    }
}

- (void)manageClick
{
    GroupManageViewController *groupManageVC = [GroupManageViewController new];
    if (self.group) {
        groupManageVC.group = self.group;
        [self.navigationController pushViewController:groupManageVC animated:YES];
    } else {
        __weak typeof(self) weakSelf = self;
        self.finishHandler = ^() {
            groupManageVC.group = weakSelf.group;
            [weakSelf.navigationController pushViewController:groupManageVC animated:YES];
        };

        [self getStaffDetail];
    }
}

- (void)infoClick
{
    MyGroupDetailViewController *myGroupDetailVC = [MyGroupDetailViewController new];
    if (self.group) {
        myGroupDetailVC.group = self.group;
        [self.navigationController pushViewController:myGroupDetailVC animated:YES];
    } else {
        __weak typeof(self) weakSelf = self;
        self.finishHandler = ^() {
            myGroupDetailVC.group = weakSelf.group;
            [weakSelf.navigationController pushViewController:myGroupDetailVC animated:YES];
        };

        [self getStaffDetail];
    }
}

- (void)getStaffDetail
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_DETAIL, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:nil];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetStaffDetail:)];
    [request setDidFailSelector:@selector(failGetStaffDetail:)];
    [request startAsynchronous];
}

- (void)finishGetStaffDetail:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    id companyDic = [rst objectForKey:@"Company"];
    if (companyDic == [NSNull null]) {
        return;
    }

    self.group = [[Group alloc] initWithDic:companyDic];

    if (self.finishHandler) {
        self.finishHandler();
    }
}

- (void)failGetStaffDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"无法获取沙龙信息。"];
}

- (void)refreshGroupInfo:(NSNotification *)notification
{
    self.group = notification.object;
}

@end
