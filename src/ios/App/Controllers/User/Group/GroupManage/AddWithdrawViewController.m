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

#import "AddWithdrawViewController.h"
#import "UserManager.h"

static const float kMargin = 10;

@interface AddWithdrawViewController ()

@property (nonatomic, strong) UITextField *amountTxt;
@property (nonatomic, strong) UILabel *balanceLbl;

@end

@implementation AddWithdrawViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"提现申请";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"保存";
        
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    NSString *value = self.amountTxt.text;
    if([value floatValue] > self.balance){
        [SVProgressHUD showErrorWithStatus:@"提现金额超出余额！" duration:1];
        return;
    }
    if(value.length  > 0 && [value floatValue] > 0){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:@([[UserManager SharedInstance] userLogined].id) forKey:@"UserId"];
        [reqData setObject:@([[UserManager SharedInstance] userLogined].groupId) forKey:@"comapanyId"];
        [reqData setObject:value forKey:@"amount"];
        
        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_WITHDRAW_CREATE]
                                                                    andData:reqData];
        [self.requests addObject:request];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(createWithdrawFinish:)];
        [request setDidFailSelector:@selector(createWithDrawFail:)];
        [request startAsynchronous];
    }
}

- (void)createWithdrawFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if (![responseMessage objectForKey:@"service"]) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
    }
    
    [SVProgressHUD showErrorWithStatus:@"添加服务失败，请重试！"];
}

- (void)createWithDrawFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加服务失败，请重试！"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,self.topBarOffset + 10, 160, 30)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.text = @"当前余额:";
    titleLbl.textAlignment = TextAlignmentRight;
    [self.view addSubview:titleLbl];
    
    self.balanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(180,10, 150, 30)];
    self.balanceLbl.backgroundColor = [UIColor clearColor];
    self.balanceLbl.textColor = [UIColor redColor];
    self.balanceLbl.font = [UIFont systemFontOfSize:16];
    self.balanceLbl.textAlignment = TextAlignmentLeft;
    self.balanceLbl.text=  [NSString stringWithFormat:@"%.2f",self.balance];
    [self.view addSubview:self.balanceLbl];
    

    
    self.amountTxt =  [UITextField plainTextField:CGRectMake(10,
                                                           MaxY(self.balanceLbl) + 10,
                                                           300,
                                                           40)
                                    leftPadding:kMargin];
    self.amountTxt.font = [UIFont systemFontOfSize:14];
    self.amountTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.amountTxt.backgroundColor = [UIColor whiteColor];
    self.amountTxt.placeholder = @"提现金额";
    self.amountTxt.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.amountTxt];
    [self.amountTxt becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
