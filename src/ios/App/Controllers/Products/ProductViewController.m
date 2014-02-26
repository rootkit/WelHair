//
//  ProductViewController.m
//  WelHair
//
//  Created by lu larry on 2/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductViewController.h"
#import <FontAwesomeKit.h>
#import "UMSocial.h"

@interface ProductViewController ()<UMSocialUIDelegate>

@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *searchIcon = [FAKIonIcons ios7RedoOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
        self.rightNavItemIcon = [searchIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)rightNavItemClick
{
    NSString *shareText = @"我的分享";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToWechatSession,
                                                 UMShareToWechatTimeline,
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToQzone,
                                                 UMShareToSina,
                                                 UMShareToRenren,
                                                 UMShareToSms,nil]
                                       delegate:self];
    
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

@end
