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

#import "AddAddressViewController.h"
#import "Address.h"
#import "AddressCell.h"
#import "AddressListViewController.h"
#import "UserManager.h"

@interface AddressListViewController ()<UITableViewDataSource, UITableViewDelegate, AddressCellDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddressListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"送货地址";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"新建";
        
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[AddAddressViewController new] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerTabelPullToRefresh) name:NOTIFICATION_REFRESH_ADDRESSLIST object:nil];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf getAddresses];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self triggerTabelPullToRefresh];
}

- (void)triggerTabelPullToRefresh
{
    [self.tableView triggerPullToRefresh];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"AddressCellIdentifier";
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }

    Address *item= [self.datasource objectAtIndex:indexPath.row];
    [cell setup:item];

    if(self.isPickingAddress && item == self.pickedAddress) {
        [cell setPicked:YES];
    } else if(!self.isPickingAddress && item.isDefault) {
        [cell setPicked:YES];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectAddress:[self.datasource objectAtIndex:indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"确认要删除该地址么？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定",nil];
        [alert.layer setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"editedIndex"];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

        NSNumber *editIndex = (NSNumber *)[alertView.layer valueForKey:@"editedIndex"];
        Address *address = [self.datasource objectAtIndex:[editIndex integerValue]];

        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_ADDRESSES_REMOVE, address.id]]
                                                                    andData:nil];
        [self.requests addObject:request];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(removeAddressFinish:)];
        [request setDidFailSelector:@selector(removeAddressFail:)];
        [request startAsynchronous];
    }
}

- (void)removeAddressFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] <= 0) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [self.tableView triggerPullToRefresh];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"删除地址失败，请重试！"];
}

- (void)removeAddressFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"删除地址失败，请重试！"];
}

- (void)addressCell:(AddressCell *)addressCell didClickEdit:(Address *)address
{
    AddAddressViewController *vc = [AddAddressViewController new];
    vc.address = address;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressCell:(AddressCell *)addressCell didSelected:(Address *)address
{
    [self didSelectAddress:address];
}

- (void)didSelectAddress:(Address *)address
{
    if (self.isPickingAddress && self.pickedAddress) {
        [self.delegate didPickAddress:address];
        [self.navigationController popViewControllerAnimated:YES];
    }

    if(!self.isPickingAddress && !address.isDefault) {
        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_ADDRESSES_DEFAULT, address.id]]
                                                                    andData:nil];
        [self.requests addObject:request];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(setDefaultAddressFinish:)];
        [request setDidFailSelector:@selector(setDefaultAddressFail:)];
        [request startAsynchronous];
    }
}

- (void)setDefaultAddressFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] <= 0) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD showSuccessWithStatus:@"设为默认地址" duration:1];
            [self.tableView triggerPullToRefresh];
            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"设置默认地址失败，请重试！"];
    [self.tableView triggerPullToRefresh];
}

- (void)setDefaultAddressFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"设置默认地址失败，请重试！"];
}

#pragma mark User Address API

- (void)getAddresses
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_ADDRESSES_LIST, [[UserManager SharedInstance] userLogined].id]]
                                                          andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetAddresses:)];
    [request setDidFailSelector:@selector(failGetAddresses:)];
    [request startAsynchronous];
}

- (void)finishGetAddresses:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSArray *dataList = [rst objectForKey:@"addresses"];

    NSMutableArray *arr = [NSMutableArray array];

    for (NSDictionary *dicData in dataList) {
        [arr addObject:[[Address alloc] initWithDic:dicData]];
    }

    self.datasource = arr;

    [self.tableView stopRefreshAnimation];

    [self checkEmpty];

    [self.tableView reloadData];
}

- (void)failGetAddresses:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

@end
