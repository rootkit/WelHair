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

#import "Appointment.h"
#import "AppointmentPreviewViewController.h"
#import "CalendarViewController.h"
#import "CircleImageView.h"
#import "CommentsViewController.h"
#import "GroupDetailViewController.h"
#import "OpitionSelectPanel.h"
#import "StaffDetailViewController.h"
#import "StaffWorksViewController.h"
#import "Service.h"
#import "SelectOpition.h"
#import "TripleCoverCell.h"
#import "UIViewController+KNSemiModal.h"
#import "UserManager.h"
#import "WorkDetailViewController.h"
#import "MWPhotoBrowser.h"

static const float profileViewHeight = 90;

@interface StaffDetailViewController () <UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) UIImage *foImg;
@property (nonatomic, strong) ToggleButton *foBtn;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIButton *detailTabBtn;
@property (nonatomic, strong) UIButton *commentTabBtn;
@property (nonatomic, strong) SelectOpition *selectOpition;

@end

@implementation StaffDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float addressViewHeight = 50;
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    

    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,
                                                                     WIDTH(self.view),
                                                                     [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.scrollView.delegate  =self;
    [self.view addSubview:self.scrollView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  MaxY(self.scrollView) - kBottomBarHeight,
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    self.bottomView.backgroundColor =[UIColor whiteColor];
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];

    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.bottomView), 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [self.bottomView addSubview:bottomBorderView];

    self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 12, 80, 24)];
    self.submitBtn.tag = 0;
    [self.submitBtn setTitle:@"预约" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [self.submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.submitBtn];
    
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view),profileViewHeight+ addressViewHeight + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView_];
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, WIDTH(self.view), profileViewHeight)];
    
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg"];
    [headerView_ addSubview:self.headerBackgroundView];
#pragma topbar
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.headerBackgroundView), WIDTH(headerView_), addressViewHeight)];
    [headerView_ addSubview:self.addressView];
    
    self.addressView.backgroundColor = [UIColor whiteColor];
    UIView *addressFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressView), WIDTH(self.addressView), 7)];
    addressFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [headerView_ addSubview:addressFooterView];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, profileViewHeight - avatorSize / 2, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 3;
    self.avatorImgView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.avatorImgView.userInteractionEnabled = YES;
    [self.avatorImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAvator)]];
    [headerView_ addSubview:self.avatorImgView];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, WIDTH(self.addressView) - 10 - MaxX(self.avatorImgView)-60, 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor blackColor];
    self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.nameLbl.textAlignment = TextAlignmentLeft;
    [self.addressView addSubview:self.nameLbl];

    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.nameLbl), MaxY(self.nameLbl), WIDTH(self.addressView) - 10 - MaxX(self.avatorImgView) - 80, 20)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor grayColor];
    self.groupNameLbl.font = [UIFont systemFontOfSize:14];
    self.groupNameLbl.textAlignment = TextAlignmentLeft;
    [self.addressView addSubview:self.groupNameLbl];
    self.groupNameLbl.userInteractionEnabled = YES;
    [self.groupNameLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupTapped)]];

    float heartIconSize = 35;
    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:heartIconSize];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:heartIconSize];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.foBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak StaffDetailViewController *selfDelegate = self;
    [self.foBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(heartIconSize, heartIconSize)]
                                offImg:[heartIconOff imageWithSize:CGSizeMake(heartIconSize, heartIconSize)]
                    toggleEventHandler:^(BOOL isOn){
                       return [selfDelegate foClick:isOn];
                    }];
    self.foBtn.frame = CGRectMake(MaxX(self.nameLbl), 5, heartIconSize, heartIconSize);
    [self.addressView addSubview:self.foBtn];
    
