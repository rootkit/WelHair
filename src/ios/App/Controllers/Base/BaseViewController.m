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

#import "BaseViewController.h"
#import "City.h"
#import "CityManager.h"
#import "BaiduMapHelper.h"

@interface BaseViewController ()
{
    BOOL isAppearanceSetup;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.topBarOffset = isIOS70 ? kStatusBarHeight + kTopBarHeight : 0;
        self.bottomBarOffset = isIOS70 ? kBottomBarHeight : 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        CGFloat navItemMargin = isIOS7 ? 16 : 0;
        
        if (self.leftNavItemImg) {
            UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftItemButton.frame = CGRectMake(0, 0, kTopBarHeight, kTopBarHeight);
            [leftItemButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
            [leftItemButton setImage:self.leftNavItemImg forState:UIControlStateNormal];
            
            UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(leftItemButton), HEIGHT(leftItemButton))];
            [leftItemView addSubview:leftItemButton];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [negativeSpacer setWidth:-navItemMargin];
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];
        }else if(self.leftNavItemTitle.length >0){
            [self setNavLeftTitle:self.leftNavItemTitle];
        }
        
        if (self.rightNavItemImg) {
            UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImageView *img = [[UIImageView alloc] initWithImage:self.rightNavItemImg];
            rightItemButton.frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
            [rightItemButton addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
            [rightItemButton setImage:_rightNavItemImg forState:UIControlStateNormal];
            
            UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(rightItemButton), HEIGHT(rightItemButton))];
            [rightItemView addSubview:rightItemButton];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [negativeSpacer setWidth:-navItemMargin];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: self.navigationItem.rightBarButtonItem,negativeSpacer, nil];
        }else if(self.rightNavItemTitle.length >0){
            [self setNavRightTitle:self.rightNavItemTitle];
        }
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

- (void)setNavLeftTitle:(NSString *)leftNavTitle
{
    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame = CGRectMake(0, 0, 100, kTopBarHeight);
    leftItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftItemButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [leftItemButton setTitle:leftNavTitle forState:UIControlStateNormal];
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(leftItemButton), HEIGHT(leftItemButton))];
    [leftItemView addSubview:leftItemButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-navItemMargin];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];

}

- (void)setNavRightTitle:(NSString *)rightNavTitle
{
    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 100, kTopBarHeight);
    rightItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItemButton addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setTitle:rightNavTitle forState:UIControlStateNormal];
    
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(rightItemButton), HEIGHT(rightItemButton))];
    [rightItemView addSubview:rightItemButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-navItemMargin];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: self.navigationItem.rightBarButtonItem,negativeSpacer, nil];
}

- (void)setTopLeftCityName
{
    City *selectedCity = [[CityManager SharedInstance] getSelectedCity];
    if(selectedCity.id > 0){
        self.leftNavItemTitle = selectedCity.name;
    }else{
        City *locatedCity = [[CityManager SharedInstance] getLocatedCity];
        if(locatedCity.id > 0){
            self.leftNavItemTitle = locatedCity.name;
        }else{
            [self setTopLeftLoading];
            [[BaiduMapHelper SharedInstance] locateCityWithCompletion:^(City *city){
                [self setNavLeftTitle:city.name];
                [[CityManager SharedInstance] setLocatedCity:city.id];
                [[CityManager SharedInstance] setSelectedCity:city.id];
            }];
        }
    }
}

- (void)setTopLeftLoading
{
    CGFloat navItemMargin = isIOS7 ? 16 : 0;
    UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, kTopBarHeight)];
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
@end
