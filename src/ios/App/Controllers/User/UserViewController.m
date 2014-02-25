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
@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"UserViewController.Title", nil);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    FAKIcon *searchIcon = [FAKIonIcons ios7CameraIconWithSize:40];
    [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    scanBtn.frame = CGRectMake(100, 100, 40, 40);
    [scanBtn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setImage:[searchIcon imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.view addSubview:scanBtn];
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

- (void)scanClick
{
    WelQRReaderViewController *scanner = [WelQRReaderViewController new];
    scanner.delegate = self;
    [self.tabBarController.navigationController pushViewController:scanner animated:YES];
}

#pragma mark code capture delegate
- (void)didCaptureText:(NSString *)result
           welQRReader:(WelQRReaderViewController *)readerVc
{
    [readerVc.navigationController popViewControllerAnimated:NO];
    [[[UIAlertView alloc] initWithTitle:@"qrcode content"
                               message:result
                              delegate:self
                     cancelButtonTitle:@"I see"
                     otherButtonTitles:nil] show];

}

- (void)didCancelWe:(WelQRReaderViewController *)readerVc
{
    [readerVc.navigationController popViewControllerAnimated:NO];
}

@end
