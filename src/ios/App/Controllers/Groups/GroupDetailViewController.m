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
#import "GroupDetailInfoTableViewDelegate.h"
#import "GroupDetailStaffTableViewDelegate.h"
#import "UMSocial.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MWPhotoBrowser.h"
#import "StaffCell.h"
#import "Group.h"


@interface GroupDetailViewController()<MapPickViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) NSMutableArray *groupImgs;
@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) UIButton *detailTabBtn;
@property (nonatomic, strong) UIButton *staffTabBtn;
@property (nonatomic, strong) Group *groupData;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) BOOL staffTabSelected;

@end
static const   float profileViewHeight = 320;
@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙详情";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemImg  = [UIImage imageNamed:@"ShareIcon"];
    
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

    float addressViewHeight = 50;
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    
//    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH
//                                                                              (self.view), profileViewHeight)];
//    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg@2x"];
//    [self.view addSubview:self.headerBackgroundView];
    
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH(self.view),
                                                                   HEIGHT(self.view))];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:topNavView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight + addressViewHeight+ tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    
    
    
#pragma topbar
   
    
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setAutoSlide: YES];
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

    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, WIDTH(addressView) - 10 - MaxX(self.avatorImgView), 20)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor blackColor];
    self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.groupNameLbl.text = @"沙宣";
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.groupNameLbl];
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.groupNameLbl),MaxY(self.groupNameLbl), WIDTH(addressView) - 10 - MaxX(self.avatorImgView) - 100, 20)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.text = @"济南高新区";
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.addressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl), Y(self.self.addressLbl),20,20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"000"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
    locationImg.userInteractionEnabled = YES;
    [locationImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
    [addressView addSubview:locationImg];
    
    
    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),70,20)];
    self.distanceLbl.textAlignment = NSTextAlignmentLeft;
    self.distanceLbl.textColor = [UIColor grayColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:12];
    self.distanceLbl.backgroundColor = [UIColor clearColor];
    self.distanceLbl.text = @"1.45千米";
    [addressView addSubview:self.distanceLbl];

    
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(addressView), WIDTH(headerView_), tabButtonViewHeight)];
    [headerView_ addSubview:tabView];
    
    self.detailTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailTabBtn.frame = CGRectMake(20,  10, 140,30);
    [self.detailTabBtn setTitle:@"基本信息" forState:UIControlStateNormal];
    self.detailTabBtn.backgroundColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    self.detailTabBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.detailTabBtn.layer.borderWidth = 1;
    self.detailTabBtn.layer.cornerRadius = 3;
    self.detailTabBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.detailTabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.detailTabBtn.tag = 0;
    [self.detailTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [tabView addSubview:self.detailTabBtn];
    
    self.staffTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.staffTabBtn.frame = CGRectMake(MaxX(self.detailTabBtn)-1,  10, 140,30);
    self.staffTabBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.staffTabBtn.layer.borderWidth = 1;
    self.staffTabBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.staffTabBtn.layer.cornerRadius = 3;
    [self.staffTabBtn setTitle:@"设计师(100)" forState:UIControlStateNormal];
    self.staffTabBtn.backgroundColor = [UIColor whiteColor];
    [self.staffTabBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
    self.staffTabBtn.tag = 1;
    [self.staffTabBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [tabView addSubview:self.staffTabBtn];
    self.tableView.tableHeaderView = headerView_;
    self.datasource = [FakeDataHelper getFakeStaffList];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn == self.detailTabBtn){
        if(self.staffTabSelected == NO)
            return;
        self.detailTabBtn.backgroundColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self.detailTabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.staffTabBtn.backgroundColor = [UIColor whiteColor];
        [self.staffTabBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
        self.staffTabSelected = NO;
        [self.tableView reloadData];
    }else{
        if(self.staffTabSelected == YES)
            return;
        self.staffTabBtn.backgroundColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self.staffTabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.detailTabBtn.backgroundColor = [UIColor whiteColor];
        [self.detailTabBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
        self.staffTabSelected = YES;
        [self.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat yOffset   = scrollView.contentOffset.y;
    
    if (yOffset < 0) {
        CGFloat factor = ((ABS(yOffset) + 320) * 320) / profileViewHeight;
        CGRect f = CGRectMake(-(factor - 320) / 2, self.topBarOffset, factor, profileViewHeight + ABS(yOffset));
        self.headerBackgroundView.frame = f;
    } else {
        CGRect f = self.headerBackgroundView.frame;
        f.origin.y = -yOffset + self.topBarOffset;
        self.headerBackgroundView.frame = f;
    }
}

- (void)staffClick
{
    [self.navigationController pushViewController:[StaffDetailViewController new] animated:YES];
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    [self OpenImageGallery];
}


#pragma pick map delegate
- (void)didPickLocation:(CLLocation *)location
{
    self.addressLbl.text = [NSString stringWithFormat:@"la:%f, lo:%f",location.coordinate.latitude, location.coordinate.longitude];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.staffTabSelected){
        return self.datasource.count;
    }else{
        return 2;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.staffTabSelected){
        UITableViewCell * cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(indexPath.row == 0){
            cell.textLabel.text = @"地址：高新区舜华北路舜泰广场2号楼";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            float locationIconSize = 20;
            FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
            [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1f6ba7"]];
            UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,locationIconSize,locationIconSize)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = locationImgView;
            return cell;
        }else{
            cell.textLabel.text = @"电话：15666666666";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            float locationIconSize = 20;
            FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
            [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1f6ba7"]];
            UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,locationIconSize,locationIconSize)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = locationImgView;
            return cell;
        }

    }else{
        static NSString * cellIdentifier = @"StaffCellIdentifier";
        StaffCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        Staff *staff = [self.datasource objectAtIndex:indexPath.row];
        [cell setup:staff];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.staffTabSelected){
        [self staffClick];
    }else{
        if(indexPath.row == 0){
            [self mapClick];
        }
    }
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
