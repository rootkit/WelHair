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

#import "RootViewController.h"
#import "HairStylesViewController.h"
#import "HairStylistsViewController.h"
#import "ProductsViewController.h"
#import "SalonViewController.h"
#import "UserViewController.h"
#import <FontAwesomeKit.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)loadView
{
    [super loadView];
    
    HairStylesViewController *stylesVc = [HairStylesViewController new];
    HairStylistsViewController *stylistsVc = [HairStylistsViewController new];
    SalonViewController *salonVc = [SalonViewController new];
    ProductsViewController *productVc = [ProductsViewController new];
    UserViewController *userVc = [UserViewController new];

    NSArray *tabVCs = @[stylesVc,stylistsVc,salonVc,productVc,userVc];
    NSArray *tabVCTitle = @[@"发型",@"发型师",@"沙龙",@"产品",@"我的"];
    NSArray *tabImages = @[[FAKIonIcons homeIconWithSize:30],
                           [FAKIonIcons ios7CogOutlineIconWithSize:30],
                           [FAKIonIcons ios7PlusEmptyIconWithSize:40],
                           [FAKIonIcons ios7LightbulbOutlineIconWithSize:30],
                           [FAKIonIcons ios7PersonOutlineIconWithSize:30]];
    for (NSUInteger i =0; i< 5; i++) {
        UIViewController *vc = [tabVCs objectAtIndex:i];
        NSString *tabTitle = [tabVCTitle objectAtIndex:i];
        FAKIcon *tabIcon = [tabImages objectAtIndex:i];
        [tabIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"CCC"]];
        UIImage *tabImg = [tabIcon imageWithSize:CGSizeMake(30,30)];
        UITabBarItem *tabBar = [[UITabBarItem alloc] initWithTitle:tabTitle image:tabImg tag:(NSInteger)i];
        vc.tabBarItem = tabBar;
    }
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:TAB_BAR_COLOR] cornerRadius:0]];
//    [[UITabBar appearance] setTintColor:[UIColor colorFromHexCode:NAV_BAR_COLOR]];
//    [[UITabBar appearance] setBackgroundColor:[UIColor colorFromHexCode:TAB_BAR_COLOR]];
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:stylesVc],
                               [[UINavigationController alloc] initWithRootViewController:stylistsVc],
                              [[UINavigationController alloc] initWithRootViewController:salonVc],
                               [[UINavigationController alloc] initWithRootViewController:productVc],
                               [[UINavigationController alloc] initWithRootViewController:userVc]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
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


@end