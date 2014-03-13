//
//  CouponDetailViewController.m
//  WelHair
//
//  Created by lu larry on 3/12/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "UMSocial.h"
#import "MapViewController.h"
#import "SVProgressHUD.h"

@interface CouponDetailViewController ()<UMSocialUIDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CouponDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"阿东造型";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemImg = [UIImage imageNamed:@"ShareIcon"];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToSina,
                                                 UMShareToRenren,
                                                 UMShareToSms,nil]
                                       delegate:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     WIDTH(self.view),
                                                                     [self contentHeightWithNavgationBar:YES withBottomBar:YES])];
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    UIImageView *couponView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 155)];
    couponView.image = [UIImage imageNamed:@"CouponDetailViewControl_Coupon"];
    [self.scrollView addSubview:couponView];

    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(couponView) + 20, WIDTH(couponView) - 30,70)];
    [self.scrollView addSubview:infoView];
    infoView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    infoView.layer.borderWidth = 1.0;
    infoView.layer.cornerRadius = 5;
    infoView.backgroundColor = [UIColor whiteColor];
    UILabel *addressLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 230,25)];
    addressLbl.font = [UIFont systemFontOfSize:14];
    addressLbl.textAlignment = NSTextAlignmentLeft;
    addressLbl.backgroundColor = [UIColor clearColor];
    addressLbl.textColor = [UIColor grayColor];
    addressLbl.text = @"地址:高新区舜泰广场2号楼2004";
    [infoView addSubview:addressLbl];
    
    UIView *vLiner1View = [[UIView alloc] initWithFrame:CGRectMake(MaxX(addressLbl) + 3, Y(addressLbl), 1, HEIGHT(addressLbl))];
    vLiner1View.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [infoView addSubview:vLiner1View];
    
    FAKIcon *addressIcon = [FAKIonIcons ios7LocationIconWithSize:20];
    [addressIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImageView *addressImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(infoView) - 40, 10, 20, 20)];
    addressImg.image = [addressIcon imageWithSize:CGSizeMake(20, 20)];
    [infoView addSubview:addressImg];
    
    addressImg.userInteractionEnabled = YES;
    [addressImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
    
    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(infoView)/2, WIDTH(infoView), 1)];
    liner.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [infoView addSubview:liner];
    
    UILabel *phoneLbl =[[UILabel alloc] initWithFrame:CGRectMake(10,MaxY(addressLbl) + 5, 230,25)];
    phoneLbl.font = [UIFont systemFontOfSize:14];
    phoneLbl.textAlignment = NSTextAlignmentLeft;
    phoneLbl.backgroundColor = [UIColor clearColor];
    phoneLbl.textColor = [UIColor grayColor];
    phoneLbl.text = @"电话:1555555555";
    [infoView addSubview:phoneLbl];
    
    UIView *vLiner2View = [[UIView alloc] initWithFrame:CGRectMake(MaxX(phoneLbl) + 3, Y(phoneLbl), 1, HEIGHT(addressLbl))];
    vLiner2View.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [infoView addSubview:vLiner2View];
    
    FAKIcon *phoneIcon = [FAKIonIcons ios7TelephoneIconWithSize:20];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImageView *phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(infoView) - 40, MaxY(addressLbl) + 10, 20, 20)];
    phoneImgView.userInteractionEnabled = YES;
    [phoneImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)]];
    phoneImgView.image = [phoneIcon imageWithSize:CGSizeMake(20, 20)];
    [infoView addSubview:phoneImgView];
        
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  MaxY(self.scrollView),
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"领取" forState:UIControlStateNormal];
    submitBtn.tag = 0;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
    
    UILabel *titleLbl =[[UILabel alloc] initWithFrame:CGRectMake(X(infoView),MaxY(infoView) + 5, 100,25)];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.text = @"商家信息";
    [self.scrollView addSubview:titleLbl];
    
    
    UIView *instructionView = [[UIView alloc] initWithFrame:CGRectMake(X(infoView), MaxY(titleLbl) + 5, WIDTH(infoView), 100)];
    [self.scrollView addSubview:instructionView];
    instructionView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    instructionView.layer.borderWidth = 1.0;
    instructionView.layer.cornerRadius = 5;
    instructionView.backgroundColor = [UIColor whiteColor];

    UILabel *contentLbl =[[UILabel alloc] initWithFrame:CGRectMake(10,0, WIDTH(instructionView) -20,HEIGHT(instructionView))];
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.numberOfLines = 0;
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.backgroundColor = [UIColor clearColor];
    contentLbl.textColor = [UIColor grayColor];
    contentLbl.text = @"服务流程:剪发，烫发，护理，全程约2小时\n染发类型:全染\n烫发类型:冷烫热烫均可";
    [instructionView addSubview:contentLbl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (void)phoneCall
{
    
}

- (void)submitClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 0)
    {
        btn.tag = 1;
        [SVProgressHUD showSuccessWithStatus:@"领取成功" duration:1];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        btn.userInteractionEnabled = NO;
    }
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
