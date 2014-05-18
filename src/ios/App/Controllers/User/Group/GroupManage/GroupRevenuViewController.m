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

#import "GroupRevenuViewController.h"
#import "GroupRevenuCell.h"
#import "StaffRevenuViewController.h"
@interface GroupRevenuViewController ()<UITableViewDataSource, UITableViewDelegate, GroupRevenuCellDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GroupRevenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙收益";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

-(void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)insertRowAtTop
{
    int64_t delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView stopRefreshAnimation];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    
    
    UILabel *monthLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0,100,50)];
    monthLbl.text = @"1月";
    monthLbl.font = [UIFont systemFontOfSize:16];
    monthLbl.numberOfLines = 1;
    monthLbl.backgroundColor = [UIColor clearColor];
    monthLbl.textColor = [UIColor blackColor];
    [headerView addSubview:monthLbl];
    
    UIView *verticalLiner = [[UIView alloc] initWithFrame:CGRectMake(110, 10, 1, 30)];
    verticalLiner.backgroundColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    [headerView addSubview:verticalLiner];
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(120,0,180,50)];
    priceLbl.text = @"+500";
    priceLbl.font = [UIFont systemFontOfSize:16];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.numberOfLines = 1;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textColor = [UIColor lightGrayColor];
    [headerView addSubview:priceLbl];
    return headerView;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GroupRevenuCellIdentifier";
    GroupRevenuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GroupRevenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell setup:nil];
    return cell;
}

- (void)didTapStaff:(int)staffId
{
    StaffRevenuViewController *vc= [StaffRevenuViewController new];
    vc.staffId = staffId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
