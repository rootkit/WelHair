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
#import "UserManager.h"


@interface AddWithdrawViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ABMGroupedTableView *tableView;
@property (nonatomic, strong) UITextField *amountTxt;
@property (nonatomic, strong) UITextField *bankText;
@property (nonatomic, strong) UITextField *openAccountBankText;
@property (nonatomic, strong) UITextField *accountNoText;
@property (nonatomic, strong) UITextField *accountNameText;

@end

@implementation AddWithdrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"提现申请";

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
        return 4;
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
            cell.label.text = @"当前余额";

            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            accessoryLabel.backgroundColor = [UIColor clearColor];
            accessoryLabel.text = [NSString stringWithFormat:@"￥%.2f", self.balance];
            accessoryLabel.font = [UIFont systemFontOfSize:12];
            accessoryLabel.textColor = [UIColor colorWithHexString:@"666666"];
            accessoryLabel.textAlignment = TextAlignmentRight;
            cell.accessoryView = accessoryLabel;
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"jine"]];
            cell.label.text = @"提现金额";

            self.amountTxt =  [UITextField plainTextField:CGRectMake(120,
                                                                     2,
                                                                     160,
                                                                     40)
                                              leftPadding:5];
            self.amountTxt.font = [UIFont systemFontOfSize:14];
            self.amountTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.amountTxt.backgroundColor = [UIColor clearColor];
            self.amountTxt.placeholder = @"0.00";
            self.amountTxt.textAlignment = TextAlignmentRight;
            self.amountTxt.keyboardType = UIKeyboardTypeDecimalPad;
            [cell addSubview:self.amountTxt];
            [self.amountTxt becomeFirstResponder];
        }
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"alipay"]];
            cell.label.text = @"银行名称";

            self.bankText =  [UITextField plainTextField:CGRectMake(120,
                                                                               2,
                                                                               160,
                                                                               40)
                                                        leftPadding:5];
            self.bankText.font = [UIFont systemFontOfSize:14];
            self.bankText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.bankText.backgroundColor = [UIColor clearColor];
            self.bankText.placeholder = @"银行的名称";
            self.bankText.textAlignment = TextAlignmentRight;
            [cell addSubview:self.bankText];
        }
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"opencard"]];
            cell.label.text = @"开户行";

            self.openAccountBankText =  [UITextField plainTextField:CGRectMake(120,
                                                                     2,
                                                                     160,
                                                                     40)
                                              leftPadding:5];
            self.openAccountBankText.font = [UIFont systemFontOfSize:14];
            self.openAccountBankText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.openAccountBankText.backgroundColor = [UIColor clearColor];
            self.openAccountBankText.placeholder = @"开户行的名称";
            self.openAccountBankText.textAlignment = TextAlignmentRight;
            [cell addSubview:self.openAccountBankText];
        }
        if (indexPath.row == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"bankcard"]];
            cell.label.text = @"银行卡号";

            self.accountNoText =  [UITextField plainTextField:CGRectMake(120,
                                                                               2,
                                                                               160,
                                                                               40)
                                                        leftPadding:5];
            self.accountNoText.font = [UIFont systemFontOfSize:14];
            self.accountNoText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.accountNoText.backgroundColor = [UIColor clearColor];
            self.accountNoText.placeholder = @"银行卡号";
            self.accountNoText.textAlignment = TextAlignmentRight;
            [cell addSubview:self.accountNoText];
        }
        if (indexPath.row == 3) {
            [cell.imageView setImage:[UIImage imageNamed:@"bankaccount"]];
            cell.label.text = @"持卡人";

            self.accountNameText =  [UITextField plainTextField:CGRectMake(120,
                                                                         2,
                                                                         160,
                                                                         40)
                                                  leftPadding:5];
            self.accountNameText.font = [UIFont systemFontOfSize:14];
            self.accountNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.accountNameText.backgroundColor = [UIColor clearColor];
            self.accountNameText.placeholder = @"持卡人姓名";
            self.accountNameText.textAlignment = TextAlignmentRight;
            [cell addSubview:self.accountNameText];
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
            [loginBtn addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:loginBtn];

        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)withdrawClick
{
    if ([self.amountTxt.text floatValue] <= 0 || [self.amountTxt.text floatValue] > self.balance) {
        [SVProgressHUD showSuccessWithStatus:@"请输入正确的金额。" duration:1];
        return;
    }

    if (self.bankText.text.length <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请输入银行名称。" duration:1];
        return;
    }

    if (self.openAccountBankText.text.length <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请输入开户行名称。" duration:1];
        return;
    }

    if (self.accountNoText.text.length <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请输入银行卡号名称。" duration:1];
        return;
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.amountTxt.text forKey:@"Amount"];
    [reqData setObject:self.openAccountBankText.text forKey:@"Bank"];
    [reqData setObject:self.openAccountBankText.text forKey:@"OpenAccountBank"];
    [reqData setObject:self.accountNoText.text forKey:@"AccountNo"];
    [reqData setObject:self.accountNameText.text forKey:@"AccountName"];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WITHDRAW_URL, self.groupId]]
                                                                andData:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createWithDrawFinish:)];
    [request setDidFailSelector:@selector(createWithDrawFail:)];
    [request startAsynchronous];
}

- (void)createWithDrawFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"withdrawal"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_COMPANY_BALANCE object:nil];
            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"提现失败，请重试！"];
}

- (void)createWithDrawFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"提现失败，请重试！"];
}

- (void)panHandler:(UIPanGestureRecognizer *)pan
{
    [self.amountTxt resignFirstResponder];
    [self.bankText resignFirstResponder];
    [self.openAccountBankText resignFirstResponder];
    [self.accountNoText resignFirstResponder];
    [self.accountNameText resignFirstResponder];
}

@end
