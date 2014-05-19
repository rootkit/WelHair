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

#import "ApprovalViewController.h"
#import "GroupManageViewController.h"
#import "CouponManagerViewController.h"
#import "GroupRevenuViewController.h"
#import "WithdrawViewController.h"

@interface GroupManageViewController ()

@end

@implementation GroupManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙管理";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 416)];
    [self.view addSubview:contentView];
    
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(contentView),HEIGHT(contentView))];
    btnBg.image = [UIImage imageNamed:@"GroupManageViewController_Bg"];
    [contentView addSubview:btnBg];
    
    float buttonWidth = 240;
    float buttonHeight = 70;
    UIButton *revenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    revenuBtn.frame = CGRectMake(40,20 , buttonWidth, buttonHeight);
    [revenuBtn addTarget:self action:@selector(revenuClick) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:revenuBtn];
    
    
    UIButton *withDrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawalBtn.frame = CGRectMake(40, MaxY(revenuBtn) + 20, buttonWidth, buttonHeight);
    [withDrawalBtn addTarget:self action:@selector(withDrawalClick) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:withDrawalBtn];
    
    UIButton *approvalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    approvalBtn.frame = CGRectMake(40, MaxY(withDrawalBtn) + 20, buttonWidth, buttonHeight);
    [approvalBtn addTarget:self action:@selector(approvalClick) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:approvalBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.group.id <= 0) {
        [SVProgressHUD showErrorWithStatus:@"无法获取沙龙信息。"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)revenuClick
{
    [self.navigationController pushViewController:[GroupRevenuViewController new] animated:YES];
}

- (void)withDrawalClick
{
    WithdrawViewController *vc = [WithdrawViewController new];
    vc.groupId = self.group.id;
     [self.navigationController pushViewController:vc animated:YES];
}

- (void)approvalClick
{
    ApprovalViewController *approvalVC = [ApprovalViewController new];
    approvalVC.group = self.group;
    [self.navigationController pushViewController:approvalVC animated:YES];
}

@end
