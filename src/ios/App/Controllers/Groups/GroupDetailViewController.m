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

#import "CommentsViewController.h"
#import "Group.h"
#import "GroupDetailViewController.h"
#import "GroupProductListViewController.h"
#import "GroupStaffCell.h"
#import "GroupStaffListViewController.h"
#import "JOLImageSlider.h"
#import "MapPickerViewController.h"
#import "MapViewController.h"
#import "MWPhotoBrowser.h"
#import "StaffDetailViewController.h"
#import "ToggleButton.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "UserManager.h"

static const float profileViewHeight = 320;

@interface GroupDetailViewController()<MapPickViewDelegate,UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *groupImgs;

@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) ToggleButton *heartBtn;

@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *phoneLbl;

@property (nonatomic, strong) UIButton *staffTabBtn;
@property (nonatomic, strong) UIButton *productTabBtn;
@property (nonatomic, strong) UIButton *commentTabBtn;

@end

@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
{
    NSString *shareText = @"快来这里看看吧";
    UIImageView *v = [[UIImageView alloc] init];
    [v setImageWithURL:self.group.imgUrls[0]];
    UIImage *img = v.image;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToSina,
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToWechatSession,nil]
                                       delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if([viewControllers objectAtIndex:viewControllers.count - 1] == self){
        // navigationController is presenting viewcontrolls
    }else{
        // navigationController is pushing or poping viewcontrolls
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
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
    float tabButtonWidth = 300 / 3;
    
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
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight + addressViewHeight + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView_];

