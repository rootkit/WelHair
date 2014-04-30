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

#import "AddAddressViewController.h"
#import "City.h"
#import "CityListViewController.h"
#import "GCPlaceholderTextView.h"

@interface  AddAddressViewController() <CityPickViewDelegate>

@property (nonatomic, strong) City * selectedCity;
@property (nonatomic, strong) UILabel * cityLbl;
@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *phoneTxt;
@property (nonatomic, strong) GCPlaceholderTextView *addressTxt;

@end

@implementation AddAddressViewController

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
    [self.addressTxt resignFirstResponder];
    [self.phoneTxt resignFirstResponder];

    bool valid = (self.addressTxt.text.length > 0 &&
                  self.selectedCity.id > 0 &&
                  self.nameTxt.text.length > 0);

    if (!valid) {
        [SVProgressHUD showSuccessWithStatus:@"请正确填写所有项目" duration:1];
        return;
    }

    if (![Util validPhoneNum:self.phoneTxt.text]) {
        [SVProgressHUD showSuccessWithStatus:@"手机号不合法" duration:1];
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.nameTxt.text forKey:@"ShippingName"];
    [reqData setObject:self.phoneTxt.text forKey:@"Mobile"];
    [reqData setObject:@(self.address ? self.address.id : 0) forKey:@"AddressId"];
    [reqData setObject:@(self.selectedCity.id) forKey:@"City"];
    [reqData setObject:self.addressTxt.text forKey:@"Address"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_ADDRESSES_CREATE]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createAddressFinish:)];
    [request setDidFailSelector:@selector(createAddressFail:)];
    [request startAsynchronous];
}

- (void)createAddressFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"address"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_ADDRESSLIST object:nil];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

- (void)createAddressFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float margin = 10;

    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.topBarOffset +  margin, WIDTH(self.view) - 2 * margin, 40)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cityView];
    [cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickCity)]];

    self.cityLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.cityLbl.font = [UIFont systemFontOfSize:14];
    self.cityLbl.textAlignment = NSTextAlignmentLeft;
    self.cityLbl.backgroundColor = [UIColor clearColor];
    self.cityLbl.textColor = [UIColor lightGrayColor];
    self.cityLbl.layer.cornerRadius = 5;
    self.cityLbl.text = @"选择城市";
    [cityView addSubview:self.cityLbl];


    self.nameTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                           MaxY(cityView) + margin,
                                                           WIDTH(self.view) - 2 * margin,
                                                           40)
                                    leftPadding:margin];
    self.nameTxt.font = [UIFont systemFontOfSize:14];
    self.nameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxt.backgroundColor = [UIColor whiteColor];
    self.nameTxt.placeholder = @"收件人";
    self.nameTxt.layer.cornerRadius = 5;
    [self.view addSubview:self.nameTxt];
    
    self.phoneTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                                    MaxY(self.nameTxt)+ margin,
                                                                    WIDTH(self.nameTxt),
                                                                    40)
                                             leftPadding:margin];
    self.phoneTxt.font = [UIFont systemFontOfSize:14];
    self.phoneTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneTxt.backgroundColor = [UIColor whiteColor];
    self.phoneTxt.placeholder = @"电话";
    self.phoneTxt.layer.cornerRadius = 5;
    self.phoneTxt.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:self.phoneTxt];
    
    self.addressTxt = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(margin ,
                                                                   MaxY(self.phoneTxt)+ margin,
                                                                   WIDTH(self.nameTxt),
                                                                    80)];
    self.addressTxt.backgroundColor = [UIColor whiteColor];
    self.addressTxt.font = [UIFont systemFontOfSize:14];
    self.addressTxt.backgroundColor = [UIColor whiteColor];
    self.addressTxt.placeholder = @" 详细地址";
    self.addressTxt.layer.cornerRadius = 5;
    [self.view addSubview:self.addressTxt];
    
    if(self.address){
        self.selectedCity = self.address.city;
        self.cityLbl.text = self.address.city.name;
        self.nameTxt.text = self.address.userName;
        self.phoneTxt.text = self.address.phoneNumber;
        self.addressTxt.text = self.address.detailAddress;
        self.title = @"编辑收货地址";
    }else{
        self.title = @"添加收货地址";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pickCity
{
    CityListViewController *picker = [CityListViewController new];
    picker.selectedCity = self.selectedCity;
    picker.delegate = self;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
}

- (void)didPickCity:(City *)city
{
    self.selectedCity = city;
    self.cityLbl.text = city.name;
}

@end
