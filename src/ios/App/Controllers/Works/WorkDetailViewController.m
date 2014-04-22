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

#import "CircleImageView.h"
#import "CommentsViewController.h"
#import "JOLImageSlider.h"
#import "MapViewController.h"
#import "MWPhotoBrowser.h"
#import "StaffDetailViewController.h"
#import "UMSocial.h"
#import "UserManager.h"
#import "WorkDetailViewController.h"

@interface WorkDetailViewController () <UMSocialUIDelegate, JOLImageSliderDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) UIImageView *staffImgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) NSMutableArray *workImgs;
@property (nonatomic, strong) ToggleButton *heartBtn;

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
    self.scrollView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [self.view addSubview:self.scrollView];

#pragma topbar
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

    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:self.imgSlider];

#pragma staffView
    UIView *staffView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.imgSlider) - 80, 200, 80)];
    staffView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:staffView];

    UIImageView *staffOverlayview = [[UIImageView alloc] initWithFrame:CGRectMake(-60, 20, WIDTH(staffView), HEIGHT(staffView) - 20)];
    staffOverlayview.image = [UIImage imageNamed:@"WD_AuthorLayerBg@2x"];
    [staffView addSubview:staffOverlayview];
    
    self.staffImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
    self.staffImgView.userInteractionEnabled = YES;
    [self.staffImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staffTapped)]];
    [staffView addSubview:self.staffImgView];

    self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(self.staffImgView) + 2, 150, 20)];
    self.staffNameLbl.textAlignment = NSTextAlignmentLeft;
    self.staffNameLbl.textColor = [UIColor whiteColor];
    self.staffNameLbl.backgroundColor = [UIColor clearColor];
    self.staffNameLbl.font = [UIFont systemFontOfSize:14];
    [staffView addSubview:self.staffNameLbl];
    
    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak WorkDetailViewController *selfDelegate = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn){
                          return [selfDelegate favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake(MaxX(self.staffImgView) + 30, 35, 30, 30);
    [staffView addSubview:self.heartBtn];
    
//    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.staffImgView) + 10, 25, 20, 20)];
//    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
//    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FFF"]];
//    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
//    [staffView addSubview:locationImg];
//    
//    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, 25, WIDTH(staffView) - MaxX(locationImg), HEIGHT(locationImg))];
//    self.distanceLbl.textAlignment = NSTextAlignmentLeft;
//    self.distanceLbl.textColor = [UIColor whiteColor];
//    self.distanceLbl.font = [UIFont systemFontOfSize:14];
//    self.distanceLbl.backgroundColor = [UIColor clearColor];
//    self.distanceLbl.font = [UIFont systemFontOfSize:14];
//    [staffView addSubview:self.distanceLbl];
    
#pragma people  view
    UIView *peopleView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(self.imgSlider )+ 20, 280, 160)];
    peopleView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    peopleView.layer.borderWidth = 1;
    peopleView.layer.cornerRadius = 5;
    peopleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:peopleView];

    UILabel *peopleTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100,20)];
    peopleTitleLbl.font = [UIFont systemFontOfSize:14];
    peopleTitleLbl.textAlignment = TextAlignmentLeft;
    peopleTitleLbl.backgroundColor = [UIColor clearColor];
    peopleTitleLbl.textColor = [UIColor blackColor];
    peopleTitleLbl.text = @"适合人群";
    [peopleView addSubview:peopleTitleLbl];

    UIView *peopleLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(peopleTitleLbl) + 15, WIDTH(peopleView), 1)];
    peopleLinerView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [peopleView addSubview:peopleLinerView];
    
    float leftlblWidth = 40;
    float opitionMargin = 10;
    float opitionWidth = 46;

    UIColor *opitionBgColor = [UIColor colorWithHexString:@"787878"];
    UIColor *opitionSelectedBgColor = [UIColor colorWithHexString:APP_BASE_COLOR];

