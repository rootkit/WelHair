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

#import "City.h"
#import "CityListViewController.h"
#import "CityManager.h"
#import "Group.h"
#import "GroupCell.h"
#import "JoinGroupViewController.h"

@interface JoinGroupViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CityPickViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) int selectedGroupId;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation JoinGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"加入沙龙";
        self.rightNavItemTitle = @"关闭";
    }

    return self;
}

- (void)leftNavItemClick
{
    CityListViewController *picker = [CityListViewController new];
    picker.selectedCity = [[CityManager SharedInstance] getSelectedCity];
    picker.enableLocation = YES;
    picker.delegate = self;

    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
                                            animated:YES completion:nil];
}

- (void)rightNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPickCity:(City *)city
{
    [[CityManager SharedInstance] setSelectedCity:city.id];
    [self setTopLeftCityName];

    self.currentPage = 1;
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopLeftCityName];

    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.showsBookmarkButton = NO;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.tintColor = [UIColor whiteColor];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf searchGroups];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf searchGroups];
    }];
    self.tableView.showsInfiniteScrolling = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GroupCellIdentifier";

    GroupCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];

    Group *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group *selectedGroup = [self.datasource objectAtIndex:indexPath.row];
    self.selectedGroupId = selectedGroup.id;

    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                  message:@"确认要加入该沙龙么？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    self.currentPage = 1;
    [self searchGroups];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

- (void)searchGroups
{
    [self.searchBar resignFirstResponder];

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.searchBar.text forKey:@"searchText"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", [CityManager SharedInstance].getSelectedCity.id] forKey:@"city"];
    [reqData setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"district"];
    [reqData setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"sort"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_COMPANIES_SEARCH] andParam:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishSearchGroups:)];
    [request setDidFailSelector:@selector(failSearchGroups:)];
    [request startAsynchronous];
}

- (void)finishSearchGroups:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"companies"];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datasource];

    if (self.currentPage == 1) {
        [arr removeAllObjects];
    } else {
        if (self.currentPage % TABLEVIEW_PAGESIZE_DEFAULT > 0) {
            int i;

            for (i = 0; i < arr.count; i++) {
                if (i >= (self.currentPage - 1) * TABLEVIEW_PAGESIZE_DEFAULT) {
                    [arr removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }

    for (NSDictionary *dicData in dataList) {
        [arr addObject:[[Group alloc] initWithDic:dicData]];
    }

    self.datasource = arr;

    BOOL enableInfinite = total > self.datasource.count;
    if (self.tableView.showsInfiniteScrolling != enableInfinite) {
        self.tableView.showsInfiniteScrolling = enableInfinite;
    }

    if (self.currentPage == 1) {
        [self.tableView stopRefreshAnimation];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }

    [self.tableView reloadData];
}

- (void)failSearchGroups:(ASIHTTPRequest *)request
{
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];


        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_COMPANIES_JOIN, self.selectedGroupId]]
                                                                    andData:nil];
        [self.requests addObject:request];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(joinGroupFinish:)];
        [request setDidFailSelector:@selector(joinGroupFail:)];
        [request startAsynchronous];
    }
}

- (void)joinGroupFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if (![responseMessage objectForKey:@"success"]) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_CREATE_GROUP_SUCCESS object:nil];
            
            return;
        }
    }
    
    [SVProgressHUD showErrorWithStatus:@"加入沙龙失败，请重试！"];
}

- (void)joinGroupFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"加入沙龙失败，请重试！"];
}

@end
