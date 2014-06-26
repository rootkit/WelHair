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
#import "CommentNarrowCell.h"
#import "CommentsViewController.h"
#import "JOLImageSlider.h"
#import "MapViewController.h"
#import "MWPhotoBrowser.h"
#import "StaffDetailViewController.h"
#import "UMSocial.h"
#import "UserManager.h"
#import "WorkDetailViewController.h"

@interface WorkDetailViewController () <UMSocialUIDelegate, JOLImageSliderDelegate, MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) UIImageView *staffImgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *staffAddressLbl;
@property (nonatomic, strong) UILabel *commentCountLbl;
@property (nonatomic, strong) UILabel *allCommentLbl;
@property (nonatomic, strong) NSMutableArray *workImgs;
@property (nonatomic, strong) ToggleButton *heartBtn;
@property (nonatomic, strong) UILabel *heartCountLbl;

@end

@implementation WorkDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"作品";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg  =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        FAKIcon *rightIcon = [FAKIonIcons androidShareIconWithSize:20];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(20, 20)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
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

- (void)loadView
{
    [super loadView];

    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getComments];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];

#pragma topbar

    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.headerView addSubview:self.imgSlider];
    
#pragma works list
    UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.imgSlider), 300, 70)];
    workView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    workView.layer.borderWidth = 1;
    workView.layer.cornerRadius = 5;
    workView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:workView];
    
    float imgHorizontalPadding = 8;
    float imgVeritalPadding = 5;
    float imgSize = 60;
    
    int count = MIN(self.work.imgUrlList.count, 5);
    for (int i = 0; i < count; i++) {
            NSString *imageUrl  =self.work.imgUrlList[i];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
            img.layer.cornerRadius = 3;
            img.userInteractionEnabled = YES;
            img.tag = i;
            [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
            [img setImageWithURL:[NSURL URLWithString:imageUrl]];
            [workView addSubview:img];
        }

#pragma staffView
    UIView *staffView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(workView) + 10, 300, 90)];
    staffView.backgroundColor = [UIColor whiteColor];
    staffView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    staffView.layer.borderWidth = 1;
    staffView.layer.cornerRadius = 5;
    [self.headerView addSubview:staffView];
    
    UILabel *staffTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100,20)];
    staffTitleLbl.font = [UIFont systemFontOfSize:14];
    staffTitleLbl.textAlignment = TextAlignmentLeft;
    staffTitleLbl.backgroundColor = [UIColor clearColor];
    staffTitleLbl.textColor = [UIColor blackColor];
    staffTitleLbl.text = @"发型师";
    [staffView addSubview:staffTitleLbl];
    
    UIView *staffLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(staffTitleLbl) +5, WIDTH(staffView), 1)];
    staffLinerView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [staffView addSubview:staffLinerView];
    
    self.staffImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, MaxY(staffLinerView) + 5, 50, 50)];
    self.staffImgView.userInteractionEnabled = YES;
    [self.staffImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staffTapped)]];
    [staffView addSubview:self.staffImgView];

    self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffImgView)+5,Y(self.staffImgView), 150, 25)];
    self.staffNameLbl.textAlignment = NSTextAlignmentLeft;
    self.staffNameLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
    self.staffNameLbl.backgroundColor = [UIColor clearColor];
    self.staffNameLbl.font = [UIFont systemFontOfSize:14];
    [staffView addSubview:self.staffNameLbl];
    
    self.staffAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffImgView)+5,MaxY(self.staffNameLbl), 150, 25)];
    self.staffAddressLbl.textAlignment = NSTextAlignmentLeft;
    self.staffAddressLbl.textColor = [UIColor colorWithHexString:@"666"];
    self.staffAddressLbl.backgroundColor = [UIColor clearColor];
    self.staffAddressLbl.font = [UIFont systemFontOfSize:12];
    [staffView addSubview:self.staffAddressLbl];
    
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
    self.heartBtn.frame = CGRectMake(240, 45, 25, 25);
    [staffView addSubview:self.heartBtn];
    
    self.heartCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.heartBtn), Y(self.heartBtn), 25, 25)];
    self.heartCountLbl.numberOfLines = 0;
    self.heartCountLbl.textAlignment = NSTextAlignmentLeft;
    self.heartCountLbl.font = [UIFont systemFontOfSize:12];
    self.heartCountLbl.backgroundColor = [UIColor clearColor];
    self.heartCountLbl.textColor = [UIColor colorWithHexString:@"ccc"];
    [staffView addSubview:self.heartCountLbl];
    

    
