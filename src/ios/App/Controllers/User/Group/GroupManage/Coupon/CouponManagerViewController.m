//
//  CouponManagerViewController.m
//  WelHair
//
//  Created by lu larry on 3/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "CouponManagerViewController.h"

#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "CouponDetailViewController.h"
#import "CouponCell.h"
#import "Coupon.h"
#import "CreateCouponViewController.h"

@interface CouponManagerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *offlineButton;
@end

@implementation CouponManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  @"优惠券管理";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        FAKIcon *rightIcon = [FAKIonIcons ios7PlusOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[CreateCouponViewController new] animated:YES];
}

- (void) loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float topTabButtonWidth = WIDTH(self.view)/2;
    UIView *topTabView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,WIDTH(self.view),40)];
    [self.view addSubview:topTabView];
    topTabView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.onlineButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.onlineButton.frame = CGRectMake(0, 0, topTabButtonWidth , TOP_TAB_BAR_HEIGHT);
    [self.onlineButton setTitle:@"已上线" forState:UIControlStateNormal];
    self.onlineButton.tag = 0;
    self.onlineButton.backgroundColor = [UIColor whiteColor];
    [self.onlineButton addTarget:self action:@selector(senmentClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.onlineButton];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.onlineButton), 10, 1, 20)];
    separatorView.backgroundColor = [UIColor grayColor];
    [topTabView addSubview:separatorView];
    
    self.offlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.offlineButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.offlineButton.frame = CGRectMake(MaxX(self.onlineButton)+1, 0, topTabButtonWidth, TOP_TAB_BAR_HEIGHT);
    [self.offlineButton setTitle:@"已下线" forState:UIControlStateNormal];
    self.offlineButton.backgroundColor = [UIColor whiteColor];
    self.offlineButton.tag = 1;
    [self.offlineButton addTarget:self action:@selector(senmentClick:) forControlEvents:UIControlEventTouchDown];
    [topTabView addSubview:self.offlineButton];
    // draw shadow
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_TAB_BAR_HEIGHT -1, WIDTH(topTabView), 1)];
    shadowView.backgroundColor = [UIColor lightGrayColor];
    [topTabView addSubview:shadowView];
    topTabView.backgroundColor = [UIColor colorWithWhite:255 alpha:0.7];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    debugLog(@"%f",MaxY(topTabView));
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:topTabView.bounds];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    
    //    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        //        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"pull_to_refresh_loading"]];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:topTabView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeCouponList]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)senmentClick:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
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
    static NSString * cellIdentifier = @"GroupCellIdentifier";
    CouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor =  cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Coupon *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponDetailViewController *detail = [CouponDetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}





@end
