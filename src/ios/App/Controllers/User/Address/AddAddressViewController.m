//
//  StaffAddServiceViewController.m
//  WelHair
//
//  Created by lu larry on 3/16/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AddAddressViewController.h"

@interface  AddAddressViewController()
@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *phoneTxt;
@property (nonatomic, strong) UITextField *emailTxt;
@property (nonatomic, strong) UITextField *addressTxt;
@end

@implementation AddAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加收货地址";
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
    [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float margin = 10;
    self.nameTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                           self.topBarOffset +  margin,
                                                           WIDTH(self.view) - 2 * margin,
                                                           40)
                                    leftPadding:margin];
    self.nameTxt.font = [UIFont systemFontOfSize:14];
    self.nameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxt.backgroundColor = [UIColor whiteColor];
    self.nameTxt.placeholder = @"收件人";
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
    [self.view addSubview:self.phoneTxt];
    
    self.emailTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                              MaxY(self.phoneTxt)+ margin,
                                                              WIDTH(self.nameTxt),
                                                              40)
                                       leftPadding:margin];
    self.emailTxt.font = [UIFont systemFontOfSize:14];
    self.emailTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTxt.backgroundColor = [UIColor whiteColor];
    self.emailTxt.placeholder = @"邮箱";
    [self.view addSubview:self.emailTxt];
    
    self.addressTxt = [[UITextField alloc] initWithFrame:CGRectMake(margin ,
                                                              MaxY(self.emailTxt)+ margin,
                                                              WIDTH(self.nameTxt),
                                                              40)];
    self.addressTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addressTxt.backgroundColor = [UIColor whiteColor];
    self.addressTxt.font = [UIFont systemFontOfSize:14];
    self.addressTxt.backgroundColor = [UIColor whiteColor];
    self.addressTxt.placeholder = @"详细地址";
    [self.view addSubview:self.addressTxt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
