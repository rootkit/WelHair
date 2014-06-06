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
#import "Deposit.h"
#import "RechargeViewController.h"
#import "UserManager.h"

@interface RechargeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ABMGroupedTableView *tableView;
@property (nonatomic, strong) UITextField *amountTxt;

@end

@implementation RechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"账户充值";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
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

    [self.tableView.panGestureRecognizer addTarget:self action:@selector(panHandler:)];

    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
        return 1;
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
            [cell.imageView setImage:[UIImage imageNamed:@"yue"]];
            cell.label.text = @"账户余额";

            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            accessoryLabel.backgroundColor = [UIColor clearColor];
            accessoryLabel.text = self.deposit;
            accessoryLabel.font = [UIFont systemFontOfSize:12];
            accessoryLabel.textColor = [UIColor colorWithHexString:@"666666"];
            accessoryLabel.textAlignment = TextAlignmentRight;
            cell.accessoryView = accessoryLabel;
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"jine"]];
            cell.label.text = @"充值金额";

            self.amountTxt =  [UITextField plainTextField:CGRectMake(120,
                                                                     2,
                                                                     160,
                                                                     40)
                                              leftPadding:5];
            self.amountTxt.font = [UIFont systemFontOfSize:14];
            self.amountTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.amountTxt.backgroundColor = [UIColor clearColor];
            self.amountTxt.text = @"100.00";
            self.amountTxt.textAlignment = TextAlignmentRight;
            self.amountTxt.keyboardType = UIKeyboardTypeDecimalPad;
            [cell addSubview:self.amountTxt];
            [self.amountTxt becomeFirstResponder];
        }
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"alipay"]];
            cell.label.text = @"支付宝";

            FAKIcon *arrowIcon = [FAKIonIcons ios7CheckmarkOutlineIconWithSize:NAV_BAR_ICON_SIZE];
            [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4CD964"]];
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
            [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:loginBtn];

        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)rechargeClick
{
    if ([self.amountTxt.text floatValue] <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请输入正确的金额。" duration:1];
        return;
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.amountTxt.text forKey:@"Amount"];
    [reqData setObject:@(WHDepositStatusSuccess) forKey:@"Status"];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_DEPOSIT, [UserManager SharedInstance].userLogined.id]]
                                                                andData:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createDepositFinish:)];
    [request setDidFailSelector:@selector(createDepositFail:)];
    [request startAsynchronous];
}

- (void)createDepositFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"deposit"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_USER_BALANCE object:nil];
            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"充值失败，请重试！"];
}

- (void)createDepositFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"充值失败，请重试！"];
}

- (void)panHandler:(UIPanGestureRecognizer *)pan
{
    [self.amountTxt resignFirstResponder];
}

@end
