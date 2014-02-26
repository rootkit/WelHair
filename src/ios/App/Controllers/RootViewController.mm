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
#import "WorksViewController.h"
#import "ChatSessionListViewController.h"
#import "ProductsViewController.h"
#import "GroupsViewController.h"
#import "UserViewController.h"
#import <FontAwesomeKit.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)loadView
{
    [super loadView];
    
    WorksViewController *worksVc = [WorksViewController new];
    GroupsViewController *groupsVc = [GroupsViewController new];
    ChatSessionListViewController *chatVc = [ChatSessionListViewController new];
    ProductsViewController *productVc = [ProductsViewController new];
    UserViewController *userVc = [UserViewController new];

    NSArray *tabVCs = @[worksVc,groupsVc,chatVc,productVc,userVc];
    NSArray *tabVCTitle = @[NSLocalizedString(@"WorksViewController.Title", nil),
                            NSLocalizedString(@"GroupsViewController.Title", nil),
                            NSLocalizedString(@"ChatSessionViewController.Title", nil),
                            NSLocalizedString(@"ProductsViewController.Title", nil),
                            NSLocalizedString(@"UserViewController.Title", nil)];
    
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
    [self setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:worksVc],
                               [[UINavigationController alloc] initWithRootViewController:groupsVc],
                               [[UINavigationController alloc] initWithRootViewController:chatVc],
                               [[UINavigationController alloc] initWithRootViewController:productVc],
                               [[UINavigationController alloc] initWithRootViewController:userVc]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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