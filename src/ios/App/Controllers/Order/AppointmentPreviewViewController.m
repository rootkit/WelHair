//
//  AppointmentPreviewViewController.m
//  WelHair
//
//  Created by lu larry on 3/12/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AppointmentPreviewViewController.h"
#import "SVProgressHUD.h"
@interface AppointmentPreviewViewController ()

@end

@implementation AppointmentPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, 190)];
    imgView.image =[UIImage imageNamed:@"AppointmentPreviewViewController_Bg"];
    [self.view addSubview:imgView];
    
    float bottomOffsetY = 0;
    if(isIOS70){
        bottomOffsetY = HEIGHT(self.view) - self.topBarOffset - kBottomBarHeight;
    }else if(isIOS6){
        bottomOffsetY = HEIGHT(self.view) - kToolBarHeight - kBottomBarHeight;
    }else{
        bottomOffsetY = HEIGHT(self.view) - kStatusBarHeight -  kToolBarHeight - kBottomBarHeight;
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  bottomOffsetY,
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
}

- (void)submitClick:(id)sender
{
    [SVProgressHUD showSuccessWithStatus:@"去支付宝支付" duration:1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