#pragma topbar
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [headerView_ addSubview:self.imgSlider];

    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, profileViewHeight, WIDTH(headerView_), tabButtonViewHeight)];
    [headerView_ addSubview:addressView];
    
    addressView.backgroundColor = [UIColor whiteColor];
    UIView *addressFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(addressView), WIDTH(addressView), 7)];
    addressFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [headerView_ addSubview:addressFooterView];
    
    self.avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 1;
    [headerView_ addSubview:self.avatorImgView];

    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, 200, 40)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor blackColor];
    self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.groupNameLbl];

    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak GroupDetailViewController *selfDelegate = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn) {
                           return [selfDelegate favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake(MaxX(self.groupNameLbl), 10, 30, 30);
    [addressView addSubview:self.heartBtn];

    UIColor *tabViewColor =[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];

    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(addressView) + 10, WIDTH(headerView_) - 20, 30)];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.layer.borderColor = [tabViewColor CGColor];
    tabView.layer.borderWidth = 1;
    tabView.layer.cornerRadius = 5;
    [headerView_ addSubview:tabView];
    
    self.staffTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.staffTabBtn.tag = 0;
    self.staffTabBtn.frame = CGRectMake(0, 0, tabButtonWidth, 30);
    self.staffTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.staffTabBtn.titleLabel.textColor = tabViewColor;
    [self.staffTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    [self.staffTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:self.staffTabBtn];
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.staffTabBtn),0, 1, HEIGHT(tabView))];
    separatorView1.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView1];
    
    self.productTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productTabBtn.tag = 1;
    self.productTabBtn.frame = CGRectMake(MaxX(self.staffTabBtn) +1, 0, tabButtonWidth, 30);
    self.productTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.productTabBtn.titleLabel.textColor = tabViewColor;
    [self.productTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    [self.productTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:self.productTabBtn];

    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.productTabBtn),0, 1, HEIGHT(tabView))];
    separatorView2.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView2];
    
    self.commentTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentTabBtn.tag = 2;
    self.commentTabBtn.frame = CGRectMake(MaxX(self.productTabBtn) + 1,0, tabButtonWidth, 30);
    self.commentTabBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.commentTabBtn.titleLabel.textColor = tabViewColor;
    [self.commentTabBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    [self.commentTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:self.commentTabBtn];

    UIView *detainInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(tabView) + 10, 300, 88)];
    detainInfoView.backgroundColor = [UIColor whiteColor];
    detainInfoView.layer.borderWidth = 0.5;
    detainInfoView.layer.borderColor = [[UIColor colorWithHexString:@"cccccc"] CGColor];
    detainInfoView.layer.cornerRadius = 5;
    [self.scrollView addSubview:detainInfoView];
    
    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    addressTitleLbl.textAlignment = TextAlignmentLeft;
    addressTitleLbl.textColor = [UIColor grayColor];
    addressTitleLbl.font = [UIFont systemFontOfSize:12];
    addressTitleLbl.backgroundColor = [UIColor clearColor];
    addressTitleLbl.text = @"地址:";
    [detainInfoView addSubview:addressTitleLbl];

    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(addressTitleLbl),Y(addressTitleLbl), 190, 44)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.textAlignment = TextAlignmentLeft;
    [detainInfoView addSubview:self.addressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl) + 20, 12, 20, 20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:30];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(30, 30)];
    locationImg.userInteractionEnabled = YES;
    [detainInfoView addSubview:locationImg];
    [locationImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
    
    UIView *tabContentLiner = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressLbl), WIDTH(tabView), .5)];
    tabContentLiner.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [detainInfoView addSubview:tabContentLiner];
    
    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(tabContentLiner), 44, 44)];
    photoTitle.textAlignment = TextAlignmentLeft;
    photoTitle.textColor = [UIColor grayColor];
    photoTitle.font = [UIFont systemFontOfSize:12];
    photoTitle.backgroundColor = [UIColor clearColor];
    photoTitle.text = @"电话:";
    [detainInfoView addSubview:photoTitle];
    
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(photoTitle), Y(photoTitle), 190, 44)];
    self.phoneLbl.backgroundColor = [UIColor clearColor];
    self.phoneLbl.textColor = [UIColor grayColor];
    self.phoneLbl.font = [UIFont systemFontOfSize:12];
    self.phoneLbl.textAlignment = TextAlignmentLeft;
    [detainInfoView addSubview:self.phoneLbl];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.phoneLbl) + 20, MaxY(tabContentLiner) + 12, 20, 20)];
    FAKIcon *phoneIcon = [FAKIonIcons ios7TelephoneIconWithSize:30];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    phoneImg.image = [phoneIcon imageWithSize:CGSizeMake(30, 30)];
    phoneImg.userInteractionEnabled = YES;
    [detainInfoView addSubview:phoneImg];
    [phoneImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneClick)]];

    float scrollViewContentHeight = MAX(MaxY(detainInfoView), self.view.bounds.size.height) + 40;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), scrollViewContentHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *sliderArray = [NSMutableArray array];
    for (NSString *item in self.group.imgUrls) {
        JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
        slideImg.image = item;
        [sliderArray addObject:slideImg];
    }
    [self.imgSlider setSlides:sliderArray];
    
    self.groupImgs = [NSMutableArray array];
    for (NSString *item in self.group.imgUrls) {
        [self.groupImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }

    [self.avatorImgView setImageWithURL:[NSURL URLWithString:self.group.logoUrl]];
    self.addressLbl.text = self.group.address;
    self.phoneLbl.text = (self.group.tel && ![self.group.tel isEqualToString:@""]) ? self.group.tel : self.group.mobile;
    self.groupNameLbl.text = self.group.name;

    [self.staffTabBtn setTitle:[NSString stringWithFormat:@"设计师(%d)", self.group.staffCount]
                      forState:UIControlStateNormal];
    [self.productTabBtn setTitle:@"商品" forState:UIControlStateNormal];
    [self.commentTabBtn setTitle:@"评论" forState:UIControlStateNormal];

    [self getGroupDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn == self.staffTabBtn) {
        GroupStaffListViewController *vc = [GroupStaffListViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(btn == self.productTabBtn) {
        GroupProductListViewController *vc = [GroupProductListViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(btn == self.commentTabBtn) {
        CommentsViewController *vc = [CommentsViewController new];
        vc.companyId = self.group.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)favClick:(BOOL)isOn
{
    if(![self checkLogin]){
        return NO;
    }
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[UserManager SharedInstance] userLogined].id] forKey:@"CreatedBy"];
    [reqData setObject:[NSString stringWithFormat:@"%d", isOn ? 1 : 0] forKey:@"IsLike"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_LIKE, self.group.id]]
                                                                andData:reqData];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addLikeFinish:)];
    [request setDidFailSelector:@selector(addLikeFail:)];
    [request startAsynchronous];
    return YES;
}

- (void)addLikeFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 1) {
                return;
            }
        }
    }
}

- (void)addLikeFail:(ASIHTTPRequest *)request
{
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (void)phoneClick
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.phoneLbl.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    [self OpenImageGallery];
}

#pragma pick map delegate

- (void)didPickLocation:(CLLocation *)location
{
    self.addressLbl.text = [NSString stringWithFormat:@"la:%f, lo:%f",location.coordinate.latitude, location.coordinate.longitude];
}

- (void)OpenImageGallery
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

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.groupImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.groupImgs.count) {
        return [self.groupImgs objectAtIndex:index];
    }

    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.groupImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}

- (void)getGroupDetail
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_DETAIL, self.group.id]]
                                                          andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetGroupDetail:)];
    [request setDidFailSelector:@selector(failGetGroupDetail:)];
    [request startAsynchronous];
}

- (void)finishGetGroupDetail:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if (![rst objectForKey:@"CompanyId"]) {
        return;
    }

    self.heartBtn.on = [[rst objectForKey:@"IsLiked"] intValue] == 1;
}

- (void)failGetGroupDetail:(ASIHTTPRequest *)request
{
}

@end
