// ==========================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==========================================================================

#import "RootViewController.h"
#import "WorksViewController.h"
#import "StaffsViewController.h"
#import "ProductsViewController.h"
#import "GroupsViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import <FontAwesomeKit.h>
#import "JSBadgeView.h"
@interface RootViewController ()<UINavigationControllerDelegate>

@end

@implementation RootViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBadge) name:NOTIFICATION_STAFF_GET_APPOINMENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView) name:NOTIFICATION_SHOW_LOGIN_VIEW object:nil];
    WorksViewController *worksVc = [WorksViewController new];
    UINavigationController *workNav = [[UINavigationController alloc] initWithRootViewController:worksVc];
    workNav.delegate = self;
    GroupsViewController *groupsVc = [GroupsViewController new];
    UINavigationController *groupsNav = [[UINavigationController alloc] initWithRootViewController:groupsVc];
    groupsNav.delegate = self;
    ProductsViewController *productsVc = [ProductsViewController new];
    UINavigationController *productsNav = [[UINavigationController alloc] initWithRootViewController:productsVc];
    productsNav.delegate  = self;
    StaffsViewController *staffsVc = [StaffsViewController new];
    UINavigationController *staffsNav = [[UINavigationController alloc] initWithRootViewController:staffsVc];
    staffsNav.delegate = self;
    UserViewController *userVc = [UserViewController new];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController:userVc];
    userNav.delegate = self;

    NSArray *viewControls = @[workNav,groupsNav,productsNav,staffsNav,userNav];
    NSArray *tabNormalImages = @[[UIImage imageNamed:@"RootBottomTab1"],
                                 [UIImage imageNamed:@"RootBottomTab2"],
                                 [UIImage imageNamed:@"RootBottomTab3"],
                                 [UIImage imageNamed:@"RootBottomTab4"],
                                 [UIImage imageNamed:@"RootBottomTab5"]];
    NSArray *tabSelectedImages = @[[UIImage imageNamed:@"RootBottomTab1Selected"],
                                   [UIImage imageNamed:@"RootBottomTab2Selected"],
                                   [UIImage imageNamed:@"RootBottomTab3Selected"],
                                   [UIImage imageNamed:@"RootBottomTab4Selected"],
                                   [UIImage imageNamed:@"RootBottomTab5Selected"]];
    [self setupViewControls:viewControls
                           tabHeight:CUSTOME_BOTTOMBAR_HEIGHT
                     tabNormalImages:tabNormalImages
                   tabSelectedImages:tabSelectedImages];
    [self showBadge];
}

- (void)showLoginView
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]]
                                            animated:YES
                                          completion:nil];
}
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{   
    if([viewController isKindOfClass:[WorksViewController class]] ||
       [viewController isKindOfClass:[GroupsViewController class]] ||
       [viewController isKindOfClass:[StaffsViewController class]] ||
       [viewController isKindOfClass:[ProductsViewController class]] ||
       [viewController isKindOfClass:[UserViewController class]] ){
        [self.tabBar setHidden:YES];
        [self showTabBarAnimation:YES];
    }else{
        [self hideTabBarAnimation:YES];
    }
}

- (void)showBadge
{
    int count = [[SettingManager SharedInstance] notificationCount];
    [self setBadge:count atIndex:4];

}

@end