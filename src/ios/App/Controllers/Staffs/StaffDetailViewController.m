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

#import "StaffDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "GroupDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+KNSemiModal.h"
#import "CalendarViewController.h"

@interface StaffDetailViewController ()

@end

@implementation StaffDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设计师Danny";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    float margin = 10;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin,
                                                                         margin + self.topBarOffset,
                                                                         WIDTH(self.view) - 2 *margin,
                                                                         WIDTH(self.view) - 2 *margin)];
    [imgView setImageWithURL:[NSURL URLWithString:[[FakeDataHelper getFakeHairWorkImgs] objectAtIndex:0]]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(imgView) + margin, 100, 30)];
    lbl.text = @"设计师Danny";
    lbl.textColor = [UIColor blackColor];
    [self.view addSubview:lbl];
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    staffBtn.frame = CGRectMake(MaxX(lbl) + margin,MaxY(imgView) + margin, 100, 50);
    [staffBtn setTitle:@"所属沙龙" forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(groupClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:staffBtn];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderBtn.frame = CGRectMake(MaxX(staffBtn) + margin,MaxY(imgView) + margin, 100, 50);
    [orderBtn setTitle:@"预约" forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:orderBtn];
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

- (void)orderClick
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[CalendarViewController new]] animated:YES completion:nil];
}

- (void)groupClick
{
    [self.navigationController pushViewController:[GroupDetailViewController new] animated:YES];
}


@end
