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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WorksViewController *worksVc = [WorksViewController new];
    GroupsViewController *groupsVc = [GroupsViewController new];
    ChatSessionListViewController *chatVc = [ChatSessionListViewController new];
    ProductsViewController *productVc = [ProductsViewController new];
    UserViewController *userVc = [UserViewController new];
    NSArray *viewControls = @[[[UINavigationController alloc] initWithRootViewController:worksVc],
                              [[UINavigationController alloc] initWithRootViewController:groupsVc],
                              [[UINavigationController alloc] initWithRootViewController:chatVc],
                              [[UINavigationController alloc] initWithRootViewController:productVc],
                              [[UINavigationController alloc] initWithRootViewController:userVc]];
    NSArray *tabNormalImages = @[[UIImage imageNamed:@"RootBottomTab1"],
                                 [UIImage imageNamed:@"RootBottomTab2"],
                                 [UIImage imageNamed:@"RootBottomTab3"],
                                 [UIImage imageNamed:@"RootBottomTab4"],
                                 [UIImage imageNamed:@"RootBottomTab5"]];
    NSArray *tabSelectedImages = @[[UIImage imageNamed:@"RootBottomTab1"],
                                   [UIImage imageNamed:@"RootBottomTab2"],
                                   [UIImage imageNamed:@"RootBottomTab3"],
                                   [UIImage imageNamed:@"RootBottomTab4"],
                                   [UIImage imageNamed:@"RootBottomTab5"]];
    [self setupViewControls:viewControls
                           tabHeight:49
                     tabNormalImages:tabNormalImages
                   tabSelectedImages:tabSelectedImages];
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