#pragma nature cell view
    UILabel *natureLbl =[[UILabel alloc] initWithFrame:CGRectMake(0,MaxY(peopleLinerView) + 10,leftlblWidth,20)];
    natureLbl.font = [UIFont systemFontOfSize:14];
    natureLbl.textAlignment = TextAlignmentRight;
    natureLbl.backgroundColor = [UIColor clearColor];
    natureLbl.textColor = [UIColor grayColor];
    natureLbl.text = @"发质:";
    [peopleView addSubview:natureLbl];
    
    UILabel *nature1Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(natureLbl) + opitionMargin,Y(natureLbl),opitionWidth,20)];
    nature1Lbl.font = [UIFont systemFontOfSize:14];
    nature1Lbl.textAlignment = TextAlignmentCenter;
    nature1Lbl.backgroundColor = self.work.hairStyle == HairStyleEnumShort ? opitionSelectedBgColor : opitionBgColor;
    nature1Lbl.textColor = [UIColor whiteColor];
    nature1Lbl.text = @"短发";
    [peopleView addSubview:nature1Lbl];
    
    UILabel *nature2Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(nature1Lbl) + opitionMargin,Y(natureLbl),opitionWidth,20)];
    nature2Lbl.font = [UIFont systemFontOfSize:14];
    nature2Lbl.textAlignment = TextAlignmentCenter;
    nature2Lbl.backgroundColor = self.work.hairStyle == HairStyleEnumLong ? opitionSelectedBgColor : opitionBgColor;
    nature2Lbl.textColor = [UIColor whiteColor];
    nature2Lbl.text = @"长发";
    [peopleView addSubview:nature2Lbl];
    
    UILabel *nature3Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(nature2Lbl) + opitionMargin,Y(natureLbl),opitionWidth,20)];
    nature3Lbl.font = [UIFont systemFontOfSize:14];
    nature3Lbl.textAlignment = TextAlignmentCenter;
    nature3Lbl.backgroundColor = self.work.hairStyle == HairStyleEnumPlait ? opitionSelectedBgColor : opitionBgColor;
    nature3Lbl.textColor = [UIColor whiteColor];
    nature3Lbl.text = @"编发";
    [peopleView addSubview:nature3Lbl];
    
    UILabel *nature4Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(nature3Lbl) + opitionMargin,Y(natureLbl),opitionWidth,20)];
    nature4Lbl.font = [UIFont systemFontOfSize:14];
    nature4Lbl.textAlignment = TextAlignmentCenter;
    nature4Lbl.backgroundColor = self.work.hairStyle == HairStyleEnumMiddle ? opitionSelectedBgColor : opitionBgColor;
    nature4Lbl.textColor = [UIColor whiteColor];
    nature4Lbl.text = @"中发";
    [peopleView addSubview:nature4Lbl];

