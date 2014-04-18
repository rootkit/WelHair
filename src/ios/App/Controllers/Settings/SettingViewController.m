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

#import "FeedbackViewController.h"
#import "SettingViewController.h"
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
    float settingItemHeight = 44;
    for ( int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, maxY, 290, settingItemHeight)];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingTapped:)]];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 3;
        [self.view addSubview:view];
        
        view.tag = i;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        FAKIcon *icon = [icons objectAtIndex:i];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"]];
        img.image =[((FAKIcon *)[icons objectAtIndex:i]) imageWithSize:CGSizeMake(25, 25)];
        [view addSubview:img];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(img)+ 5, 10, 100, 25)];
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
}

- (void)settingTapped:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 0:
            [SVProgressHUD showSuccessWithStatus:@"清除完毕" duration:1];
            break;
        case 1:
            [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
            break;
        case 2:
            [SVProgressHUD showSuccessWithStatus:@"您已经使用的是最新版本" duration:1];
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

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_STATUS_CHANGE object:nil];

    [self performSelector:@selector(leftNavItemClick) withObject:nil afterDelay:1.5];
}

@end
