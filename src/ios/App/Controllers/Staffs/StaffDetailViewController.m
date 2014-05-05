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
#import "ChatViewController.h"
#import "CircleImageView.h"
#import "CommentsViewController.h"
#import "GroupDetailViewController.h"
#import "JOLImageSlider.h"
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
#import "DoubleCoverCell.h"

@interface StaffDetailViewController () <UIScrollViewDelegate, MWPhotoBrowserDelegate, UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *workDatasource;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *profileBackground;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
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

        self.rightNavItemTitle = @"私信";
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    if (![self checkLogin]) {
        return;
    }

    ChatViewController *chatVC= [ChatViewController new];

    User *incomingUser = [User new];
    incomingUser.id = self.staff.id;
    incomingUser.avatarUrl = self.staff.avatorUrl;
    incomingUser.nickname = self.staff.name;
    chatVC.incomingUser = incomingUser;

    chatVC.outgoingUser = [UserManager SharedInstance].userLogined;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float addressViewHeight = 50;
    float avatorSize = 60;
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableViewHeaderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     WIDTH(self.view),
                                                                     0)];
    [self.view addSubview:self.tableViewHeaderView];
    
   
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view) + addressViewHeight )];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;
    [self.tableViewHeaderView addSubview:headerView_];
    
    self.profileBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.profileBackground.image = [UIImage imageNamed:@"ProfileBackgroundDefault"];
    [headerView_ addSubview:self.profileBackground];

    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:self.profileBackground.frame];
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [headerView_ addSubview:self.imgSlider];

#pragma topbar
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.profileBackground), WIDTH(headerView_), addressViewHeight)];
    [headerView_ addSubview:self.addressView];
    
    self.addressView.backgroundColor = [UIColor whiteColor];

    UIView *tabFooterBgView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressView), WIDTH(self.addressView), 67)];
    tabFooterBgView_.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [headerView_ addSubview:tabFooterBgView_];

    UIView *addressFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressView), WIDTH(self.addressView), 7)];
    addressFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [headerView_ addSubview:addressFooterView];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, WIDTH(self.view) - avatorSize / 2, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 1;
    self.avatorImgView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.avatorImgView.userInteractionEnabled = YES;
    [self.avatorImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAvator)]];
    [headerView_ addSubview:self.avatorImgView];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(80 + 5, 0, WIDTH(self.addressView) - 10 - MaxX(self.avatorImgView)-60, 20)];
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

    float heartIconSize = 30;
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
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         MaxY(self.tableView) - kBottomBarHeight,
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

    [self getStaffDetail];

    self.tableView.contentInset = UIEdgeInsetsMake(-160, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 160 && scrollView.contentInset.top < 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }

    if (scrollView.contentOffset.y > 0) {
        self.imgSlider.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y * 0.5f, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    } else {
        self.imgSlider.frame = CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    }
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

    User *usr = [[User alloc] initWithDic:rst];
    if (usr.imgUrls.count > 0) {
        NSMutableArray *sliderArray = [NSMutableArray array];
        for (NSString *item in usr.imgUrls) {
            JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
            slideImg.image = item;
            [sliderArray addObject:slideImg];
        }

        [self.imgSlider setSlides:sliderArray];
        [self.imgSlider initialize];
        self.imgSlider.hidden = NO;
    } else {
        self.imgSlider.hidden = YES;
    }


    [self setupUIPerData];
}

- (void)failGetStaffDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"获得发型师资料失败。"];
}