#pragma amount cell view
    UILabel *hairAmountLbl =[[UILabel alloc] initWithFrame:CGRectMake(0,MaxY(natureLbl) + 10,leftlblWidth,20)];
    hairAmountLbl.font = [UIFont systemFontOfSize:14];
    hairAmountLbl.textAlignment = TextAlignmentRight;
    hairAmountLbl.backgroundColor = [UIColor clearColor];
    hairAmountLbl.textColor = [UIColor grayColor];
    hairAmountLbl.text = @"发量:";
    [peopleView addSubview:hairAmountLbl];
    
    UILabel *amount1Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(hairAmountLbl) + opitionMargin,Y(hairAmountLbl),opitionWidth,20)];
    amount1Lbl.font = [UIFont systemFontOfSize:14];
    amount1Lbl.textAlignment = TextAlignmentCenter;
    amount1Lbl.backgroundColor = self.work.hairQuality == HairQualityHeavy ? opitionSelectedBgColor : opitionBgColor;
    amount1Lbl.textColor = [UIColor whiteColor];
    amount1Lbl.text = @"多密";
    [peopleView addSubview:amount1Lbl];
    
    UILabel *amount2Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(amount1Lbl) + opitionMargin,Y(hairAmountLbl),opitionWidth,20)];
    amount2Lbl.font = [UIFont systemFontOfSize:14];
    amount2Lbl.textAlignment = TextAlignmentCenter;
    amount2Lbl.backgroundColor = self.work.hairQuality == HairQualityMiddle ? opitionSelectedBgColor : opitionBgColor;
    amount2Lbl.textColor = [UIColor whiteColor];
    amount2Lbl.text = @"中等";
    [peopleView addSubview:amount2Lbl];
    
    UILabel *amount3Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(amount2Lbl) + opitionMargin,Y(hairAmountLbl),opitionWidth,20)];
    amount3Lbl.font = [UIFont systemFontOfSize:14];
    amount3Lbl.textAlignment = TextAlignmentCenter;
    amount3Lbl.backgroundColor = self.work.hairQuality == HairQualityLittle ? opitionSelectedBgColor : opitionBgColor;
    amount3Lbl.textColor = [UIColor whiteColor];
    amount3Lbl.text = @"偏少";
    [peopleView addSubview:amount3Lbl];
    
#pragma face frame cell view
    UILabel *faceFrameLbl =[[UILabel alloc] initWithFrame:CGRectMake(0,MaxY(hairAmountLbl) + 10,leftlblWidth,20)];
    faceFrameLbl.font = [UIFont systemFontOfSize:14];
    faceFrameLbl.textAlignment = TextAlignmentRight;
    faceFrameLbl.backgroundColor = [UIColor clearColor];
    faceFrameLbl.textColor = [UIColor grayColor];
    faceFrameLbl.text = @"脸型:";
    [peopleView addSubview:faceFrameLbl];
    
    UILabel *faceFrame1Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(faceFrameLbl) + opitionMargin,Y(faceFrameLbl),opitionWidth,20)];
    faceFrame1Lbl.font = [UIFont systemFontOfSize:14];
    faceFrame1Lbl.textAlignment = TextAlignmentCenter;
    faceFrame1Lbl.backgroundColor = self.work.faceStyleCircle ? opitionSelectedBgColor : opitionBgColor;
    faceFrame1Lbl.textColor = [UIColor whiteColor];
    faceFrame1Lbl.text = @"圆脸";
    [peopleView addSubview:faceFrame1Lbl];
    
    UILabel *faceFrame2Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(faceFrame1Lbl) + opitionMargin,Y(faceFrameLbl),opitionWidth,20)];
    faceFrame2Lbl.font = [UIFont systemFontOfSize:14];
    faceFrame2Lbl.textAlignment = TextAlignmentCenter;
    faceFrame2Lbl.backgroundColor = self.work.faceStyleLong ? opitionSelectedBgColor : opitionBgColor;
    faceFrame2Lbl.textColor = [UIColor whiteColor];
    faceFrame2Lbl.text = @"长脸";
    [peopleView addSubview:faceFrame2Lbl];
    
    UILabel *faceFrame3Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(faceFrame2Lbl) + opitionMargin,Y(faceFrameLbl),opitionWidth,20)];
    faceFrame3Lbl.font = [UIFont systemFontOfSize:14];
    faceFrame3Lbl.textAlignment = TextAlignmentCenter;
    faceFrame3Lbl.backgroundColor = self.work.faceStyleSquare ? opitionSelectedBgColor : opitionBgColor;
    faceFrame3Lbl.textColor = [UIColor whiteColor];
    faceFrame3Lbl.text = @"方脸";
    [peopleView addSubview:faceFrame3Lbl];
    
    UILabel *faceFrame4Lbl =[[UILabel alloc] initWithFrame:CGRectMake(MaxX(faceFrame3Lbl) + opitionMargin,Y(faceFrameLbl),opitionWidth,20)];
    faceFrame4Lbl.font = [UIFont systemFontOfSize:14];
    faceFrame4Lbl.textAlignment = TextAlignmentCenter;
    faceFrame4Lbl.backgroundColor = self.work.faceStyleGuaZi ? opitionSelectedBgColor : opitionBgColor;
    faceFrame4Lbl.textColor = [UIColor whiteColor];
    faceFrame4Lbl.text = @"瓜子脸";
    [peopleView addSubview:faceFrame4Lbl];


