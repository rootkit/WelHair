// ==============================================================================
//
// This file is part of the WelSpeak.
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "AppointmentsViewController.h"
#import "BaiduMapHelper.h"
#import "BaseViewController.h"
#import "City.h"
#import "CityManager.h"
#import "LoginViewController.h"
#import "OrderListViewController.h"
#import "UserManager.h"

@interface BaseViewController ()
{
    BOOL isAppearanceSetup;
}
@end

@implementation BaseViewController

- (void)dealloc
{
    for (ASIHTTPRequest *request in self.requests) {
        [request clearDelegatesAndCancel];
    }

    [self.requests removeAllObjects];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.topBarOffset = isIOS70 ? kStatusBarHeight + kTopBarHeight : 0;
        self.bottomBarOffset = isIOS70 ? kBottomBarHeight : 0;

        self.requests = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAppointmentList) name:NOTIFICATION_PUSH_TO_APPOINTMENTLIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToOrderList) name:NOTIFICATION_PUSH_TO_ORDERLIST object:nil];

    if (isIOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self generalAppearanceSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generalAppearanceSetup
{
    if(isAppearanceSetup){
        return;
    }else{
        isAppearanceSetup = YES;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    if (isIOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (self.navigationController) {
        [self.navigationController.navigationBar configureNavigationBarWithColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
        
        [self setLeftNavButtonTitle:self.leftNavItemTitle buttonImg:self.leftNavItemImg];
        [self setRightNavButtonTitle:self.rightNavItemTitle buttonImg:self.rightNavItemImg];
    }
}

- (void)leftNavItemClick
{

}

- (void)rightNavItemClick
{
    
}


- (float)contentHeightWithNavgationBar:(BOOL)showNav
                    withBottomBar:(BOOL)showBottom
{
    float height = 0;
    float topBarHeight = showNav ? kTopBarHeight : 0;
    float bottomBarHeight = showBottom ? kBottomBarHeight : 0;
    if(isIOS6){
        height =  HEIGHT(self.view) - topBarHeight - bottomBarHeight;
    }else if(isIOS7) {
        height = HEIGHT(self.view) - kStatusBarHeight - topBarHeight - bottomBarHeight;
    }
    return height;
}

- (void)setLeftNavButtonTitle:(NSString *)title
                 buttonImg:(UIImage *)img
{
    if (title.length <= 0 && !img) {
        return;
    }

    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [leftItemButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchDown];
    if(title.length > 0){
        leftItemButton.frame = CGRectMake(6, 0, 80, kTopBarHeight);
        leftItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftItemButton setTitle:title forState:UIControlStateNormal];
    }else{
        leftItemButton.frame = CGRectMake(0, 0, kTopBarHeight, kTopBarHeight);
        [leftItemButton setImage:img forState:UIControlStateNormal];
    }
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(leftItemButton), HEIGHT(leftItemButton))];
    [leftItemView addSubview:leftItemButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-navItemMargin];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];
}

- (void)setRightNavButtonTitle:(NSString *)title
                    buttonImg:(UIImage *)img
{
    if (title.length <= 0 && !img) {
        return;
    }

    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightItemButton addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchDown];
    if(title.length > 0){
        rightItemButton.frame = CGRectMake(-6, 0, 80, kTopBarHeight);
        rightItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightItemButton setTitle:title forState:UIControlStateNormal];
    }else{
        rightItemButton.frame = CGRectMake(0, 0, kTopBarHeight, kTopBarHeight);
        [rightItemButton setImage:img forState:UIControlStateNormal];
    }
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(rightItemButton), HEIGHT(rightItemButton))];
    [rightItemView addSubview:rightItemButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-navItemMargin];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,self.navigationItem.rightBarButtonItem, nil];
}

- (void)setTopLeftCityName
{
#if TARGET_IPHONE_SIMULATOR
    City *selectedCity = [[CityManager SharedInstance] getSelectedCity];
    if (selectedCity.id > 0) {
        self.leftNavItemTitle = selectedCity.name;
        [self setLeftNavButtonTitle:self.leftNavItemTitle buttonImg:nil];
    } else {
        self.leftNavItemTitle = @"济南";
    }
#else
    City *selectedCity = [[CityManager SharedInstance] getSelectedCity];
    if(selectedCity.id > 0){
        self.leftNavItemTitle = selectedCity.name;
        [self setLeftNavButtonTitle:self.leftNavItemTitle buttonImg:nil];
    }else{
        City *locatedCity = [[CityManager SharedInstance] getLocatedCity];
        if(locatedCity.id > 0){
            self.leftNavItemTitle = locatedCity.name;
            [self setLeftNavButtonTitle:self.leftNavItemTitle buttonImg:nil];
        }else{
            [self setTopLeftLoading];
            [[BaiduMapHelper SharedInstance] locateCityWithCompletion:^(BDLocation *location){
                [self setLeftNavButtonTitle:location.locatedCity.name buttonImg:nil];
                [[CityManager SharedInstance] setLocatedCity:location.locatedCity.id];
                [[CityManager SharedInstance] setSelectedCity:location.locatedCity.id];
            }];
        }
    }
#endif
}

- (void)setTopLeftLoading
{
    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 100, kTopBarHeight)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite ];
    loadingView.frame = CGRectMake(0, 10, 25, 25);
    [loadingView startAnimating];
    [leftItemView addSubview:loadingView];
    [leftItemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftNavItemClick)]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-navItemMargin];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];

}

- (BOOL)checkLogin
{
    if(![UserManager SharedInstance].userLogined)
    {
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]]
                                                animated:YES
                                              completion:nil];
        return NO;
    }else{
        return YES;
    }
}

- (void)showLeftBadge:(int)number
{
    
}

- (void)pushToAppointmentList
{
    AppointmentsViewController *vc = [AppointmentsViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userId = [[UserManager SharedInstance] userLogined].id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToOrderList
{
    OrderListViewController *vc = [OrderListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
