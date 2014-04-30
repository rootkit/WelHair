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

#import "StaffManageViewController.h"

#import "AppointmentsViewController.h"
#import "CreateGroupViewController.h"
#import "GroupManageViewController.h"
#import "MyClientViewController.h"
#import "MyGroupStaffListViewController.h"
#import "StaffWorksViewController.h"
#import "StaffServicesViewController.h"
#import "UploadWorkFormViewController.h"
#import "UserManager.h"
#import "UserProfileViewController.h"

@interface StaffManageViewController ()

@end

@implementation StaffManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设计师";

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
    btnBg.image = [UIImage imageNamed:@"StaffManageViewControl_Bg"];
    [contentView addSubview:btnBg];
    
    UIButton *myWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myWorkBtn addTarget:self action:@selector(myWorkClick) forControlEvents:UIControlEventTouchUpInside];
    myWorkBtn.frame = CGRectMake(0, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:myWorkBtn];
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceBtn addTarget:self action:@selector(serviceClick) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.frame = CGRectMake(WIDTH(contentView)/2, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:serviceBtn];
    
    UIButton *myClientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myClientBtn addTarget:self action:@selector(clientClick) forControlEvents:UIControlEventTouchUpInside];
    myClientBtn.frame = CGRectMake(0, MaxY(serviceBtn), WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:myClientBtn];
    
    UIButton *appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appointmentBtn addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchUpInside];
    appointmentBtn.frame = CGRectMake(WIDTH(contentView)/2, MaxY(serviceBtn), WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:appointmentBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)myWorkClick
{
    StaffWorksViewController *vc =  [StaffWorksViewController new];
    vc.staffId = [[UserManager SharedInstance] userLogined].id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)serviceClick
{
    [self.navigationController pushViewController:[StaffServicesViewController new] animated:YES];
}

- (void)clientClick
{
    MyClientViewController *vc = [MyClientViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)appointmentClick
{
    AppointmentsViewController *aptVC = [AppointmentsViewController new];
    aptVC.staffId = [[UserManager SharedInstance] userLogined].id;
    [self.navigationController pushViewController:aptVC animated:YES];
}


@end