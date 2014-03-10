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

#import "AppDelegate.h"
#import "UMSocial.h"
#import "RootViewController.h"
#import "BMapKit.h"
#import <TencentOpenAPI/QQApiInterface.h> 
#import <TencentOpenAPI/TencentOAuth.h>

#import "WebSocketUtil.h"

#import "WelTabBarController.h"
#import "WorksViewController.h"
#import "GroupsViewController.h"
#import "ChatSessionListViewController.h"
#import "ProductsViewController.h"
#import "UserViewController.h"

@interface AppDelegate()
{
     BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationController *rootNav = [[UINavigationController alloc]  initWithRootViewController:[RootViewController new]];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    
    [self initialServices];
    
    return YES;
}

- (void)initialServices
{
    //setup social component
    [UMSocialData setAppKey:CONFIG_UMSOCIAL_APPKEY];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialConfig setWXAppId:CONFIG_WECHAT_ID url:nil];
    [UMSocialConfig setQQAppId:CONFIG_QQ_APP_ID url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setSupportSinaSSO:YES];
    
    //setup baidu map component
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    if (![_mapManager start:CONFIG_BAIDU_MAP_KEY  generalDelegate:nil])
        debugLog(@"manager start failed!");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    [[WebSocketUtil sharedInstance] reconnect];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[WebSocketUtil sharedInstance] close];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


@end
