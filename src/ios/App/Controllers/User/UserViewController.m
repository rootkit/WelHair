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

#import "UserViewController.h"
#import <FontAwesomeKit.h>
#import "WelQRReaderViewController.h"
#import "LoginViewController.h"
@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"UserViewController.Title", nil);
        self.rightNavItemTitle = NSLocalizedString(@"Login", nil);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightNavItemClick
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
}




@end
