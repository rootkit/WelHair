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
#import "AppointmentsViewController.h"
#import "CircleImageView.h"
#import "DoubleCoverCell.h"
#import "FavoritesViewController.h"
#import "MyGroupViewController.h"
#import "MyScoreViewController.h"
#import "LoginViewController.h"
#import "OrdersViewController.h"
#import "SettingViewController.h"
#import "UserAuthorViewController.h"
#import "UserProfileViewController.h"
#import "StaffManageViewController.h"
#import "WelQRReaderViewController.h"
#import "Work.h"
#import "WorkDetailViewController.h"
#import "UserManager.h"
#import "UserViewController.h"

static const   float profileViewHeight = 80;

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray *iconDatasource;
@property (nonatomic, strong) ABMGroupedTableView *tableView;

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


        NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuList addObject:@[@"个人信息"]];
        [menuList addObject:@[@"我的收藏", @"浏览历史"]];
        [menuList addObject:@[@"积分兑换"]];
        self.datasource = menuList;

        NSMutableArray *menuIconList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuIconList addObject:@[[FAKIonIcons ios7InformationOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
        [menuIconList addObject:@[[FAKIonIcons ios7HeartOutlineIconWithSize:NAV_BAR_ICON_SIZE], [FAKIonIcons ios7BookmarksOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
        [menuIconList addObject:@[[FAKIonIcons ios7BellOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
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
    
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight)];
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg"];
    [self.view addSubview:self.headerBackgroundView];
    
    
    self.tableView = [[ABMGroupedTableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:YES])
                                                          style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), profileViewHeight + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView_;
    
    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 15, avatorSize, avatorSize)];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
    [profileIconView_ addSubview:self.avatorImgView];
    
    UIButton *overlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayBtn.frame = self.avatorImgView.frame;
    [overlayBtn addTarget:self action:@selector(avatorClicked) forControlEvents:UIControlEventTouchUpInside];
    [profileIconView_ addSubview:overlayBtn];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 20, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.text = @"美女";
    self.nameLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.nameLbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 40, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor whiteColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.text = @"济南高新区";
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.addressLbl];
    
    UIView *tabView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(profileIconView_), WIDTH(profileIconView_), tabButtonViewHeight)];
    UIImageView *tabBg = [[UIImageView alloc] initWithFrame:tabView_.bounds];
    tabBg.image = [UIImage imageNamed:@"UserViewControl_TabBg"];
    [tabView_ addSubview:tabBg];
    
    int tabCount = 4;
    float tabWidth = WIDTH(tabView_)/tabCount;
    for (int i = 0; i < tabCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, tabButtonViewHeight)];
        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i;
        [tabView_ addSubview:btn];
    }
    [headerView_ addSubview:tabView_];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToGroupPanel) name:NOTIFICATION_USER_CREATE_GROUP_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) navigateToGroupPanel
{
    if([FakeDataHelper isUserGroupAdmin]){
        [self.navigationController popToViewController:self animated:NO];
        MyGroupViewController *myGroupVc = [MyGroupViewController new];
        myGroupVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myGroupVc animated:NO];
    }else if([FakeDataHelper isUserGroupStaff]){
        [self.navigationController popToViewController:self animated:NO];
        StaffManageViewController *vc = [StaffManageViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset   = self.tableView.contentOffset.y;
    
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

- (void)avatorClicked
{
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
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:{
            AppointmentsViewController *vc = [AppointmentsViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            //my coupon list
        }
        case 2:{
            MyScoreViewController *vc = [MyScoreViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:{
            if(![UserManager SharedInstance].userLogined)
            {
                [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
                return;
            }
            if([UserManager SharedInstance].userLogined.role == WHManager){
                MyGroupViewController *vc = [MyGroupViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([UserManager SharedInstance].userLogined.role == WHStaff) {
                StaffManageViewController *vc = [StaffManageViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:NO];
            } else {
                UserAuthorViewController *vc = [UserAuthorViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
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

@end
