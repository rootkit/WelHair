//
//  StaffManageViewController.m
//  WelHair
//
//  Created by lu larry on 3/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "StaffManageViewController.h"

#import "UploadWorkFormViewController.h"
#import "CreateGroupViewController.h"
#import "GroupManageViewController.h"
#import "MyGroupStaffListViewController.h"
#import "StaffWorksViewController.h"
#import "StaffServicesViewController.h"
#import "AppointmentsViewController.h"

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
    [myWorkBtn addTarget:self action:@selector(myWorkClick) forControlEvents:UIControlEventTouchDown];
    myWorkBtn.frame = CGRectMake(0, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:myWorkBtn];
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceBtn addTarget:self action:@selector(serviceClick) forControlEvents:UIControlEventTouchDown];
    serviceBtn.frame = CGRectMake(WIDTH(contentView)/2, 0, WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:serviceBtn];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(infoClick) forControlEvents:UIControlEventTouchDown];
    infoBtn.frame = CGRectMake(0, MaxY(serviceBtn), WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:infoBtn];
    
    UIButton *appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appointmentBtn addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchDown];
    appointmentBtn.frame = CGRectMake(WIDTH(contentView)/2, MaxY(serviceBtn), WIDTH(contentView)/2, WIDTH(contentView)/2);
    [contentView addSubview:appointmentBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myWorkClick
{
    StaffWorksViewController *vc =  [StaffWorksViewController new];
    vc.editable = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)serviceClick
{
    [self.navigationController pushViewController:[StaffServicesViewController new] animated:YES];
}

- (void)infoClick
{

}

- (void)appointmentClick
{
    [self.navigationController pushViewController:[AppointmentsViewController new] animated:YES];
}


@end