- (void)setupUIPerData
{
    self.workDatasource = self.staff.works;
    [self.tableView reloadData];

    float contentPadding = 10;
    float scrollViewOffsetY = MaxY(self.addressView);
    
    if (self.staff.services.count > 0) {
        NSMutableArray *services =[NSMutableArray arrayWithArray:self.staff.services];
        [services insertObject:[Service new] atIndex:0];
        
        UIScrollView *serviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(self.addressView) + contentPadding, 300, 0)];
        [self.tableViewHeaderView addSubview:serviceScrollView];
        
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
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height -= kBottomBarHeight;
        self.tableView.frame = tableViewFrame;
    }
    
    self.staff.bio = self.staff.bio.length <= 0 ? @"这家伙什么也没留下" : self.staff.bio;
    
    UIImageView *bioImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, scrollViewOffsetY + contentPadding, 16, 16)];
    bioImg.image = [UIImage imageNamed:@"StaffDetailViewControl_Memo"];
    [self.tableViewHeaderView addSubview:bioImg];
    
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
    [self.tableViewHeaderView addSubview:bioTitleLbl];
    
    
    float bioHeight = [Util heightFortext:self.staff.bio minumHeight:40 fixedWidth:WIDTH(self.view) -  4 *contentPadding];
    UIView *bioView = [[UIView alloc] initWithFrame:CGRectMake( contentPadding,
                                                               MaxY(bioTitleLbl) + 5,
                                                               WIDTH(self.view) -  2*contentPadding,
                                                               bioHeight + 10)];
    bioView.backgroundColor = [UIColor whiteColor];
    bioView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    bioView.layer.borderWidth = 1.0;
    bioView.layer.cornerRadius = 5;
    [self.tableViewHeaderView addSubview:bioView];
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
    [self.tableViewHeaderView addSubview:commentCellView];
    
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
    
    UIImageView *workTitleImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(commentCellView) + contentPadding, 20, 20)];
    workTitleImg.image = [UIImage imageNamed:@"StaffCellI_WorkIcon"];
    [self.tableViewHeaderView addSubview:workTitleImg];
    
    UILabel *workTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(workTitleImg)+5,
                                                                      Y(workTitleImg),
                                                                      100,
                                                                      20)];
    workTitleLbl.font = [UIFont systemFontOfSize:16];
    workTitleLbl.numberOfLines = 1;
    workTitleLbl.textAlignment = TextAlignmentLeft;
    workTitleLbl.backgroundColor = [UIColor clearColor];
    workTitleLbl.textColor = [UIColor blackColor];
    workTitleLbl.text = @"作品";
    [self.tableViewHeaderView addSubview:workTitleLbl];
    
    scrollViewOffsetY = MaxY(workTitleLbl);
    CGRect headerViewFrame = self.tableViewHeaderView.frame;
    headerViewFrame.size.height = scrollViewOffsetY;

    self.tableViewHeaderView.frame = headerViewFrame;
    self.tableView.tableHeaderView  = self.tableViewHeaderView;
}

#pragma mark UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.workDatasource.count ==0){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UILabel *footerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 300, 44)];
        [footerView addSubview:footerLbl];
        footerLbl.font = [UIFont systemFontOfSize:12];
        footerLbl.numberOfLines = 0;
        footerLbl.textAlignment = TextAlignmentCenter;
        footerLbl.backgroundColor = [UIColor whiteColor];
        footerLbl.layer.borderColor  =[[UIColor colorWithHexString:@"e1e1e1"] CGColor];
        footerLbl.layer.borderWidth  =0.5;
        footerLbl.layer.cornerRadius  =5;
        footerLbl.textColor = [UIColor blackColor];
        footerLbl.text = @"暂无作品";
        return footerView;
    }else{
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
}

- (float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.workDatasource.count == 0){
        return 60;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ceil(self.workDatasource.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffCellIdentifier";
    DoubleCoverCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DoubleCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
    Work *left = [self.workDatasource objectAtIndex:2 * indexPath.row];
    Work *right;
    if(self.workDatasource.count > 2 *indexPath.row + 1){
        right = [self.workDatasource objectAtIndex:2 * indexPath.row + 1];
    }
    
    __weak typeof(self) selfDelegate = self;
    [cell setupWithLeftData:left rightData:right tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetail:work];
    }];

    return cell;
}

- (void)pushToDetail:(Work *)work
{
    WorkDetailViewController *vc = [WorkDetailViewController new];
    vc.work = work;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
