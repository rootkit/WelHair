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

#import "GroupDetailViewController.h"
#import "StaffsViewController.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
    lbl.text = @"沙龙详情";
    lbl.textColor = [UIColor blackColor];
    [self.view addSubview:lbl];
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    staffBtn.frame = CGRectMake(60,200, 80, 50);
    [staffBtn setTitle:@"发型师" forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:staffBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)staffClick
{
    [self.navigationController pushViewController:[StaffsViewController new] animated:YES];
}

@end