//    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:15];
//    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
//    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl), Y(self.groupNameLbl)+10,20,20)];
//    locationImg.image = [locationIcon imageWithSize:CGSizeMake(15, 15)];
//    [self.addressView addSubview:locationImg];
//
//    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg), Y(locationImg),60,20)];
//    self.distanceLbl.backgroundColor = [UIColor clearColor];
//    self.distanceLbl.textColor = [UIColor grayColor];
//    self.distanceLbl.font = [UIFont systemFontOfSize:12];
//    self.distanceLbl.textAlignment = TextAlignmentLeft;
//    [self.addressView addSubview:self.distanceLbl];

    [self getStaffDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat yOffset = self.scrollView.contentOffset.y;
//    if (yOffset > 0) {
//        CGRect f = self.headerBackgroundView.frame;
//        f.origin.y = -yOffset + self.topBarOffset;
//        self.headerBackgroundView.frame = f;
//        return;
//    }
//
//    float viewWidth = 320;
//    float rate = ABS(yOffset) / profileViewHeight;
//
//    if (yOffset < 0) {
//        CGRect f = CGRectMake(-rate * viewWidth / 2, self.topBarOffset, (1 + rate) * viewWidth, (1 + rate) *profileViewHeight);
//        self.headerBackgroundView.frame = f;
//    } else {
//        CGRect f = CGRectMake(rate * viewWidth / 2, self.topBarOffset, (1 + rate) * viewWidth, (1 + rate) *profileViewHeight);
//        self.headerBackgroundView.frame = f;
//    }
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

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [MWPhoto photoWithURL:self.staff.avatorUrl];
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithURL:self.staff.avatorUrl];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}

- (void)groupTapped
{
    GroupDetailViewController *vc = [GroupDetailViewController new];
    vc.group = self.staff.group;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)foClick:(BOOL)isFo
{
    if(![self checkLogin]){
        return NO;
    }
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[UserManager SharedInstance] userLogined].id] forKey:@"CreatedBy"];
    [reqData setObject:[NSString stringWithFormat:@"%d", isFo ? 1 : 0] forKey:@"IsLike"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_LIKE, self.staff.id]]
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

- (void)workImgTapped:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if(view.tag <4){
        Work *work = self.staff.works[view.tag];
        WorkDetailViewController *detail = [WorkDetailViewController new];
        detail.work = work;
        [self.navigationController pushViewController:detail animated:YES];
    }else if(view.tag == 4){
        StaffWorksViewController *workVC = [StaffWorksViewController new];
        workVC.staffId = self.staff.id;
        [self.navigationController pushViewController:workVC animated:YES];
    }
}

- (void)submitClick
{
    OpitionSelectPanel *panel =
    [[OpitionSelectPanel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    
    [panel  setupData:self.staff
             opitions:[self buildSelectionOpition]
               cancel:^() {
                   [self.tabBarController dismissSemiModalView];
               }
               submit:^(SelectOpition *opitions) {
                   NSArray *selectedValues = opitions.selectedValues;

                   OpitionItem *itemService = (OpitionItem *)selectedValues[0];

                   Appointment *apt = [Appointment new];
                   apt.staff = self.staff;
                   apt.service = [Service new];
                   apt.service.id = itemService.id;
                   apt.service.name = itemService.title;
                   apt.service.salePrice = itemService.price;
                   apt.price = itemService.price;
                   apt.date = selectedValues[1];

                   [self.tabBarController dismissSemiModalView];

                   AppointmentPreviewViewController *aptPreviewVC = [AppointmentPreviewViewController new];
                   aptPreviewVC.appointment = apt;
                   [self.navigationController pushViewController:aptPreviewVC animated:YES];
               }];
    [self.tabBarController presentSemiView:panel withOptions:nil];
}

- (void)getSelectedOpitions:(NSArray *)array
{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"已选择"];
    for (OpitionItem *item in array) {
        [str appendFormat:@",%d", item.id];
    }
}

- (SelectOpition *)buildSelectionOpition
{
    OpitionCategory *category = [OpitionCategory new];
    category.id = 1;
    category.title = @"服务项目";
    
    NSMutableArray *items = [NSMutableArray array];
    for (Service *s in self.staff.services) {
        OpitionItem *item = [OpitionItem new];
        item.id = s.id;
        item.categoryId = category.id;
        item.title =  s.name;
        item.price = s.salePrice;
        [items addObject:item];
    }
    category.opitionItems = items;

    self.selectOpition = [SelectOpition new];
    self.selectOpition.opitionCateogries = @[category];
    self.selectOpition.selectedValues = [NSArray array];
    
    return self.selectOpition;
}

- (void)commentsTapped
{
    CommentsViewController *commVC = [CommentsViewController new];
    commVC.userId = self.staff.id;
    [self.navigationController pushViewController:commVC animated:YES];
}

- (void)getStaffDetail
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_DETAIL, self.staff.id]]
                                                          andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetStaffDetail:)];
    [request setDidFailSelector:@selector(failGetStaffDetail:)];
    [request startAsynchronous];
}

