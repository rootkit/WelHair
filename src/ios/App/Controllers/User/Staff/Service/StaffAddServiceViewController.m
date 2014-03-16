//
//  StaffAddServiceViewController.m
//  WelHair
//
//  Created by lu larry on 3/16/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "StaffAddServiceViewController.h"

@interface StaffAddServiceViewController ()
@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *originalPriceTxt;
@property (nonatomic, strong) UITextField *saleOffTxt;
@property (nonatomic, strong) UILabel *priceLbl;
@end

@implementation StaffAddServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加服务";
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
    self.nameTxt.placeholder = @"服务名称";
    [self.view addSubview:self.nameTxt];
    
    self.originalPriceTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                           MaxY(self.nameTxt)+ margin,
                                                           WIDTH(self.nameTxt),
                                                           40)
                                    leftPadding:margin];
    self.originalPriceTxt.font = [UIFont systemFontOfSize:14];
    self.originalPriceTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.originalPriceTxt.backgroundColor = [UIColor whiteColor];
    self.originalPriceTxt.placeholder = @"原价";
    [self.view addSubview:self.originalPriceTxt];
    
    self.saleOffTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                              MaxY(self.originalPriceTxt)+ margin,
                                                              WIDTH(self.nameTxt),
                                                              40)
                                    leftPadding:margin];
    self.saleOffTxt.font = [UIFont systemFontOfSize:14];
    self.saleOffTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.saleOffTxt.backgroundColor = [UIColor whiteColor];
    self.saleOffTxt.placeholder = @"折扣";
    [self.view addSubview:self.saleOffTxt];
    
    self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(margin ,
                                                              MaxY(self.saleOffTxt)+ margin,
                                                              WIDTH(self.nameTxt),
                                                              40)];
    self.priceLbl.backgroundColor = [UIColor clearColor];
    self.priceLbl.textColor = [UIColor grayColor];
    self.priceLbl.font = [UIFont systemFontOfSize:14];
    self.priceLbl.textAlignment = NSTextAlignmentLeft;;
    [self.view addSubview:self.priceLbl];
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
