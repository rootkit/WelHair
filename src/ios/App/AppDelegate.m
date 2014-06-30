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
#import "AppointmentsViewController.h"
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate()<UIAlertViewDelegate>
{
     BMKMapManager* _mapManager;
    UINavigationController *_rootNav;
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

    _rootNav = [[UINavigationController alloc]  initWithRootViewController:[RootViewController new]];
    _rootNav.navigationBarHidden = YES;
    self.window.rootViewController = _rootNav;
    [self.window makeKeyAndVisible];

    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [self handleRemoteNotification:remoteNotif];
    return YES;
}

- (void)initialServices:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    //crash report
    [Crashlytics startWithAPIKey:@"b10b274f4b20fb41d2d6e477a6b4c032d790d4c9"];
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

    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[SettingManager SharedInstance] setDeviceToken:token];
    debugLog(@"device token %@", token);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *info = [userInfo objectForKey:@"aps"];
    int type = [[info objectForKey:@"type"] intValue];
    switch (type) {
        case REMOTE_NOTIFICATION_TYPE_STAFF_GET_APPOINTMENT:
        {
            if([UserManager SharedInstance].userLogined.role == WHStaff){
                [[SettingManager SharedInstance] setNotificationCount:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STAFF_GET_APPOINMENT object:nil userInfo:nil];
            }
        }
            break;
            
        default:
            break;
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
    [[BaiduMapHelper SharedInstance] locateCoordinateWithCompletion:^(BDLocation *locatioin) {
        [[SettingManager SharedInstance] setLocatedCoordinate:locatioin.coordinate];
    }];

    [[WebSocketUtil sharedInstance] reconnect];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[WebSocketUtil sharedInstance] close];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


@end
