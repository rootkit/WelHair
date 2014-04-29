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
#import "DoubleCoverCell.h"
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

#define  DefaultAvatorImage @"AvatarDefault.jpg"
static const float profileViewHeight = 90;

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray *iconDatasource;
@property (nonatomic, strong) NSArray *tabTextDatasource;
@property (nonatomic, strong) ABMGroupedTableView *tableView;

@property (nonatomic, strong) JOLImageSlider *imgSlider;

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"UserViewController.Title", nil);
        
        FAKIcon *rightIcon = [FAKIonIcons ios7GearOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.tabTextDatasource = @[@"预约", @"订单", @"积分", @"沙龙"];

        NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuList addObject:@[@"个人信息", @"收货地址"]];
        [menuList addObject:@[@"我的私信"]];
        [menuList addObject:@[@"我的收藏", @"积分兑换"]];
        self.datasource = menuList;

        NSMutableArray *menuIconList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuIconList addObject:@[[FAKIonIcons ios7InformationOutlineIconWithSize:NAV_BAR_ICON_SIZE], [FAKIonIcons ios7FilingOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
        [menuIconList addObject:@[[FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
        [menuIconList addObject:@[[FAKIonIcons ios7HeartOutlineIconWithSize:NAV_BAR_ICON_SIZE], [FAKIonIcons ios7BookmarksOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
        self.iconDatasource = menuIconList;
    }
    return self;
}

- (void) rightNavItemClick
{
    SettingViewController *vc = [SettingViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadView
{
    [super loadView];
    
    float tabButtonViewHeight = 56;
    float avatorSize = 50;


    self.tableView = [[ABMGroupedTableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES
                                                                                                                                         withBottomBar:YES])
                                                          style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view) + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;
    self.tableView.tableHeaderView = headerView_;

    UIImageView *profileBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    profileBackground.image = [UIImage imageNamed:@"ProfileBackgroundDefault"];
    [headerView_ addSubview:profileBackground];

    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:profileBackground.frame];
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
    
    UIView *tabView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(profileIconView_), WIDTH(profileIconView_), tabButtonViewHeight)];
    UIView *tabContentView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(profileIconView_), tabButtonViewHeight - 7)];
    tabContentView_.backgroundColor = [UIColor whiteColor];
    [tabView_ addSubview:tabContentView_];

    UIView *tabFooterBgView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(profileIconView_), 7)];
    tabFooterBgView_.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [tabView_ addSubview:tabFooterBgView_];
    UIView *tabFooterView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(profileIconView_), 7)];
    tabFooterView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [tabView_ addSubview:tabFooterView_];
    
    int tabCount = 4;
    float tabWidth = WIDTH(tabView_) / tabCount;
    for (int i = 0; i < tabCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, tabButtonViewHeight)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = TextAlignmentCenter;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, tabWidth / 2 - 11, tabButtonViewHeight - 32 , 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(20, -18, 0, 0);

        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[self.tabTextDatasource objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MeTab%d", i + 1]] forState:UIControlStateNormal];
        [tabView_ addSubview:btn];
    }
    [headerView_ addSubview:tabView_];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(navigateToGroupPanel)
                                                 name:NOTIFICATION_USER_CREATE_GROUP_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo)
                                                 name:NOTIFICATION_USER_STATUS_CHANGE
                                               object:nil];
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
    if([UserManager SharedInstance].userLogined.role == WHManager){
        MyGroupViewController *myGroupVc = [MyGroupViewController new];
        myGroupVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myGroupVc animated:NO];
    } else if ([UserManager SharedInstance].userLogined.role == WHStaff) {
        StaffManageViewController *vc = [StaffManageViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        [SVProgressHUD showErrorWithStatus:@"正在审核中，请耐心等待。" duration:1];
    }
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

- (void) tabClick:(id)sender
{
    if(![self checkLogin]){
        return;
    }

    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0: {
            AppointmentsViewController *vc = [AppointmentsViewController new];
            vc.userId = [[UserManager SharedInstance] userLogined].id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 1: {
            OrderListViewController *vc = [OrderListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 2: {
            MyScoreViewController *vc = [MyScoreViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 3: {
            [self getStaffDetail];
            if ([UserManager SharedInstance].userLogined.isApproving) {
                [SVProgressHUD showErrorWithStatus:@"正在审核中，请耐心等待。" duration:1];
                [self getStaffDetail];
                return;
            }

            if([UserManager SharedInstance].userLogined.role == WHManager){
                MyGroupViewController *vc = [MyGroupViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([UserManager SharedInstance].userLogined.role == WHStaff) {
                StaffManageViewController *vc = [StaffManageViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                UserAuthorViewController *vc = [UserAuthorViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

            break;
        }
        default:
            break;
    }
            
}

- (void)getStaffDetail
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_STAFFS_DETAIL, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:nil];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetStaffDetail:)];
    [request setDidFailSelector:@selector(failGetStaffDetail:)];
    [request startAsynchronous];
}

- (void)finishGetStaffDetail:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    id companyDic = [rst objectForKey:@"Company"];
    if (companyDic == [NSNull null]) {
        return;
    }

    self.addressLbl.text = [(NSDictionary *)companyDic objectForKey:@"Address"];

    User *usr = [[User alloc] initWithDic:rst];

    [self.avatorImgView setImageWithURL:usr.avatarUrl];
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

    if ([[rst objectForKey:@"IsApproved"] isEqualToString:@"0"] || [[(NSDictionary *)companyDic objectForKey:@"Status"] intValue] == Requested) {
        usr.isApproving = true;
        [UserManager SharedInstance].userLogined = usr;
        
        return;
    }

    if ([[rst objectForKey:@"IsApproved"] isEqualToString:@"1"] && [[(NSDictionary *)companyDic objectForKey:@"Status"] intValue] == Valid) {
        usr.isApproving = false;
        usr.role = [[rst objectForKey:@"Role"] intValue];
        [UserManager SharedInstance].userLogined = usr;
    }

}

- (void)failGetStaffDetail:(ASIHTTPRequest *)request
{
}

- (void)getUserDetail
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_DETAIL, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:nil];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetUserDetail:)];
    [request setDidFailSelector:@selector(failGetUserDetail:)];
    [request startAsynchronous];
}

- (void)finishGetUserDetail:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if ([rst objectForKey:@"user"]) {
        [UserManager SharedInstance].userLogined = [[User alloc] initWithDic:[rst objectForKey:@"user"]];
    }

    User *usr = [UserManager SharedInstance].userLogined;

    [self.avatorImgView setImageWithURL:usr.avatarUrl];
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
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        self.imgSlider.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y * 0.5f, WIDTH(self.view), WIDTH(self.view));
    } else {
        self.imgSlider.frame = CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view));
    }
}

- (void)failGetUserDetail:(ASIHTTPRequest *)request
{
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

- (UIView *)tableView:(ABMGroupedTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [tableView tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(ABMGroupedTableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return [tableView tableView:tableView heightForFooterInSection:section];
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

    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UserProfileViewController *vc = [UserProfileViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }
            case 1: {
                AddressListViewController *vc = [AddressListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }
            default: {
                break;
            }
        }


    }

    if(indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                ChatSessionListViewController *vc = [ChatSessionListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }
            default: {
                break;
            }
        }
        
        
    }

    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                FavoritesViewController *fvc = [FavoritesViewController new];
                fvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fvc animated:YES];

                break;
            }
            case 1: {
                [SVProgressHUD showSuccessWithStatus:@"敬请期待"];
                break;
            }
            default: {
                break;
            }
        }
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
    }
}

@end
