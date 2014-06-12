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
#import "AddWithdrawViewController.h"
#import "ApprovalViewController.h"
#import "GroupManageViewController.h"
#import "GroupRevenuViewController.h"
#import "WithdrawViewController.h"
#import "UserManager.h"

@interface GroupManageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ABMGroupedTableView *tableView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, assign) float balance;

@end

@implementation GroupManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙管理";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[ABMGroupedTableView alloc] initWithFrame:CGRectMake(0, -30, WIDTH(self.view), [self contentHeightWithNavgationBar:YES
                                                                                                                           withBottomBar:NO])
                                                          style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserBalance) name:NOTIFICATION_REFRESH_COMPANY_BALANCE object:nil];
    [self getGroupBanlance];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.group.id <= 0) {
        [SVProgressHUD showErrorWithStatus:@"无法获取沙龙信息。"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"AccountMenuCellIdentifier";

    ABMGroupedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ABMGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell prepareForTableView:tableView
					withColor:nil
				  atIndexPath:indexPath];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"account"]];
            cell.label.text = @"沙龙名称";

            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
            accessoryLabel.backgroundColor = [UIColor clearColor];
            accessoryLabel.text = self.group.name;
            accessoryLabel.font = [UIFont systemFontOfSize:12];
            accessoryLabel.textColor = [UIColor colorWithHexString:@"666666"];
            accessoryLabel.textAlignment = TextAlignmentRight;
            cell.accessoryView = accessoryLabel;
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"review"]];
            cell.label.text = @"审批管理";

            FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:NAV_BAR_ICON_SIZE];
            [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777"]];
            UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[arrowIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
            arrowImg.frame = CGRectMake(0, 0, 20, 20);

            cell.accessoryView = arrowImg;
        }
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"yue"]];
            cell.label.text = @"沙龙余额";

            self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            self.balanceLabel.backgroundColor = [UIColor clearColor];
            self.balanceLabel.font = [UIFont systemFontOfSize:12];
            self.balanceLabel.textColor = [UIColor colorWithHexString:@"666666"];
            self.balanceLabel.textAlignment = TextAlignmentRight;
            self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", 0.0f];

            cell.accessoryView = self.balanceLabel;
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"income"]];
            cell.label.text = @"沙龙收益";

            FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:NAV_BAR_ICON_SIZE];
            [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777"]];
            UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[arrowIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
            arrowImg.frame = CGRectMake(0, 0, 20, 20);

            cell.accessoryView = arrowImg;
        }
        if (indexPath.row == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"withdraw"]];
            cell.label.text = @"提现记录";

            FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:NAV_BAR_ICON_SIZE];
            [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777"]];
            UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[arrowIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
            arrowImg.frame = CGRectMake(0, 0, 20, 20);

            cell.accessoryView = arrowImg;
        }
    }

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(3, 0, 296, 44);
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];

            [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"4CD964"] cornerRadius:0] forState:UIControlStateNormal];
            [loginBtn setTitle:@"提现" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(withDrawClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:loginBtn];

        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        ApprovalViewController *approvalVC = [ApprovalViewController new];
        approvalVC.group = self.group;
        [self.navigationController pushViewController:approvalVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1 && indexPath.row == 1) {
        GroupRevenuViewController *vc = [GroupRevenuViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    }

    if (indexPath.section == 1 && indexPath.row == 2) {
        WithdrawViewController *vc = [WithdrawViewController new];
        vc.groupId = self.group.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)withDrawClick
{
    AddWithdrawViewController *vc = [AddWithdrawViewController new];
    vc.balance = self.balance;
    vc.groupId = self.group.id;
    [self.navigationController pushViewController:vc animated:YES];}


#pragma mark Group Search API

- (void)getGroupBanlance
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_BALANCE, self.group.id]] andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetGroupBanlance:)];
    [request setDidFailSelector:@selector(failGetGroupBanlance:)];
    [request startAsynchronous];
}

- (void)finishGetGroupBanlance:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
    if (responseMessage) {
        if ([[responseMessage objectForKey:@"success"] intValue] <= 0) {
            [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
            return;
        }

        self.balance = [[responseMessage objectForKey:@"balance"] floatValue];
        self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.balance];
        return;
    }
}

- (void)failGetGroupBanlance:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    self.balance = 0.0;
    self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", 0.0f];
}

- (void)refreshUserBalance
{
    [self getGroupBanlance];
}

@end
