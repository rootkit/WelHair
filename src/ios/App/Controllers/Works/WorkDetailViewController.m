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
#import "WorkDetailViewController.h"
#import "CommentsViewController.h"
#import "StaffDetailViewController.h"
#import "MapViewController.h"
#import "UIImageView+WebCache.h"

@interface WorkDetailViewController ()

@end

@implementation WorkDetailViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"作品";
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
    
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
//    lbl.text = @"作品详情";
//    lbl.textColor = [UIColor blackColor];
//    [self.view addSubview:lbl];
    
    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    staffBtn.frame = CGRectMake(margin,MaxY(imgView) + margin, 100, 50);
    [staffBtn setTitle:@"发型师" forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:staffBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentBtn.frame = CGRectMake(MaxX(staffBtn) + margin,Y(staffBtn), 100, 50);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:commentBtn];
//    
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

- (void)staffClick
{
    [self.navigationController pushViewController:[StaffDetailViewController new] animated:YES];
}

- (void)commentClick
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

@end