#pragma people  view
    UIView *peopleView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(staffView)+ 10, 300, 140)];
    peopleView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    peopleView.layer.borderWidth = 1;
    peopleView.layer.cornerRadius = 5;
    peopleView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:peopleView];

    UILabel *peopleTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100,20)];
    peopleTitleLbl.font = [UIFont systemFontOfSize:14];
    peopleTitleLbl.textAlignment = TextAlignmentLeft;
    peopleTitleLbl.backgroundColor = [UIColor clearColor];
    peopleTitleLbl.textColor = [UIColor blackColor];
    peopleTitleLbl.text = @"适合人群";
    [peopleView addSubview:peopleTitleLbl];

    UIView *peopleLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(peopleTitleLbl) + 5, WIDTH(peopleView), 1)];
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
    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(peopleView) + 20, WIDTH(peopleView), 30)];
    commentCellView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    commentCellView.layer.borderWidth = 1;
    commentCellView.backgroundColor = [UIColor whiteColor];

    self.commentCountLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100,20)];
    self.commentCountLbl.font = [UIFont systemFontOfSize:14];
    self.commentCountLbl.textAlignment = NSTextAlignmentLeft;
    self.commentCountLbl.backgroundColor = [UIColor clearColor];
    self.commentCountLbl.textColor = [UIColor blackColor];
    [commentCellView addSubview:self.commentCountLbl];
    
    self.allCommentLbl  =[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 160,20)];
    self.allCommentLbl.font = [UIFont systemFontOfSize:12];
    self.allCommentLbl.textAlignment = NSTextAlignmentRight;
    self.allCommentLbl.backgroundColor = [UIColor clearColor];
    self.allCommentLbl.textColor = [UIColor grayColor];
    self.allCommentLbl.text = @"查看全部";
    self.allCommentLbl.userInteractionEnabled = YES;
    [self.allCommentLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAllCommentsVc)]];
    [commentCellView addSubview:self.allCommentLbl];

    [self.headerView addSubview:commentCellView];
    self.headerView.frame = CGRectMake(0, 0, WIDTH(self.view), MaxY(commentCellView));
    self.tableView.tableHeaderView  = self.headerView;
}

- (void)workImgTapped:(UITapGestureRecognizer *)tapped
{
    [self.imgSlider scrollToIndex:tapped.view.tag animationed:YES];
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
    self.commentCountLbl.text = [NSString stringWithFormat:@"作品评论(%d)",self.work.commentCount];
    self.workImgs = [NSMutableArray array];
    for (NSString *item in self.work.imgUrlList) {
        [self.workImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }

    [self getWorkDetail];
    [self getComments];
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

- (void)gotoAllCommentsVc
{
    CommentsViewController *vc = [CommentsViewController new];
    vc.workId = self.work.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    [self OpenImageGallery];
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
    request.tag = markFav ? 1 : 0;
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
                int favCount = request.tag > 0 ? self.work.favCount + 1 : self.work.favCount - 1;
                self.work.favCount = favCount >= 0 ? favCount : 0;
                self.heartCountLbl.text = [NSString stringWithFormat:@"(%d)",self.work.favCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MARK_WORK_AS_FAVORITE object:@[@(self.work.id),@(request.tag)]];
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
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
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
    self.staffAddressLbl.text = self.work.creator.group.address;
    [self.staffImgView setImageWithURL:self.work.creator.avatorUrl];
    self.heartBtn.on = [[rst objectForKey:@"IsLiked"] intValue] == 1;
    self.heartCountLbl.text = [NSString stringWithFormat:@"(%d)", self.work.favCount];
}

- (void)failGetWorkDetail:(ASIHTTPRequest *)request
{
}


- (void)getComments
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat: API_WORKS_COMMENT_CREATE,self.work.id]] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetComments:)];
    [request setDidFailSelector:@selector(failGetComments:)];
    [request startAsynchronous];
}

- (void)finishGetComments:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"comments"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datasource];
    
    if (self.currentPage == 1) {
        [arr removeAllObjects];
    } else {
        if (self.currentPage % TABLEVIEW_PAGESIZE_DEFAULT > 0) {
            int i;
            
            for (i = 0; i < arr.count; i++) {
                if (i >= (self.currentPage - 1) * TABLEVIEW_PAGESIZE_DEFAULT) {
                    [arr removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }
    
    for (NSDictionary *dicData in dataList) {
        [arr addObject:[[Comment alloc] initWithDic:dicData]];
    }
    
    self.datasource = arr;
    
    BOOL enableInfinite = total > self.datasource.count;
    if (self.tableView.showsInfiniteScrolling != enableInfinite) {
        self.tableView.showsInfiniteScrolling = enableInfinite;
    }
    
    if (self.currentPage == 1) {
        [self.tableView stopRefreshAnimation];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    
    [self checkEmpty];
    
    [self.tableView reloadData];
}

- (void)failGetComments:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}



#pragma mark UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 20)];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comm = [self.datasource objectAtIndex:indexPath.row];
    CGSize textSize = [Util textSizeForText:comm.description withFont:[UIFont systemFontOfSize:12] andLineHeight:20];
    
    CGFloat containerHeight = textSize.height + 44;
    if (containerHeight < 60) {
        containerHeight = 60;
    }
    
    if (comm.imgUrlList.count > 0) {
        containerHeight += 46;
    }
    
    return containerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CommentCellIdentifier";
    CommentNarrowCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommentNarrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Comment *data = [self.datasource objectAtIndex: indexPath.row];
    [cell setup:data tapHandler:^(NSArray *imgArr, int currentIndex) {
        self.workImgs = [NSMutableArray array];
        for (UIImageView *item in imgArr) {
            if (!item.image) {
                continue;
            }
            [self.workImgs addObject:[MWPhoto photoWithImage:item.image]];
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = YES;
        browser.wantsFullScreenLayout = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        [browser setCurrentPhotoIndex:currentIndex];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:nc animated:YES completion:Nil];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
