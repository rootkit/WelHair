//
//  SettingViewController.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    NSArray *icons = @[[FAKIonIcons ios7TrashOutlineIconWithSize:NAV_BAR_ICON_SIZE],
                       [FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE],
                       [FAKIonIcons ios7RefreshEmptyIconWithSize:NAV_BAR_ICON_SIZE],
                       [FAKIonIcons ios7StarOutlineIconWithSize:NAV_BAR_ICON_SIZE]
                       ];
    NSArray *txt = @[@"清除缓存",@"意见反馈",@"版本更新",@"给我们打分"];
    float margin = 10;
    float maxY = self.topBarOffset + margin;
    float settingItemHeight = 45;
    for ( int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, maxY, 290, settingItemHeight)];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingTapped:)]];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [[UIColor colorWithHexString:@"b3b3b3"] CGColor];
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 3;
        [self.view addSubview:view];
        
        view.tag = i;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        FAKIcon *icon = [icons objectAtIndex:i];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b3b3b3"]];
        img.image =[((FAKIcon *)[icons objectAtIndex:i]) imageWithSize:CGSizeMake(25, 25)];
        [view addSubview:img];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(img)+ 5, 10, 100,25)];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor grayColor];
        nameLbl.font = [UIFont systemFontOfSize:14];
        nameLbl.text = [txt objectAtIndex:i];
        nameLbl.textAlignment = NSTextAlignmentLeft;;
        [view addSubview:nameLbl];
        maxY += settingItemHeight + margin;
        [self.view addSubview:view];
    }
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(40, maxY + 10, WIDTH(self.view) - 80,50);
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.backgroundColor = [UIColor colorWithHexString:@"e4393c"];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:logoutBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingTapped:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 0:
            [SVProgressHUD showSuccessWithStatus:@"Clean" duration:1];
            break;
        case 1:
            [SVProgressHUD showSuccessWithStatus:@"Feedback" duration:1];
            break;
        case 2:
            [SVProgressHUD showSuccessWithStatus:@"Version Check" duration:1];
            break;
        case 3:
            [SVProgressHUD showSuccessWithStatus:@"Rate" duration:1];
            break;
            
        default:
            break;
    }
}

- (void)logout
{
    [SVProgressHUD showSuccessWithStatus:@"注销成功" duration:1];
    [[UserManager SharedInstance] signout];

    [self performSelector:@selector(leftNavItemClick) withObject:nil afterDelay:1.5];
}

@end
