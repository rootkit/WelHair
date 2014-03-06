//
//  LoginViewController.m
//  WelHair
//
//  Created by lu larry on 2/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "LoginViewController.h"
#import "UMSocial.h"
#import <QuartzCore/QuartzCore.h>

static const float KOffsetY = 50;
@interface LoginViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView * viewContainer;
@property (nonatomic, strong) UITextField * userNameTxt;
@property (nonatomic, strong) UITextField * pwdTxt;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.rightNavItemTitle = NSLocalizedString(@"Register", nil);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    self.viewContainer.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
    [self.viewContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)]];
    [self.view addSubview:self.viewContainer];
    
    float margin = 40;
    UIImageView *logoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(110, 20, 100, 100)];
    logoIcon.image = [UIImage imageNamed:@"Logo"];
    [self.viewContainer addSubview:logoIcon];
    
    
    self.userNameTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                               MaxY(logoIcon) + margin,
                                                               WIDTH(self.view) - 2 * margin,
                                                               35)
                                        leftPadding:5];
    self.userNameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userNameTxt.backgroundColor = [UIColor whiteColor];
    self.userNameTxt.placeholder = @"  用户名/手机号";
    self.userNameTxt.delegate = self;
    [self.viewContainer addSubview:self.userNameTxt];
    
    self.pwdTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                          MaxY(self.userNameTxt) + 10,
                                                          WIDTH(self.userNameTxt),
                                                          35)
                                   leftPadding:5];
    self.pwdTxt.backgroundColor = [UIColor whiteColor];
    self.pwdTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pwdTxt.placeholder = @"  密码";
    self.pwdTxt.secureTextEntry = YES;
    self.pwdTxt.delegate = self;
    [self.viewContainer addSubview:self.pwdTxt];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(margin, MaxY(self.pwdTxt) + 20, WIDTH(self.userNameTxt), 40);
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"e4393c"];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchDown];
    [self.viewContainer addSubview:loginBtn];

    
    float bottomHeight = 80;
    UIView *bottomView =
    [[UIView alloc] initWithFrame:CGRectMake(0,
                                             HEIGHT(self.viewContainer) - bottomHeight,
                                             WIDTH(self.viewContainer),
                                             bottomHeight)];
    [self.viewContainer addSubview:bottomView];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(margin, 20, 40, 1)];
    leftLineView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:leftLineView];
    
    
    UILabel *socialLoginLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(leftLineView) + 20,10, 120,20)];
    socialLoginLbl.text = @"或以下方式登录";
    socialLoginLbl.textAlignment = NSTextAlignmentCenter;
    socialLoginLbl.textColor = [UIColor whiteColor];
    socialLoginLbl.font = [UIFont systemFontOfSize:14];
    socialLoginLbl.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:socialLoginLbl];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(self.view) - margin - 40, 20, 40, 1)];
    rightLineView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:rightLineView];
    
    
    float socialBtnSize = 28;
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame = CGRectMake(70, MaxY(socialLoginLbl) + 10, socialBtnSize, socialBtnSize);
    [sinaBtn setImage:[UIImage imageNamed:@"SinaWeibo"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(sinaSignClick) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:sinaBtn];
    
    UIView *vLine1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(sinaBtn) + 22,MaxY(socialLoginLbl) + 10, 1, 30)];
    vLine1.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:vLine1];
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(MaxX(sinaBtn) + 45, MaxY(socialLoginLbl) + 10, socialBtnSize, socialBtnSize);
    [qqBtn setImage:[UIImage imageNamed:@"QQIcon"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqSignClick) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:qqBtn];
    
    UIView *vLine2 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(qqBtn) + 22, MaxY(socialLoginLbl) + 10, 1, 30)];
    vLine2.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:vLine2];
    
    UIButton *tecentWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tecentWeiboBtn.frame = CGRectMake(MaxX(qqBtn) + 45, MaxY(socialLoginLbl) + 10, socialBtnSize, socialBtnSize);
    [tecentWeiboBtn setImage:[UIImage imageNamed:@"QQWeiboIcon"] forState:UIControlStateNormal];
    [tecentWeiboBtn addTarget:self action:@selector(sinaSignClick) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:tecentWeiboBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftNavItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightNavItemClick
{
    NSLog(@"register clicked");
}

- (void)backgroundTapped
{
    [self.userNameTxt resignFirstResponder];
    [self.pwdTxt resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    void (^animations)() = ^() {
        self.viewContainer.frame = CGRectMake(0, -KOffsetY, WIDTH(self.viewContainer), HEIGHT(self.viewContainer));
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    void (^animations)() = ^() {
        self.viewContainer.frame = CGRectMake(0,self.topBarOffset, WIDTH(self.viewContainer), HEIGHT(self.viewContainer));
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}

- (void)loginClick
{
    if([self validInput]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (BOOL)validInput
{
    if(self.userNameTxt.text.length == 0){
        [self.userNameTxt shake:10
                    withDelta:5
                     andSpeed:0.04
               shakeDirection:ShakeDirectionHorizontal];
        return NO;
    }else if(self.pwdTxt.text.length == 0){
        [self.pwdTxt shake:10
                      withDelta:5
                       andSpeed:0.04
                 shakeDirection:ShakeDirectionHorizontal];
        return NO;
    }
    return YES;
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
