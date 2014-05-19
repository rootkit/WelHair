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

#import "ABMGroupedTableView.h"
#import "ABMGroupedTableViewCell.h"
#import "AddressListViewController.h"
#import "AppointmentsViewController.h"
#import "ChatSessionListViewController.h"
#import "CircleImageView.h"
#import "FavoritesViewController.h"
#import "MyGroupViewController.h"
#import "MyScoreViewController.h"
#import "JOLImageSlider.h"
#import "LoginViewController.h"
#import "MWPhotoBrowser.h"
#import "SettingViewController.h"
#import "UserAuthorViewController.h"
#import "UserProfileViewController.h"
#import "StaffManageViewController.h"
#import "WelQRReaderViewController.h"
#import "Work.h"
#import "WorkDetailViewController.h"
#import "UserManager.h"
#import "UserViewController.h"
#import "OrderListViewController.h"
#import "FeedbackViewController.h"
#define  SettingMyGroup      @"我的沙龙"
#define  SettingJoinGroup    @"加入沙龙"
#define  SettingGroupPending      @"审核中"
#define  SettingMyAddress    @"收货地址"
#define  SettingMyScore    @"积分兑换"
#define  SettingFeedback    @"意见反馈"
#define  SettingCheckVersion    @"版本更新"
#define  SettingRate    @"给我们打分"

static const float profileViewHeight = 90;

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray *iconDatasource;
@property (nonatomic, strong) NSArray *tabTextDatasource;
@property (nonatomic, strong) ABMGroupedTableView *tableView;

