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
#import "MyClientViewController.h"
#import "MyStaffViewController.h"

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>



@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSArray *iconDatasource;
@property (nonatomic, strong) NSArray *tabTextDatasource;
@property (nonatomic, strong) ABMGroupedTableView *tableView;

@property (nonatomic, strong) UIImageView *profileBackground;
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

        self.tabTextDatasource = @[@"预约", @"订单", @"积分", @"收藏"];

        NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuList addObject:@[@"我的消息", @"我的发型师"]];
        self.datasource = menuList;

        NSMutableArray *menuIconList = [[NSMutableArray alloc] initWithCapacity:5];
        [menuIconList addObject:@[[FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE], [FAKIonIcons ios7PeopleOutlineIconWithSize:NAV_BAR_ICON_SIZE]]];
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

    self.tableView = [[ABMGroupedTableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES
                                                                                                                                         withBottomBar:YES])
                                                          style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentOffset = CGPointMake(0, 160);
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;
    self.tableView.tableHeaderView = headerView_;

    
    UIView *tabView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), tabButtonViewHeight)];
    UIView *tabContentView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WIDTH(self.view), tabButtonViewHeight - 7)];
    tabContentView_.backgroundColor = [UIColor whiteColor];
    [tabView_ addSubview:tabContentView_];

    UIView *tabFooterBgView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(tabContentView_), 7)];
    tabFooterBgView_.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [tabView_ addSubview:tabFooterBgView_];
    UIView *tabFooterView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(tabContentView_), 7)];
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
        if(i == 3){
            UIImage *img = [[FAKIonIcons ios7HeartOutlineIconWithSize:25] imageWithSize:CGSizeMake(25, 25)];
            [btn setImage:img forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MeTab%d", i + 1]] forState:UIControlStateNormal];
  }
  
  
        [tabView_ addSubview:btn];
    }
    [headerView_ addSubview:tabView_];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserInfo)
                                                 name:NOTIFICATION_USER_STATUS_CHANGE
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            FavoritesViewController *fvc = [FavoritesViewController new];
            fvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fvc animated:YES];
            break;
        }
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
    if(indexPath.section == 0 && indexPath.row == 1){
        cell.label.text = ([UserManager SharedInstance].userLogined.role == WHClient
                        || [UserManager SharedInstance].userLogined == nil) ? @"我的发型师" : @"我的客户";

    }else{
        cell.label.text = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
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
                ChatSessionListViewController *vc = [ChatSessionListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }
            case 1: {
                if ([UserManager SharedInstance].userLogined.role == WHClient){
                    MyStaffViewController *vc = [MyStaffViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    MyClientViewController *vc = [MyClientViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)refreshUserInfo
{
    [self.tableView reloadData];
}

@end
