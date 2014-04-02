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

#import "GroupStaffListViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "StaffDetailViewController.h"
#import "StaffCell.h"
#import "Staff.h"

@interface GroupStaffListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *hotBtn;

@end

@implementation GroupStaffListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"GroupsViewController.Title", nil);
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
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertRowAtTop
{
    int64_t delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView stopRefreshAnimation];
    });
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
    cell.contentView.backgroundColor =  cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Staff *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffDetailViewController *vc = [StaffDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
