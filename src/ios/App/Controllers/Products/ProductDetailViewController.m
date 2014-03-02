//
//  ProductViewController.m
//  WelHair
//
//  Created by lu larry on 2/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <FontAwesomeKit.h>
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "CommentsViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "SelectionPanel.h"

@interface ProductDetailViewController ()<UMSocialUIDelegate>

@end

@implementation ProductDetailViewController

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
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    categoryBtn.frame = CGRectMake(margin,MaxY(imgView) + margin, 100, 50);
    [categoryBtn setTitle:@"选择商品参数" forState:UIControlStateNormal];
    [categoryBtn addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:categoryBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentBtn.frame = CGRectMake(MaxX(categoryBtn) + margin,Y(categoryBtn), 100, 50);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:commentBtn];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)categoryClick
{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    SelectionPanel *panel = [SelectionPanel new];
    panel.frame = CGRectMake(0, 0, 320, 300);
    panel.backgroundColor = [UIColor grayColor];
    [self.tabBarController presentSemiView:panel withOptions:nil];
}

- (void)commentClick
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}


@end
