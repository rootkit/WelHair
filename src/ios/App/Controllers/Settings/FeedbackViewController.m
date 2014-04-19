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

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
{
    UITextView *textView;
}

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户反馈";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.rightNavItemTitle = @"发送";
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) rightNavItemClick
{

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:textView.text forKey:@"Body"];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_FEEDBACK_CREATE]
                                                                andData:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createCommentFinish:)];
    [request setDidFailSelector:@selector(createCommentFail:)];
    [request startAsynchronous];
}

- (void)createCommentFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"feedback"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD showSuccessWithStatus:@"发送反馈成功。"];

            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"添加反馈失败，请重试！"];
}

- (void)createCommentFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加反馈失败，请重试！"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float height = [self contentHeightWithNavgationBar:YES withBottomBar:NO] - kChineseKeyboardHeight - 20;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10,
                                                            self.topBarOffset + 10,
                                                            WIDTH(self.view) - 20 ,
                                                            height )];
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 3;
    [self.view addSubview:textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
