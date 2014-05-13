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

#import "Message.h"
#import "RegisterViewController.h"
#import "UserManager.h"
#import "WebSocketUtil.h"

static const float kOffsetY = 140;

@interface RegisterViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * viewContainer;

@property (nonatomic, strong) UITextField * nicknameTxt;
@property (nonatomic, strong) UITextField * emailTxt;
@property (nonatomic, strong) UITextField * pwdTxt;
@property (nonatomic, strong) UITextField * repeatePwdTxt;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
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

    self.viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.viewContainer.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
    [self.viewContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(backgroundTapped)]];
    [self.view addSubview:self.viewContainer];

    float margin = 40;
    UIImageView *logoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    logoIcon.image = [UIImage imageNamed:@"Logo"];
    [self.viewContainer addSubview:logoIcon];

    self.nicknameTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                               MaxY(logoIcon) + margin,
                                                               WIDTH(self.view) - 2 * margin,
                                                               35)
                                        leftPadding:5];
    self.nicknameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nicknameTxt.backgroundColor = [UIColor whiteColor];
    self.nicknameTxt.placeholder = @"  昵称";
    self.nicknameTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nicknameTxt.delegate = self;
    [self.viewContainer addSubview:self.nicknameTxt];

    self.emailTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                            MaxY(self.nicknameTxt) + 10,
                                                            WIDTH(self.view) - 2 * margin,
                                                            35)
                                     leftPadding:5];
    self.emailTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTxt.backgroundColor = [UIColor whiteColor];
    self.emailTxt.placeholder = @"  邮箱或手机号";
    self.emailTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTxt.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTxt.delegate = self;
    [self.viewContainer addSubview:self.emailTxt];

    self.pwdTxt = [UITextField plainTextField:CGRectMake(margin,
                                                         MaxY(self.emailTxt) + 10,
                                                         WIDTH(self.emailTxt),
                                                         35)
                                  leftPadding:5];
    self.pwdTxt.backgroundColor = [UIColor whiteColor];
    self.pwdTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pwdTxt.placeholder = @"  密码";
    self.pwdTxt.secureTextEntry = YES;
    self.pwdTxt.delegate = self;
    [self.viewContainer addSubview:self.pwdTxt];

    self.repeatePwdTxt = [UITextField plainTextField:CGRectMake(margin,
                                                                MaxY(self.pwdTxt) + 10,
                                                                WIDTH(self.emailTxt),
                                                                35)
                                  leftPadding:5];
    self.repeatePwdTxt.backgroundColor = [UIColor whiteColor];
    self.repeatePwdTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.repeatePwdTxt.placeholder = @"  重复密码";
    self.repeatePwdTxt.secureTextEntry = YES;
    self.repeatePwdTxt.delegate = self;
    [self.viewContainer addSubview:self.repeatePwdTxt];

    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = [UIColor colorWithHexString:@"e4393c"];
    registerBtn.frame = CGRectMake(margin, MaxY(self.repeatePwdTxt) + 20, WIDTH(self.emailTxt), 40);
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.viewContainer addSubview:registerBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backgroundTapped
{
    [self.nicknameTxt resignFirstResponder];
    [self.emailTxt resignFirstResponder];
    [self.pwdTxt resignFirstResponder];
    [self.repeatePwdTxt resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;

    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;

    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;

    void (^animations)() = ^() {
        self.viewContainer.frame = CGRectMake(0, -kOffsetY, WIDTH(self.viewContainer), HEIGHT(self.viewContainer));
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

- (void)registerClick
{
    if (![self validInput]) {
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSString *signupURL = API_USERS_SIGNUP_EMAIL;
    NSString *signupKey = @"Email";

    if (![self.emailTxt.text isValidEmailWithStricterFilter:NO]) {
        signupURL = API_USERS_SIGNUP_MOBILE;
        signupKey = @"Mobile";
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.nicknameTxt.text forKey:@"Nickname"];
    [reqData setObject:self.emailTxt.text forKey:signupKey];
    [reqData setObject:self.pwdTxt.text forKey:@"Password"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:signupURL]
                                                                andData:reqData];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(signUpWithEmailFinish:)];
    [request setDidFailSelector:@selector(signUpWithEmailFail:)];
    [request startAsynchronous];
}

- (void)signUpWithEmailFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"user"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [UserManager SharedInstance].userLogined = [[User alloc] initWithDic:[responseMessage objectForKey:@"user"]];

            NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dicData setObject:[NSNumber numberWithInt:[UserManager SharedInstance].userLogined.id] forKey:@"UserId"];
            [dicData setObject:[NSNumber numberWithInt:WHMessageTypeUpdateUser] forKey:@"Type"];

            NSString *message = [Util parseJsonFromObject:dicData];
           // [[WebSocketUtil sharedInstance].webSocket send:message];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_STATUS_CHANGE object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"注册失败，请重试！"];

}

- (void)signUpWithEmailFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"注册失败，请重试！"];
}

- (BOOL)validInput
{
    if(self.nicknameTxt.text.length == 0){
        [self.nicknameTxt shake:10
                      withDelta:5
                       andSpeed:0.04
                 shakeDirection:ShakeDirectionHorizontal];
        return NO;
    } else if(self.emailTxt.text.length == 0){
        [self.emailTxt shake:10
                   withDelta:5
                    andSpeed:0.04
              shakeDirection:ShakeDirectionHorizontal];
        return NO;
    } else if(self.pwdTxt.text.length == 0){
        [self.pwdTxt shake:10
                 withDelta:5
                  andSpeed:0.04
            shakeDirection:ShakeDirectionHorizontal];
        return NO;
    } else if(self.repeatePwdTxt.text.length == 0){
        [self.repeatePwdTxt shake:10
                        withDelta:5
                         andSpeed:0.04
                   shakeDirection:ShakeDirectionHorizontal];
        return NO;
    }

    if (![self.emailTxt.text isValidEmailWithStricterFilter:NO] && ![self.emailTxt.text isValidMobile]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱或手机号格式不合法！"];
        return NO;
    }

    if (![self.pwdTxt.text isEqualToString:self.repeatePwdTxt.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致！"];
        return NO;
    }

    return YES;
}

@end
