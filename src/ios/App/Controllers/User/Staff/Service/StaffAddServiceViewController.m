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

#import "StaffAddServiceViewController.h"
#import "UserManager.h"

static const float kMargin = 10;

@interface StaffAddServiceViewController ()

@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *originalPriceTxt;
@property (nonatomic, strong) UITextField *saleOffTxt;
@property (nonatomic, strong) UILabel *finalPriceLbl;

@end

@implementation StaffAddServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self.nameTxt resignFirstResponder];
    [self.originalPriceTxt resignFirstResponder];
    [self.saleOffTxt resignFirstResponder];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:@([[UserManager SharedInstance] userLogined].id) forKey:@"UserId"];
    [reqData setObject:@(self.service.id) forKey:@"ServiceId"];
    [reqData setObject:self.nameTxt.text forKey:@"Title"];
    [reqData setObject:self.originalPriceTxt.text forKey:@"OldPrice"];
    [reqData setObject:self.saleOffTxt.text forKey:@"Price"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_SERVICES_CREATE]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createServiceFinish:)];
    [request setDidFailSelector:@selector(createServiceFail:)];
    [request startAsynchronous];
}

- (void)createServiceFinish:(ASIHTTPRequest *)request
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

- (void)createServiceFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加服务失败，请重试！"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameTxt =  [UITextField plainTextField:CGRectMake(kMargin,
                                                           self.topBarOffset + kMargin,
                                                           WIDTH(self.view) - 2 * kMargin,
                                                           40)
                                    leftPadding:kMargin];
    self.nameTxt.font = [UIFont systemFontOfSize:14];
    self.nameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxt.backgroundColor = [UIColor whiteColor];
    self.nameTxt.placeholder = @"服务名称";
    [self.view addSubview:self.nameTxt];
    
    self.originalPriceTxt =  [UITextField plainTextField:CGRectMake(kMargin ,
                                                           MaxY(self.nameTxt)+ kMargin,
                                                           WIDTH(self.nameTxt),
                                                           40)
                                    leftPadding:kMargin];
    self.originalPriceTxt.font = [UIFont systemFontOfSize:14];
    self.originalPriceTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.originalPriceTxt.backgroundColor = [UIColor whiteColor];
    self.originalPriceTxt.keyboardType = UIKeyboardTypeDecimalPad;
    self.originalPriceTxt.placeholder = @"原价";
    [self.originalPriceTxt addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.originalPriceTxt];
    
    self.saleOffTxt =  [UITextField plainTextField:CGRectMake(kMargin ,
                                                              MaxY(self.originalPriceTxt)+ kMargin,
                                                              WIDTH(self.nameTxt),
                                                              40)
                                    leftPadding:kMargin];
    self.saleOffTxt.font = [UIFont systemFontOfSize:14];
    self.saleOffTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.saleOffTxt.backgroundColor = [UIColor whiteColor];
    self.saleOffTxt.keyboardType = UIKeyboardTypeDecimalPad;
    self.saleOffTxt.placeholder = @"折扣";
    [self.saleOffTxt addTarget:self
                              action:@selector(textFieldDidChange)
                    forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.saleOffTxt];
    
    self.finalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(kMargin,MaxY(self.saleOffTxt) + kMargin, WIDTH(self.nameTxt), 40)];
    self.finalPriceLbl.backgroundColor = [UIColor clearColor];
    self.finalPriceLbl.textColor = [UIColor redColor];
    self.finalPriceLbl.font = [UIFont boldSystemFontOfSize:20];
    self.finalPriceLbl.text = @"";
    self.finalPriceLbl.textAlignment = NSTextAlignmentCenter;;
    [self.view addSubview:self.finalPriceLbl];

    if (!self.service) {
        self.service = [Service new];
        self.service.id = 0;
        self.title = @"添加服务";
    } else {
        self.nameTxt.text = self.service.name;
        self.originalPriceTxt.text = [NSString stringWithFormat:@"%.1f", self.service.originalPrice];
        self.saleOffTxt.text = [NSString stringWithFormat:@"%.1f", self.service.salePrice];
        self.title = @"编辑服务";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)textFieldDidChange
{
    self.finalPriceLbl.text = [NSString stringWithFormat:@"最终价格: ￥%.2f",[self.originalPriceTxt.text floatValue] * [self.saleOffTxt.text floatValue]];
}
@end