- (void)finishGetStaffDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    NSDictionary *rst = [Util objectFromJson:request.responseString];
    id companyDic = [rst objectForKey:@"Company"];
    if (companyDic == [NSNull null]) {
        return;
    }

    self.staff = [[Staff alloc] initWithDic:rst];

    self.title = self.staff.name;
    self.nameLbl.text = self.staff.name;
    self.groupNameLbl.text = self.staff.group.name;
    self.distanceLbl.text = [NSString stringWithFormat:@"%.2f 千米", self.staff.distance / 1000];
    self.foBtn.on = self.staff.isLiked;
    [self.avatorImgView setImageWithURL:self.staff.avatorUrl];

    [self setupUIPerData];
}

- (void)failGetStaffDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"获得发型师资料失败。"];
}

- (void)setupUIPerData
{
    float contentPadding = 10;
    float scrollViewOffsetY = MaxY(self.addressView);

    if (self.staff.services.count > 0) {
        NSMutableArray *services =[NSMutableArray arrayWithArray:self.staff.services];
        [services insertObject:[Service new] atIndex:0];

        UIScrollView *serviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(self.addressView) + contentPadding, 300, 0)];
        [self.scrollView addSubview:serviceScrollView];

        float serviceOffsetY = 0;
        float serviceCellHeight = 30;
        float serviceItemWidth = 300/3;

        for (int i = 0; i < services.count; i++) {
            Service *service = services[i];

            float serviceItemHeight = [Util heightFortext:service.name
                                              minumHeight:serviceCellHeight
                                               fixedWidth:serviceItemWidth];

            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceOffsetY, WIDTH(serviceScrollView), serviceItemHeight)];
            cellView.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
            cellView.layer.borderWidth = 1;
            cellView.backgroundColor = i == 0? [UIColor colorWithHexString:@"dddddd"] : [UIColor whiteColor];
            [serviceScrollView addSubview:cellView];


            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          serviceItemWidth,
                                                                          serviceItemHeight)];
            titleLbl.font = [UIFont systemFontOfSize:12];
            titleLbl.numberOfLines = 0;
            titleLbl.textAlignment = TextAlignmentCenter;
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor blackColor];
            [cellView addSubview:titleLbl];


            UILabel *originalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(titleLbl)+1,
                                                                                  0,
                                                                                  serviceItemWidth,
                                                                                  serviceItemHeight)];
            originalPriceLbl.font = [UIFont systemFontOfSize:12];
            originalPriceLbl.numberOfLines = 0;
            originalPriceLbl.textAlignment = TextAlignmentCenter;
            originalPriceLbl.backgroundColor = [UIColor clearColor];
            originalPriceLbl.textColor = [UIColor blackColor];
            [cellView addSubview:originalPriceLbl];

            UILabel *salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(originalPriceLbl)+1, 0, serviceItemWidth, serviceItemHeight)];
            salePriceLbl.font = [UIFont systemFontOfSize:12];
            salePriceLbl.numberOfLines = 0;
            salePriceLbl.textAlignment = TextAlignmentCenter;
            salePriceLbl.backgroundColor = [UIColor clearColor];
            salePriceLbl.textColor = [UIColor blackColor];
            [cellView addSubview:salePriceLbl];

            serviceOffsetY += serviceItemHeight;

            if(i == 0) {
                titleLbl.text = @"项目";
                originalPriceLbl.text = @"原价";
                salePriceLbl.text = @"折扣价";
            } else {
                titleLbl.text = service.name;
                originalPriceLbl.text = [NSString stringWithFormat:@"%.2f", service.originalPrice];
                salePriceLbl.text = [NSString stringWithFormat:@"%.2f", service.salePrice];

                UIView *deleteLine = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT(originalPriceLbl)/2, WIDTH(originalPriceLbl) - 40, 1)];
                deleteLine.backgroundColor = [UIColor lightGrayColor];
                [originalPriceLbl addSubview:deleteLine];
            }
        }

        UIView *cellSeparaterView = [[UIView alloc] initWithFrame:CGRectMake(101,
                                                                             serviceCellHeight,
                                                                             1,
                                                                             serviceOffsetY - serviceCellHeight)];
        cellSeparaterView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [serviceScrollView addSubview:cellSeparaterView];

        UIView *cellSeparaterView2 = [[UIView alloc] initWithFrame:CGRectMake(201,
                                                                              serviceCellHeight,
                                                                              1,
                                                                              serviceOffsetY - serviceCellHeight)];
        cellSeparaterView2.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [serviceScrollView addSubview:cellSeparaterView2];

        CGRect newFrame = serviceScrollView.frame;
        newFrame.size.height = serviceOffsetY;
        serviceScrollView.frame = newFrame;

        scrollViewOffsetY = MaxY(serviceScrollView);
        self.bottomView.hidden = NO;
        CGRect scrollFrame = self.scrollView.frame;
        scrollFrame.size.height -= kBottomBarHeight;
        self.scrollView.frame = scrollFrame;
    }

    
    UIImageView *workTitleImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, scrollViewOffsetY + contentPadding, 20, 20)];
    workTitleImg.image = [UIImage imageNamed:@"StaffCellI_WorkIcon"];
    [self.scrollView addSubview:workTitleImg];
    
    UILabel *workTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(workTitleImg)+5,
                                                                      Y(workTitleImg),
                                                                      scrollViewOffsetY,
                                                                      20)];
    workTitleLbl.font = [UIFont systemFontOfSize:16];
    workTitleLbl.numberOfLines = 1;
    workTitleLbl.textAlignment = TextAlignmentLeft;
    workTitleLbl.backgroundColor = [UIColor clearColor];
    workTitleLbl.textColor = [UIColor blackColor];
    workTitleLbl.text = @"作品";
    [self.scrollView addSubview:workTitleLbl];

    UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(workTitleLbl) + 5, 300, 60)];
    workView.layer.cornerRadius = 5;
    workView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:workView];
    scrollViewOffsetY = MaxY(workView);
    if (self.staff.works.count == 0) {
        
        float imgHorizontalPadding = 5;
        float imgVeritalPadding = 3;
        float imgSize = 54;

        int count = MIN(self.staff.works.count, 5);
        for (int i = 0; i < count; i++) {
            if (i < 4) {
                Work *work  =self.staff.works[i];
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
                img.userInteractionEnabled = YES;
                img.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
                img.layer.borderWidth = 1;
                img.tag = i;
                [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
                [img setImageWithURL:[NSURL URLWithString:work.imgUrlList[0]]];
                [workView addSubview:img];

            } else {
                UILabel *moreLbl = [[UILabel alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
                moreLbl.font = [UIFont systemFontOfSize:16];
                moreLbl.numberOfLines = 1;
                moreLbl.textAlignment = TextAlignmentCenter;
                moreLbl.backgroundColor = [UIColor clearColor];
                moreLbl.textColor = [UIColor blackColor];
                moreLbl.text = @"更多";
                moreLbl.tag = i;
                moreLbl.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
                moreLbl.layer.borderWidth = 1;
                moreLbl.userInteractionEnabled = YES;
                [moreLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
                [workView addSubview:moreLbl];
            }
        }
        
    }else{
        UILabel *emptyWorkLbl = [[UILabel alloc] initWithFrame:workView.bounds];
        emptyWorkLbl.font = [UIFont systemFontOfSize:16];
        emptyWorkLbl.numberOfLines = 1;
        emptyWorkLbl.textAlignment = TextAlignmentCenter;
        emptyWorkLbl.backgroundColor = [UIColor clearColor];
        emptyWorkLbl.textColor = [UIColor lightGrayColor];
        emptyWorkLbl.text = @"暂无作品";
        [workView addSubview:emptyWorkLbl];
    }

    self.staff.bio = self.staff.bio.length <= 0 ? @"这家伙什么也没留下" : self.staff.bio;

    UIImageView *bioImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, scrollViewOffsetY + contentPadding, 16, 16)];
    bioImg.image = [UIImage imageNamed:@"StaffDetailViewControl_Memo"];
    [self.scrollView addSubview:bioImg];

    UILabel *bioTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(bioImg)+5,
                                                                     Y(bioImg),
                                                                     scrollViewOffsetY,
                                                                     20)];
    bioTitleLbl.font = [UIFont systemFontOfSize:16];
    bioTitleLbl.numberOfLines = 1;
    bioTitleLbl.textAlignment = TextAlignmentLeft;
    bioTitleLbl.backgroundColor = [UIColor clearColor];
    bioTitleLbl.textColor = [UIColor blackColor];
    bioTitleLbl.text = @"备注";
    [self.scrollView addSubview:bioTitleLbl];


    float bioHeight = [Util heightFortext:self.staff.bio minumHeight:40 fixedWidth:WIDTH(self.view) -  4 *contentPadding];
    UIView *bioView = [[UIView alloc] initWithFrame:CGRectMake( contentPadding,
                                                               MaxY(bioTitleLbl) + 5,
                                                               WIDTH(self.view) -  2*contentPadding,
                                                               bioHeight + 10)];
    bioView.backgroundColor = [UIColor whiteColor];
    bioView.layer.cornerRadius = 5;
    [self.scrollView addSubview:bioView];
    UILabel *bioLbl = [[UILabel alloc] initWithFrame:CGRectMake(contentPadding,
                                                                5,
                                                                WIDTH(bioView) - 2 *contentPadding,
                                                                bioHeight)];
    [bioView addSubview:bioLbl];

    bioLbl.font = [UIFont systemFontOfSize:12];
    bioLbl.numberOfLines = 0;
    bioLbl.textAlignment = TextAlignmentLeft;
    bioLbl.backgroundColor = [UIColor clearColor];
    bioLbl.textColor = [UIColor blackColor];
    bioLbl.text = self.staff.bio;

    scrollViewOffsetY = MaxY(bioView);

    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(10, scrollViewOffsetY + 20, 300, 44)];
    commentCellView.backgroundColor = [UIColor whiteColor];
    commentCellView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    commentCellView.layer.borderWidth = 1.0;
    commentCellView.layer.cornerRadius = 5;
    [commentCellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsTapped)]];
    [self.scrollView addSubview:commentCellView];

    UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 12, 100, 20)];
    commentLbl.font = [UIFont systemFontOfSize:14];
    commentLbl.textAlignment = NSTextAlignmentLeft;
    commentLbl.backgroundColor = [UIColor clearColor];
    commentLbl.textColor = [UIColor colorWithHexString:@"333"];
    commentLbl.text = @"评论信息";
    [commentCellView addSubview:commentLbl];

    FAKIcon *commentIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"]];
    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(commentCellView) - 40, 12, 20, 20)];
    commentImgView.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [commentCellView addSubview:commentImgView];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MaxY(commentCellView) + 40);
    self.scrollView.scrollEnabled = YES;
}

@end
