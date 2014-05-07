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

@interface GroupDetailViewController()<MapPickViewDelegate,UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *groupView;
@property (nonatomic, strong) NSMutableArray *groupImgs;
@property (nonatomic, strong) MWPhotoBrowser *groupImagesBrowser;

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
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg  =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick
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

    [self.tableView addInfiniteScrollingWithActionHandler:^{
    }];
    self.tableView.showsInfiniteScrolling = NO;
    
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];

#pragma topbar
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.headerView addSubview:self.imgSlider];

#pragma action section
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.imgSlider), 300, 35)];
    actionView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    actionView.layer.borderWidth = 1;
    actionView.layer.cornerRadius = 5;
    actionView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:actionView];
    
    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak GroupDetailViewController *selfDelegate = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn){
                           return [selfDelegate favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake((150 - 25)/2, 5, 25, 25);
    [actionView addSubview:self.heartBtn];
    
    UIView *actionLinerView = [[UIView alloc] initWithFrame:CGRectMake(150, 5, 1, 25)];
    actionLinerView.backgroundColor = [UIColor lightGrayColor];
    [actionView addSubview:actionLinerView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FAKIcon *shareIcon = [FAKIonIcons androidShareIconWithSize:25];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    [shareBtn setImage:[shareIcon imageWithSize:CGSizeMake(25, 25)] forState:UIControlStateNormal ];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchDown];
    shareBtn.frame = CGRectMake(150 + (150 -25)/2, 7, 20, 20);
    [actionView addSubview:shareBtn];
    
#pragma staffView
    self.groupView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(actionView) + 10, 300, 90)];
    self.groupView.backgroundColor = [UIColor whiteColor];
    self.groupView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    self.groupView.layer.borderWidth = 1;
    self.groupView.layer.cornerRadius = 5;
    [self.headerView addSubview:self.groupView];
    
    UILabel *staffTitleLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100,20)];
    staffTitleLbl.font = [UIFont systemFontOfSize:14];
    staffTitleLbl.textAlignment = TextAlignmentLeft;
    staffTitleLbl.backgroundColor = [UIColor clearColor];
    staffTitleLbl.textColor = [UIColor blackColor];
    staffTitleLbl.text = @"发型师";
    [self.groupView addSubview:staffTitleLbl];
    
    UIView *staffLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(staffTitleLbl) +5, WIDTH(self.groupView), 1)];
    staffLinerView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [self.groupView addSubview:staffLinerView];
    
    self.avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, MaxY(staffLinerView) + 5, 50, 50)];
    [self.groupView addSubview:self.avatorImgView];
    
    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView)+10,Y(self.avatorImgView), 150, 50)];
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;
    self.groupNameLbl.textColor = [UIColor blackColor];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.font = [UIFont systemFontOfSize:14];
    [self.groupView addSubview:self.groupNameLbl];
    
#pragma tabview
    UIColor *tabViewColor =[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.groupView) + 10, WIDTH(self.view) - 20, 30)];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.layer.borderColor = [tabViewColor CGColor];
    tabView.layer.borderWidth = 1;
    tabView.layer.cornerRadius = 5;
    [self.headerView addSubview:tabView];

    float tabButtonWidth = 100;
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
    [self.headerView addSubview:detainInfoView];
    
    UIView *addressCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    addressCellView.backgroundColor = [UIColor clearColor];
    [detainInfoView addSubview:addressCellView];
    [addressCellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClick)]];
    
    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    addressTitleLbl.textAlignment = TextAlignmentLeft;
    addressTitleLbl.textColor = [UIColor grayColor];
    addressTitleLbl.font = [UIFont systemFontOfSize:12];
    addressTitleLbl.backgroundColor = [UIColor clearColor];
    addressTitleLbl.text = @"地址:";
    [addressCellView addSubview:addressTitleLbl];

    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(addressTitleLbl),Y(addressTitleLbl), 190, 44)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.textAlignment = TextAlignmentLeft;
    [addressCellView addSubview:self.addressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl) + 20, 12, 20, 20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:30];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(30, 30)];
    locationImg.userInteractionEnabled = YES;
    [addressCellView addSubview:locationImg];
    
    UIView *tabContentLiner = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(addressCellView) -1, WIDTH(tabView), .5)];
    tabContentLiner.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [detainInfoView addSubview:tabContentLiner];
    
    UIView *phoneCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 300, 44)];
    phoneCellView.backgroundColor = [UIColor clearColor];
    [detainInfoView addSubview:phoneCellView];
    [phoneCellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneClick)]];
    
    UILabel *photoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    photoTitle.textAlignment = TextAlignmentLeft;
    photoTitle.textColor = [UIColor grayColor];
    photoTitle.font = [UIFont systemFontOfSize:12];
    photoTitle.backgroundColor = [UIColor clearColor];
    photoTitle.text = @"电话:";
    [phoneCellView addSubview:photoTitle];
    
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(photoTitle), Y(photoTitle), 190, 44)];
    self.phoneLbl.backgroundColor = [UIColor clearColor];
    self.phoneLbl.textColor = [UIColor grayColor];
    self.phoneLbl.font = [UIFont systemFontOfSize:12];
    self.phoneLbl.textAlignment = TextAlignmentLeft;
    [phoneCellView addSubview:self.phoneLbl];
    
    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.phoneLbl) + 20, 12, 20, 20)];
    FAKIcon *phoneIcon = [FAKIonIcons ios7TelephoneIconWithSize:30];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    phoneImg.image = [phoneIcon imageWithSize:CGSizeMake(30, 30)];
    phoneImg.userInteractionEnabled = YES;
    [phoneCellView addSubview:phoneImg];
    
    self.headerView.frame = CGRectMake(0, 0, WIDTH(self.view), MaxY(detainInfoView));
    self.tableView.tableHeaderView  = self.headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.group.name;

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
    MapViewController *vc = [MapViewController new];
    vc.modelInfo = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)phoneClick
{
    [Util phoneCall:self.phoneLbl.text];
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

- (void)openAvator
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

- (void)OpenImageGallery
{
    self.groupImagesBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.groupImagesBrowser.displayActionButton = NO;
    self.groupImagesBrowser.displayNavArrows = YES;
    self.groupImagesBrowser.displaySelectionButtons = NO;
    self.groupImagesBrowser.alwaysShowControls = NO;
    self.groupImagesBrowser.wantsFullScreenLayout = YES;
    self.groupImagesBrowser.zoomPhotosToFill = YES;
    self.groupImagesBrowser.enableGrid = NO;
    self.groupImagesBrowser.startOnGrid = NO;
    [self.groupImagesBrowser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.groupImagesBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nc animated:YES completion:Nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    if(photoBrowser == self.groupImagesBrowser){
        return self.groupImgs.count;
    }else{
        return 1;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if(photoBrowser == self.groupImagesBrowser){
        if (index < self.groupImgs.count) {
            return [self.groupImgs objectAtIndex:index];
        }
        return nil;
    }else{
        return [MWPhoto photoWithURL:[NSURL URLWithString:self.group.logoUrl]];
    }
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    if(photoBrowser == self.groupImagesBrowser){
        MWPhoto *photo = [self.groupImgs objectAtIndex:index];
        MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
        return captionView ;
    }else{
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.group.logoUrl]];
        MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
        return captionView ;
    }


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
#pragma mark UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 20)];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIden";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
