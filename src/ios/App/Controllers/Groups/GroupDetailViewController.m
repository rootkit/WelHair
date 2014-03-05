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
#import "MapPickerViewController.h"
@interface GroupDetailViewController ()<MapPickViewDelegate>
@property (nonatomic, strong) UILabel *addressLbl;
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
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    staffBtn.frame = CGRectMake(0,MaxY(imgView) + margin, 150, 50);
    [staffBtn setTitle:@"沙龙设计师列表" forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:staffBtn];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapBtn.frame = CGRectMake(MaxX(staffBtn) + margin,MaxY(imgView) + margin, 50, 50);
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mapBtn];
    
    UIButton *pickPointBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pickPointBtn.frame = CGRectMake(MaxX(mapBtn) + margin,MaxY(imgView) + margin, 50, 50);
    [pickPointBtn setTitle:@"选坐标" forState:UIControlStateNormal];
    [pickPointBtn addTarget:self action:@selector(pickPointClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pickPointBtn];

    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(pickPointBtn) + margin, 200, 30)];
    self.addressLbl.text = @"";
    self.addressLbl.textColor = [UIColor blackColor];
    [self.view addSubview:self.addressLbl];
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

- (void)pickPointClick
{
    
    MapPickViewController *picker = [MapPickViewController new];
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
}

#pragma pick map delegate
- (void)didPickLocation:(CLLocation *)location
{
    self.addressLbl.text = [NSString stringWithFormat:@"la:%f, lo:%f",location.coordinate.latitude, location.coordinate.longitude];
}

@end
