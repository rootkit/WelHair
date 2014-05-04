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
#import "UMSocialQQHandler.h"
 #import "UMSocialWechatHandler.h"
#import "RootViewController.h"
#import "BMapKit.h"
#import "SettingManager.h"
#import "UserManager.h"
#import "WebSocketUtil.h"

#import "WelTabBarController.h"
#import "WorksViewController.h"
#import "GroupsViewController.h"
#import "ChatSessionListViewController.h"
#import "ProductsViewController.h"
#import "UserViewController.h"
#import "XGPush.h"


@interface AppDelegate()
{
     BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Util sharedInstance] prepareApplicationData];
    [self initialServices:application options:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationController *rootNav = [[UINavigationController alloc]  initWithRootViewController:[RootViewController new]];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initialServices:(UIApplication *)application  options:(NSDictionary *)launchOptions
{
    //setup social component
    [UMSocialData setAppKey:CONFIG_UMSOCIAL_APPKEY];
    [UMSocialConfig setSupportSinaSSO:YES];
    [UMSocialQQHandler setQQWithAppId:CONFIG_QQ_APP_ID appKey:CONFIG_QQ_APP_KEY url:SITE_PATH(@"")];
//    [UMSocialWechatHandler setWXAppId:CONFIG_WECHAT_ID url:SITE_PATH(@"")];
    //setup baidu map component
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    if (![_mapManager start:CONFIG_BAIDU_MAP_KEY  generalDelegate:nil])
        debugLog(@"manager start failed!");

    // xinge push
    [XGPush startApp:CONFIG_XINGE_ACCESSID appKey:CONFIG_XINGE_ACCESSKEY];
    [XGPush setAccount:@"cc"];
    [XGPush setTag:@"d"];
    [XGPush handleLaunching:launchOptions];
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];

}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
 
     NSString * deviceTokenStr = [XGPush registerDevice: deviceToken];
    [[SettingManager SharedInstance] setDeviceToken:deviceTokenStr];
    debugLog(@"device token %@", deviceTokenStr);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([UserManager SharedInstance].userLogined){
        
        [XGPush handleReceiveNotification:userInfo];
    }

    
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
//    [[WebSocketUtil sharedInstance] reconnect];
    [[BaiduMapHelper SharedInstance] locateCoordinateWithCompletion:^(BDLocation *locatioin)
    {
        [[SettingManager SharedInstance] setLocatedCoordinate:locatioin.coordinate];
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    [[WebSocketUtil sharedInstance] close];
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
