//
//  LoginViewController.m
//  WelHair
//
//  Created by lu larry on 2/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "LoginViewController.h"
#import "UMSocial.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rightNavItemTitle = @"Cancel";
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    UIButton *sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sinaLoginBtn.frame = CGRectMake(60, 100, 60, 40);
    [sinaLoginBtn addTarget:self action:@selector(sinaSignClick) forControlEvents:UIControlEventTouchUpInside];
    [sinaLoginBtn setTitle:@"Sina Login" forState:UIControlStateNormal];
    [self.view addSubview:sinaLoginBtn];
    
    UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    qqLoginBtn.frame = CGRectMake(200, 100, 60, 40);
    [qqLoginBtn addTarget:self action:@selector(qqSignClick) forControlEvents:UIControlEventTouchUpInside];
    [qqLoginBtn setTitle:@"QQ Login" forState:UIControlStateNormal];
    [self.view addSubview:qqLoginBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightNavItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sinaSignClick
{
    //`snsName` 代表各个支持云端分享的平台名，有`UMShareToSina`,`UMShareToTencent`等五个。
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      if (response.responseCode == UMSResponseCodeSuccess) {
                                          UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                                          NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                                      }
                                  });
}

- (void)qqSignClick
{
    //`snsName` 代表各个支持云端分享的平台名，有`UMShareToSina`,`UMShareToTencent`等五个。
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      NSLog(@"response is %@",response);
                                      //如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再次获取一次账户信息
//                                      if ([platformName isEqualToString:UMShareToSina]) {
//                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
//                                              NSLog(@"SinaWeibo's user name is %@",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]);
//                                          }];
//                                      }
                                      
                                      //这里可以获取到腾讯微博openid,Qzone的token等
                                      /*
                                       else if ([platformName isEqualToString:UMShareToTencent]) {
                                       [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
                                       NSLog(@"get openid  response is %@",respose);
                                       }];
                                       }
                                       */
                                  });
}

@end
