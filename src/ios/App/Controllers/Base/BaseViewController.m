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
        self.topBarOffset = isIOS7 ? kStatusBarHeight + kTopBarHeight : 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isIOS7) {
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (isIOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (self.navigationController) {
        [self.navigationController.navigationBar configureNavigationBarWithColor:[UIColor colorWithHexString:APP_BACKGROUND_COLOR]];
        CGFloat navItemMargin = isIOS7 ? 16 : 0;
        
        if (self.leftNavItemIcon) {
            UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftItemButton.frame = CGRectMake(0, 0, kTopBarHeight, kTopBarHeight);
            [leftItemButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
            [leftItemButton setImage:_leftNavItemIcon forState:UIControlStateNormal];
            
            UIView *leftItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(leftItemButton), HEIGHT(leftItemButton))];
            [leftItemView addSubview:leftItemButton];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [negativeSpacer setWidth:-navItemMargin];
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.leftBarButtonItem, nil];
        }else if(self.leftNavItemTitle.length >0){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.leftNavItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftNavItemClick)];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        }
        
        if (self.rightNavItemIcon) {
            UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightItemButton.frame = CGRectMake(0, 0, kTopBarHeight, kTopBarHeight);
            [rightItemButton addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
            [rightItemButton setImage:_rightNavItemIcon forState:UIControlStateNormal];
            
            UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(rightItemButton), HEIGHT(rightItemButton))];
            [rightItemView addSubview:rightItemButton];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [negativeSpacer setWidth:-navItemMargin];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.navigationItem.rightBarButtonItem, nil];
        }else if(self.rightNavItemTitle.length >0){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.rightNavItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemClick)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        }
    }
}

- (void)leftNavItemClick
{

}

- (void)rightNavItemClick
{
    
}
@end
