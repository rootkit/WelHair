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
#import "StaffDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙详情";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    int margin = 10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin,
                                                                         margin + self.topBarOffset,
                                                                         WIDTH(self.view) - 2 *margin,
                                                                         WIDTH(self.view) - 2 *margin)];
    [imgView setImageWithURL:[NSURL URLWithString:[[FakeDataHelper getFakeHairWorkImgs] objectAtIndex:0]]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(imgView) + margin, 100, 30)];
//    lbl.text = @"设计师Danny";
//    lbl.textColor = [UIColor blackColor];
//    [self.view addSubview:lbl];
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    staffBtn.frame = CGRectMake( margin,MaxY(imgView) + margin, 200, 50);
    [staffBtn setTitle:@"沙龙的设计师列表" forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:staffBtn];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapBtn.frame = CGRectMake(MaxX(staffBtn) + margin,MaxY(imgView) + margin, 50, 50);
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mapBtn];

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
    [self.navigationController pushViewController:[StaffDetailViewController new] animated:YES];
}


- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

@end
