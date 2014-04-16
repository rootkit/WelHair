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
#import "GroupManageViewController.h"
#import "MyGroupStaffListViewController.h"
#import "MyGroupViewController.h"
#import "UploadWorkFormViewController.h"
#import "MyGroupDetailViewController.h"

@interface MyGroupViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)staffClick
{
    [self.navigationController pushViewController:[MyGroupStaffListViewController new] animated:YES];
}

- (void)manageClick
{
    [self.navigationController pushViewController:[GroupManageViewController new] animated:YES];
}

- (void)infoClick
{
    [self.navigationController pushViewController:[MyGroupDetailViewController new] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
