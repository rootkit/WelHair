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
#import "MyStaffViewController.h"
#import "Staff.h"
#import "StaffCell.h"
#import "StaffDetailViewController.h"
#import "CommentComposorViewController.h"

@interface MyStaffViewController () <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyStaffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的发型师";
        self.currentPage = 1;
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset ,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getStaffs];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getStaffs];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    
    [self.tableView triggerPullToRefresh];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffCellIdentifier";
    StaffCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0 ?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Staff *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Staff *data = [self.datasource objectAtIndex:indexPath.row];
    CommentComposorViewController *vc = [CommentComposorViewController new];
    vc.userId =data.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffCell * cell = (StaffCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = [UIColor colorWithHexString:@"#eee"];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffCell * cell = (StaffCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.contentView.backgroundColor = cell.backgroundColor = indexPath.row % 2 == 0 ?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
}

#pragma mark Staff Search API

- (void)getStaffs
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_STAFFS_MINE] andParam:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetStaffs:)];
    [request setDidFailSelector:@selector(failGetStaffs:)];
    [request startAsynchronous];
}

- (void)finishGetStaffs:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"staffs"];
    
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
        [arr addObject:[[Staff alloc] initWithDic:dicData]];
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
    
    [self checkEmpty];
    
    [self.tableView reloadData];
}

- (void)failGetStaffs:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

@end
