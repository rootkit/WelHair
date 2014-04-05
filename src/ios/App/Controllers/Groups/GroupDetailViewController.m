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
#import "JOLImageSlider.h"
#import "MapPickerViewController.h"
#import "UMSocial.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MWPhotoBrowser.h"
#import "GroupStaffCell.h"
#import "Group.h"
#import "GroupProductListViewController.h"
#import "GroupStaffListViewController.h"
#import "CommentsViewController.h"
#import "ToggleButton.h"

@interface GroupDetailViewController()<MapPickViewDelegate,UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) NSMutableArray *groupImgs;
@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;

@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) ToggleButton *heartBtn;

@property (nonatomic, strong) UIButton *staffTabBtn;
@property (nonatomic, strong) UIButton *productTabBtn;
@property (nonatomic, strong) UIButton *commentTabBtn;
@property (nonatomic, strong) Group *groupData;
@property (nonatomic, strong) UITableView *tableView;


@end
static const   float profileViewHeight = 320;
@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"沙龙详情";
//        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
//        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
//        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
//        
//        self.rightNavItemImg  = [UIImage imageNamed:@"ShareIcon"];
    
    }
    return self;
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
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToSina,
                                                 UMShareToRenren,
                                                 UMShareToSms,nil]
                                       delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)loadView
{
    [super loadView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];

    float addressViewHeight = 50;
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    
    float topViewHeight = isIOS7 ? kStatusBarHeight + kTopBarHeight : kTopBarHeight;
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), topViewHeight)];
    topNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topNavView];
    
    UIView *topNavbgView = [[UIView alloc] initWithFrame:topNavView.bounds];
    topNavbgView.backgroundColor = [UIColor lightGrayColor];
    topNavbgView.alpha = 0.4;
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
    
    UIImage *rightImg = [UIImage imageNamed:@"ShareIcon"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(WIDTH(topNavView) - 40 , topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [topNavView addSubview:rightBtn];
    
    [self.view bringSubviewToFront:topNavView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight + addressViewHeight+ tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView_];
#pragma topbar
   
    
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [headerView_ addSubview:self.imgSlider];

    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, profileViewHeight, WIDTH(headerView_), tabButtonViewHeight)];
    UIImageView *addressViewBg = [[UIImageView alloc] initWithFrame:addressView.bounds];
    addressViewBg.image = [UIImage imageNamed:@"Profile_Bottom_Bg"];
    [addressView addSubview:addressViewBg];
    [headerView_ addSubview:addressView];
    
    self.avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.avatorImgView.layer.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
    [headerView_ addSubview:self.avatorImgView];

    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, 200, 40)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor blackColor];
    self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.groupNameLbl.text = @"沙宣";
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.groupNameLbl];
    
