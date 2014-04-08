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

#import "OrderListViewController.h"
#import "OrderCell.h"
#import "OrderPreviewViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"


@interface OrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *areaBtn;
@property (nonatomic, strong) UIButton *colorBtn;
@property (nonatomic, strong) UIButton *lengthBtn;

@property (nonatomic, strong) UIButton *paidBtn;
@property (nonatomic, strong) UIButton *unpaidBtn;
@end

@implementation OrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单列表";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset , 320, 40)];
    topBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBgView];
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10, self.topBarOffset + 5, 300, 30)];
    UIColor *tabViewColor =[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] ;
    [self.view addSubview:tabView];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.layer.borderColor = [tabViewColor CGColor];
    tabView.layer.borderWidth = 1;
    tabView.layer.cornerRadius = 5;
    float tabButtonWidth = 300 / 2;
    
    self.unpaidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unpaidBtn.frame = CGRectMake(0,0,tabButtonWidth,30);
    self.unpaidBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.unpaidBtn setTitle:@"未付款" forState:UIControlStateNormal];
    [self.unpaidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.unpaidBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [self.unpaidBtn setBackgroundColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    
    
    [tabView addSubview:self.unpaidBtn];
    
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.unpaidBtn),0, 1, HEIGHT(tabView))];
    separatorView1.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView1];
    self.paidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.paidBtn.frame = CGRectMake(MaxX(separatorView1),0,tabButtonWidth,HEIGHT(tabView));
    self.paidBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.paidBtn setTitle:@"已付款" forState:UIControlStateNormal];
    [self.paidBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    [self.paidBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [tabView addSubview:self.paidBtn];


    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset + tabView.height + 10,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO] - tabView.height - 10);
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
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeOrderList:NO]];
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
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"OrderCellIdentifier";
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setup:[self.datasource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPreviewViewController *vc = [OrderPreviewViewController new];
    vc.order = [self.datasource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn == self.paidBtn){
        [self.paidBtn setBackgroundColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
        [self.paidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.unpaidBtn setBackgroundColor:[UIColor whiteColor]];
        [self.unpaidBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
        self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeOrderList:YES]];
        [self.tableView reloadData];
    }else{
        [self.unpaidBtn setBackgroundColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
        [self.unpaidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.paidBtn setBackgroundColor:[UIColor whiteColor]];
        [self.paidBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
        self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeOrderList:NO]];
        [self.tableView reloadData];
    }
}

@end
