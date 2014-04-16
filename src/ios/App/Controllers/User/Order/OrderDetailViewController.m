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

#import "OrderDetailViewController.h"
#import "PayViewController.h"
@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    payBtn.frame = CGRectMake(50,200, 100, 50);
    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:payBtn];
}

- (void) payClick
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[PayViewController new] ] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
