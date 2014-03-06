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
#import "Work.h"
#import "UMSocial.h"
#import "CircleImageView.h"

@interface WorkDetailViewController ()<UMSocialUIDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *staffImgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
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

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
#pragma topbar
    float topViewHeight = isIOS7 ? kStatusBarHeight + kTopBarHeight : kTopBarHeight;
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), topViewHeight)];
    topNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topNavView];
    
    UIView *topNavbgView = [[UIView alloc] initWithFrame:topNavView.bounds];
    topNavbgView.backgroundColor = [UIColor lightGrayColor];
    topNavbgView.alpha = 0.2;
    [topNavView addSubview:topNavbgView];
    // top left button
    FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [topNavView addSubview:leftBtn];
    // top right button
    FAKIcon *rightIcon = [FAKIonIcons ios7RedoOutlineIconWithSize:NAV_BAR_ICON_SIZE];
    [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *rightImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(WIDTH(topNavView) - 30 , topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [topNavView addSubview:rightBtn];
    
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f6fbfe"];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,
                                                                         WIDTH(self.view),
                                                                         WIDTH(self.view))];
    [self.scrollView addSubview:imgView];
    NSString *imgUrl = self.work.imgsUrl.count > 0? self.work.imgsUrl[0] : nil;
    [imgView setImageWithURL:[NSURL URLWithString:imgUrl]];
    
#pragma staffView
    UIView *staffView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(imgView) - 80, WIDTH(imgView) / 2, 80)];
    [self.scrollView addSubview:staffView];
    staffView.backgroundColor = [UIColor clearColor];
    UIView *staffOverlayview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH(staffView), HEIGHT(staffView) -20)];
    staffOverlayview.backgroundColor = [UIColor grayColor];
    staffOverlayview.alpha = 0.5;
    [staffView addSubview:staffOverlayview];
    
    self.staffImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
    [staffView addSubview:self.staffImgView];
    self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.staffImgView), MaxY(self.staffImgView) + 2,WIDTH(self.staffImgView), 20)];
    self.staffNameLbl.textAlignment = NSTextAlignmentCenter;
    self.staffNameLbl.textColor = [UIColor whiteColor];
    self.staffNameLbl.backgroundColor = [UIColor clearColor];
    self.staffNameLbl.font = [UIFont systemFontOfSize:14];
    
    [staffView addSubview:self.staffNameLbl];
    
    UIImageView *heartImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxY(self.staffImgView) + 50, 25, 25, 25)];
    [staffView addSubview:heartImgView];
    FAKIcon *heartIcon = [FAKIonIcons heartIconWithSize:25];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    heartImgView.image = [heartIcon imageWithSize:CGSizeMake(25, 25)];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxY(self.staffImgView) + 40, Y(self.staffNameLbl),HEIGHT(self.staffNameLbl),HEIGHT(self.staffNameLbl))];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FFF"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
    [staffView addSubview:locationImg];
    
    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),WIDTH(staffView) - MaxX(locationImg), HEIGHT(locationImg))];
    self.distanceLbl.textAlignment = NSTextAlignmentCenter;
    self.distanceLbl.textColor = [UIColor whiteColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:14];
    self.distanceLbl.backgroundColor = [UIColor clearColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:14];
    [staffView addSubview:self.distanceLbl];
    
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
//    lbl.text = @"作品详情";
//    lbl.textColor = [UIColor blackColor];
//    [self.view addSubview:lbl];
    
//    UIButton *staffBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    staffBtn.frame = CGRectMake(margin,MaxY(imgView) + margin, 100, 50);
//    [staffBtn setTitle:@"发型师" forState:UIControlStateNormal];
//    [staffBtn addTarget:self action:@selector(staffClick) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:staffBtn];
//    
//    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    commentBtn.frame = CGRectMake(MaxX(staffBtn) + margin,Y(staffBtn), 100, 50);
//    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
//    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:commentBtn];
//
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:Nil
//               forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"e1e3e2"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.staffImgView setImageWithURL:[NSURL URLWithString:self.work.creator.avatorUrl]];
    self.staffNameLbl.text = self.work.creator.name;
    self.distanceLbl.text = @"1千米";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
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