@property (nonatomic, strong) UIImageView *profileBackground;
@property (nonatomic, strong) JOLImageSlider *imgSlider;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)refreshTableView
{
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
     NSMutableArray *menuIconList = [[NSMutableArray alloc] initWithCapacity:5];
    User *user = [UserManager SharedInstance].userLogined;
    if (user == nil) {
        
    } else if (user.role != WHClient && (user.approveStatus == WHApproveStatusUnknow || user.approveStatus == WHApproveStatusInvalid )) {
        [menuList addObject:@[SettingJoinGroup]];
        [menuIconList addObject:@[[FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
    } else if (user.approveStatus == WHApproveStatusRequested && user.groupId > 0) {
        [menuList addObject:@[SettingGroupPending]];
        [menuIconList addObject:@[[FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
    } else if (user.role == WHStaff || user.role == WHManager) {
        [menuList addObject:@[SettingMyGroup]];
        [menuIconList addObject:@[[FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
    }
    
    [menuList addObject:@[SettingMyAddress, SettingMyScore]];
    [menuList addObject:@[SettingFeedback, SettingCheckVersion, SettingRate]];
    self.datasource = menuList;

    [menuIconList addObject:@[[FAKIonIcons ios7FilingOutlineIconWithSize:NAV_BAR_ICON_SIZE], [FAKIonIcons ios7BookmarksOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
    [menuIconList addObject:@[[FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE],
                              [FAKIonIcons ios7RefreshEmptyIconWithSize:NAV_BAR_ICON_SIZE],
                              [FAKIonIcons ios7StarOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
    self.iconDatasource = menuIconList;
    [self.tableView reloadData];
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadView
{
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo)
                                                 name:NOTIFICATION_USER_STATUS_CHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo)
                                                 name:NOTIFICATION_USER_PROFILE_CHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(navigateToGroupPanel)
                                                 name:NOTIFICATION_USER_CREATE_GROUP_SUCCESS
                                               object:nil];
    
    float avatorSize = 50;
    
    self.tableView = [[ABMGroupedTableView alloc] initWithFrame:CGRectMake(0,
                                                                           self.topBarOffset,
                                                                           WIDTH(self.view),
                                                                           [self contentHeightWithNavgationBar:YES  withBottomBar:NO]) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentOffset = CGPointMake(0, 160);
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;
    self.tableView.tableHeaderView = headerView_;
    
    self.profileBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.profileBackground.image = [UIImage imageNamed:@"ProfileBackgroundDefault"];
    [headerView_ addSubview:self.profileBackground];
    
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:self.profileBackground.frame];
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [headerView_ addSubview:self.imgSlider];
    
    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 320 - profileViewHeight, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 20, avatorSize, avatorSize)];
    self.avatorImgView.image = [UIImage imageNamed:DefaultAvatorImage];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 1;
    [profileIconView_ addSubview:self.avatorImgView];
    
    UIButton *overlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayBtn.frame = self.avatorImgView.frame;
    [overlayBtn addTarget:self action:@selector(avatorClicked) forControlEvents:UIControlEventTouchUpInside];
    [profileIconView_ addSubview:overlayBtn];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 25, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.nameLbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 45, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor whiteColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.addressLbl];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 10, 35, 80, 24)];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [self.loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [profileIconView_ addSubview:self.loginButton];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-160, 0, 0, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)navigateToGroupPanel
{
    [self.navigationController popToViewController:self animated:NO];
    [self getStaffDetail];
//    if([UserManager SharedInstance].userLogined.role == WHManager){
//        MyGroupViewController *myGroupVc = [MyGroupViewController new];
//        myGroupVc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:myGroupVc animated:NO];
//    } else if ([UserManager SharedInstance].userLogined.role == WHStaff) {
//        StaffManageViewController *vc = [StaffManageViewController new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:NO];
//    } else {
        [SVProgressHUD showErrorWithStatus:@"正在审核中，请耐心等待。" duration:1];
//    }
}

- (void)avatorClicked
{
    if([self checkLogin]){
        UserProfileViewController *vc = [UserProfileViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Album", nil), nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController
                                                animated:YES
                                              completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Album", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatorImgView.image  = pickedImg;
}

- (void)getStaffDetail
{
    [SVProgressHUD show];
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_DETAIL, [UserManager SharedInstance].userLogined.id]]
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
    User *usr = [[User alloc] initWithDic:rst];
    
    id companyDic = [rst objectForKey:@"Company"];
    if (companyDic == [NSNull null]) {
        companyDic = nil;
    }
    self.addressLbl.text = [(NSDictionary *)companyDic objectForKey:@"Address"];
    [self.avatorImgView setImageWithURL:usr.avatarUrl  placeholderImage:[UIImage imageNamed:DefaultAvatorImage]];
    self.nameLbl.text = usr.nickname;
    
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
    
    [UserManager SharedInstance].userLogined = usr;
    [self refreshTableView];
}

- (void)failGetStaffDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}

- (void)getUserDetail
{
    [SVProgressHUD show];
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_DETAIL, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:nil];
    
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetUserDetail:)];
    [request setDidFailSelector:@selector(failGetUserDetail:)];
    [request startAsynchronous];
}

- (void)finishGetUserDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if ([rst objectForKey:@"user"]) {
        [UserManager SharedInstance].userLogined = [[User alloc] initWithDic:[rst objectForKey:@"user"]];
    }
    
    User *usr = [UserManager SharedInstance].userLogined;
    
    [self.avatorImgView setImageWithURL:usr.avatarUrl placeholderImage:[UIImage imageNamed:DefaultAvatorImage]];
    self.nameLbl.text = usr.nickname;
    
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
    [self refreshTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 160 && scrollView.contentInset.top < 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (scrollView.contentOffset.y > 0) {
        self.imgSlider.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y * 0.5f, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    } else {
        self.imgSlider.frame = CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    }
}

- (void)failGetUserDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}

- (UIView *)tableView:(ABMGroupedTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return [tableView tableView:tableView viewForHeaderInSection:section withTitle:@""];
}

- (CGFloat)tableView:(ABMGroupedTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return [tableView tableView:tableView heightForHeaderInSection:section];
}


- (CGFloat)tableView:(ABMGroupedTableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([UserManager SharedInstance].userLogined && section == self.datasource.count -1){
        return 90;
    }
	return [tableView tableView:tableView heightForFooterInSection:section];
}

- (UIView *)tableView:(ABMGroupedTableView *)tableView viewForFooterInSection:(NSInteger)section
{
     if([UserManager SharedInstance].userLogined && section == self.datasource.count -1){
         UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 90)];
         view.backgroundColor = [UIColor clearColor];
         UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         logoutBtn.frame = CGRectMake(40, 20, WIDTH(self.view) - 80,40);
         [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
         logoutBtn.backgroundColor = [UIColor colorWithHexString:@"e4393c"];
         [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
         [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
         [view addSubview:logoutBtn];
         return view;
     }else{
         return [tableView tableView:tableView viewForFooterInSection:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[self.datasource objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"MeMenuCellIdentifier";
    
    ABMGroupedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ABMGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell prepareForTableView:tableView
					withColor:nil
				  atIndexPath:indexPath];
    
    
    FAKIcon *itemIcon = [[self.iconDatasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [itemIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"]];
    [cell.imageView setImage:[itemIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
    
    cell.label.text = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![self checkLogin]){
        return;
    }
    NSString *title = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([title isEqual:SettingJoinGroup]){
        UserAuthorViewController *vc = [UserAuthorViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqual:SettingGroupPending]){
        [self getStaffDetail];
        if ([UserManager SharedInstance].userLogined.approveStatus == WHApproveStatusRequested) {
            [SVProgressHUD showErrorWithStatus:@"正在审核中，请耐心等待。" duration:1];
            [self getStaffDetail];
            return;
        }
    }else if([title isEqual:SettingMyGroup]){
        if([UserManager SharedInstance].userLogined.role == WHManager){
            MyGroupViewController *vc = [MyGroupViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([UserManager SharedInstance].userLogined.role == WHStaff) {
            StaffManageViewController *vc = [StaffManageViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if([title isEqual:SettingMyAddress]){
        AddressListViewController *vc = [AddressListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqual:SettingMyScore]){
         [SVProgressHUD showSuccessWithStatus:@"敬请期待"];
    }else if ([title isEqual:SettingFeedback]){
        [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
    }else if ([title isEqual:SettingCheckVersion]){
        [SVProgressHUD showSuccessWithStatus:@"您已经使用的是最新版本" duration:1];
    }else if ([title isEqual:SettingRate]){
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreRateLink]];
    }
}

- (void)loginClick
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]]
                                            animated:YES
                                          completion:nil];
}

- (void)refreshUserInfo
{
    User *userLogined = [[UserManager SharedInstance] userLogined];
    self.loginButton.hidden = userLogined != nil;
    self.nameLbl.hidden = userLogined == nil;
    self.addressLbl.hidden = userLogined == nil || userLogined.role == WHClient;
    
    if (userLogined) {
        if (userLogined.role == WHStaff || userLogined.role == WHManager) {
            [self getStaffDetail];
        } else {
            [self getUserDetail];
        }
    }else{
        self.avatorImgView.image = [UIImage imageNamed:DefaultAvatorImage];
        self.nameLbl.text = nil;
        self.imgSlider.hidden = YES;
        [self refreshTableView];
    }
}

- (void)logout
{
    int userId = [ UserManager SharedInstance].userLogined.id;
    [SVProgressHUD showSuccessWithStatus:@"注销成功" duration:1];
    [[UserManager SharedInstance] signout];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_STATUS_CHANGE object:@(userId)];
}

@end