//    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl), Y(self.self.addressLbl),20,20)];
//    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
//    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"000"]];
//    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
//    locationImg.userInteractionEnabled = YES;
//    [locationImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
//    [addressView addSubview:locationImg];

    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak GroupDetailViewController *selfDelegate = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn){
                           [selfDelegate favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake(MaxX(self.groupNameLbl), 10,30,30);
    [addressView addSubview:self.heartBtn];
    
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(addressView) + 10, WIDTH(headerView_) - 20, 30)];
    UIColor *tabViewColor =[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] ;
    [headerView_ addSubview:tabView];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.layer.borderColor = [tabViewColor CGColor];
    tabView.layer.borderWidth = 1;
    tabView.layer.cornerRadius = 5;
    float tabButtonWidth = 300 / 3;
    
    self.staffTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.staffTabBtn.frame = CGRectMake(0,0,tabButtonWidth,30);
    self.staffTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.staffTabBtn setTitle:@"设计师(100)" forState:UIControlStateNormal];
    [self.staffTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    [self.staffTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];       self.staffTabBtn.tag = 0;
    [tabView addSubview:self.staffTabBtn];
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.staffTabBtn),0, 1, HEIGHT(tabView))];
    separatorView1.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView1];
    
    self.productTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productTabBtn.frame = CGRectMake(MaxX(self.staffTabBtn)+1,0,tabButtonWidth,30);
    [self.productTabBtn setTitle:@"商品" forState:UIControlStateNormal];
    self.productTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.productTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    self.productTabBtn.titleLabel.textColor = tabViewColor;
    [self.productTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];       self.productTabBtn.tag = 1;
    [tabView addSubview:self.productTabBtn];
    
    
    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.productTabBtn),0, 1, HEIGHT(tabView))];
    separatorView2.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView2];
    
    self.commentTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentTabBtn.frame = CGRectMake(MaxX(self.productTabBtn)+1,0,tabButtonWidth,30);
    [self.commentTabBtn setTitle:@"评论" forState:UIControlStateNormal];
    self.commentTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.commentTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    self.commentTabBtn.titleLabel.textColor = tabViewColor;
    [self.commentTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    self.commentTabBtn.tag = 2;
    [tabView addSubview:self.commentTabBtn];
    

    
    UIView *detainInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(tabView) + 10, 300, 100)];
    detainInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:detainInfoView];
    detainInfoView.layer.borderWidth = 0.5;
    detainInfoView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    detainInfoView.layer.cornerRadius = 5;
    
    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,50,50)];
    addressTitleLbl.textAlignment = NSTextAlignmentLeft;
    addressTitleLbl.textColor = [UIColor grayColor];
    addressTitleLbl.font = [UIFont systemFontOfSize:12];
    addressTitleLbl.backgroundColor = [UIColor clearColor];
    addressTitleLbl.text = @"地址:";
    [detainInfoView addSubview:addressTitleLbl];

    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(addressTitleLbl),Y(addressTitleLbl), 180, 50)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [detainInfoView addSubview:self.addressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl) + 10, 15,20,20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:30];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(30, 30)];
    locationImg.userInteractionEnabled = YES;
    [locationImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
    [detainInfoView addSubview:locationImg];
    
    UIView *tabContentLiner = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressLbl), WIDTH(tabView), 1)];
    tabContentLiner.backgroundColor = [UIColor lightGrayColor];
    [detainInfoView addSubview:tabContentLiner];
    
    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(tabContentLiner),50,50)];
    photoTitle.textAlignment = NSTextAlignmentLeft;
    photoTitle.textColor = [UIColor grayColor];
    photoTitle.font = [UIFont systemFontOfSize:12];
    photoTitle.backgroundColor = [UIColor clearColor];
    photoTitle.text = @"电话:";
    [detainInfoView addSubview:photoTitle];
    
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(photoTitle),Y(photoTitle), 180, 50)];
    self.phoneLbl.backgroundColor = [UIColor clearColor];
    self.phoneLbl.textColor = [UIColor grayColor];
    self.phoneLbl.font = [UIFont systemFontOfSize:12];
    self.phoneLbl.textAlignment = NSTextAlignmentLeft;;
    [detainInfoView addSubview:self.phoneLbl];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.phoneLbl) + 10, MaxY(tabContentLiner) + 15,20,20)];
    FAKIcon *phoneIcon = [FAKIonIcons ios7TelephoneIconWithSize:30];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    phoneImg.image = [phoneIcon imageWithSize:CGSizeMake(30, 30)];
    phoneImg.userInteractionEnabled = YES;
    [phoneImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneClick)]];
    [detainInfoView addSubview:phoneImg];
    
    self.scrollView.scrollEnabled = YES;
    float scrollViewContentHeight = MAX(MaxY(detainInfoView), self.view.bounds.size.height) + 10;
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), scrollViewContentHeight);
    
    self.groupData = [FakeDataHelper getFakeGroup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *sliderArray = [NSMutableArray array];
    for (NSString *item in self.groupData.imgUrls) {
        JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
        slideImg.image = item;
        [sliderArray addObject:slideImg];
    }
    [self.imgSlider setSlides:sliderArray];
    
    self.groupImgs = [NSMutableArray array];
    for (NSString *item in self.groupData.imgUrls){
        [self.groupImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }
    
    self.addressLbl.text = @"高新区舜华北路舜泰广场2号楼";
    self.phoneLbl.text = @"15666666666";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn == self.staffTabBtn){
        GroupStaffListViewController *vc = [GroupStaffListViewController new];
        vc.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeStaffList]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(btn == self.productTabBtn){
        GroupProductListViewController *vc = [GroupProductListViewController new];
        vc.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeProductList]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(btn == self.commentTabBtn){
        CommentsViewController *vc = [CommentsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)favClick:(BOOL)isOn
{
    
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (void)phoneClick
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"15665815012"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    [self OpenImageGallery];
}


#pragma pick map delegate
- (void)didPickLocation:(CLLocation *)location
{
    self.addressLbl.text = [NSString stringWithFormat:@"la:%f, lo:%f",location.coordinate.latitude, location.coordinate.longitude];
}



- (void) OpenImageGallery
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nc animated:YES completion:Nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.groupImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.groupImgs.count)
        return [self.groupImgs objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [self.groupImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    NSLog(@"ACTION!");
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}
@end