#pragma comment view
    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(peopleView) + 20, WIDTH(peopleView), 40)];
    commentCellView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    commentCellView.layer.borderWidth = 1;
    commentCellView.layer.cornerRadius = 5;
    commentCellView.backgroundColor = [UIColor whiteColor];
    [commentCellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsTapped)]];
    [self.scrollView addSubview:commentCellView];

    UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    commentLbl.font = [UIFont systemFontOfSize:14];
    commentLbl.textAlignment = NSTextAlignmentLeft;
    commentLbl.backgroundColor = [UIColor clearColor];
    commentLbl.textColor = [UIColor grayColor];
    commentLbl.text = @"评论信息";
    [commentCellView addSubview:commentLbl];

    FAKIcon *commentIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(commentCellView) - 40, 10, 20, 20)];
    commentImgView.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [commentCellView addSubview:commentImgView];

    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), MaxY(commentCellView) + 10);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *sliderArray = [NSMutableArray array];
    for (NSString *item in self.work.imgUrlList) {
        JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
        slideImg.image = item;
        [sliderArray addObject:slideImg];
    }
    [self.imgSlider setSlides:sliderArray];
    
    self.workImgs = [NSMutableArray array];
    for (NSString *item in self.work.imgUrlList) {
        [self.workImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }

    [self getWorkDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentsTapped
{
    CommentsViewController *commentVC = [CommentsViewController new];
    commentVC.workId = self.work.id;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    [self OpenImageGallery];
}

- (void)rightBtnClick
{
    NSString *shareText = @"打扮吧，美里从这里开始";
    UIImageView *v = [[UIImageView alloc] init];
    [v setImageWithURL:self.work.imgUrlList[0]];
    UIImage *img = v.image;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToSina,
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToWechatTimeline,nil]
                                       delegate:self];
}

- (void)staffTapped
{
    StaffDetailViewController *staffDetailVC = [StaffDetailViewController new];
    staffDetailVC.staff = self.work.creator;
    [self.navigationController pushViewController:staffDetailVC animated:YES];
}

- (BOOL)favClick:(BOOL)markFav
{
    if(![self checkLogin]){
        return NO;
    }
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[UserManager SharedInstance] userLogined].id] forKey:@"CreatedBy"];
    [reqData setObject:[NSString stringWithFormat:@"%d", markFav ? 1 : 0] forKey:@"IsLike"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WORKS_LIKE, self.work.id]]
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
    return self.workImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.workImgs.count) {
        return [self.workImgs objectAtIndex:index];
    }

    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.workImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];

    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}

- (void)getWorkDetail
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WORKS_DETAIL, self.work.id]]
                                                          andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetWorkDetail:)];
    [request setDidFailSelector:@selector(failGetWorkDetail:)];
    [request startAsynchronous];
}

- (void)finishGetWorkDetail:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if (![rst objectForKey:@"WorkId"]) {
        return;
    }

    self.work = [[Work alloc] initWithDic:rst];

    self.staffNameLbl.text = self.work.creator.name;
    [self.staffImgView setImageWithURL:self.work.creator.avatorUrl];

    float distance = [[rst objectForKey:@"Distance"] floatValue];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.2f 千米", distance / 1000];
    self.heartBtn.on = [[rst objectForKey:@"IsLiked"] intValue] == 1;
}

- (void)failGetWorkDetail:(ASIHTTPRequest *)request
{
}

@end
