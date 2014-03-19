//
//  GroupManageViewController.m
//  WelHair
//
//  Created by lu larry on 3/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "GroupManageViewController.h"
#import "CouponManagerViewController.h"
#import "GroupRevenuViewController.h"
#import "WithDrawalViewController.h"
#import "ApprovalViewController.h"
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
    float buttonHeight = 67;
    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBtn.frame = CGRectMake(40,25 , buttonWidth, buttonHeight);
    [couponBtn addTarget:self action:@selector(couponClick) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:couponBtn];
    
    
    UIButton *revenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    revenuBtn.frame = CGRectMake(40, MaxY(couponBtn) + 20, buttonWidth, buttonHeight);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (void)couponClick
{
    [self.navigationController pushViewController:[CouponManagerViewController new] animated:YES];
}

- (void)revenuClick
{
    [self.navigationController pushViewController:[GroupRevenuViewController new] animated:YES];
}

- (void)withDrawalClick
{
     [self.navigationController pushViewController:[WithDrawalViewController new] animated:YES];
}

- (void)approvalClick
{
     [self.navigationController pushViewController:[ApprovalViewController new] animated:YES];
}

@end
