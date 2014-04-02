//
//  AppointmentPreviewViewController.m
//  WelHair
//
//  Created by lu larry on 3/12/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OrderPreviewViewController.h"
#import "AddressListViewController.h"
#import "AddressView.h"

@interface OrderPreviewViewController ()<AddressPickDeleate>
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) AddressView *addressView;
@property (nonatomic, strong) Address *address;
@end

@implementation OrderPreviewViewController

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

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.address = [FakeDataHelper getFakeDefaultAddress];
    self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(15, self.topBarOffset, 290, 80)];
    [self.addressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickAddress)]];
    [self.view addSubview:self.addressView];
    
    if(!self.address){
        self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addressBtn.frame = self.addressView.frame;
        NSString *img = self.isAddressFilled ?@"OrderPreviewViewController_AddressBtn": @"OrderPreviewViewController_AddressTempBtn";
        [self.addressBtn setBackgroundImage:[UIImage imageNamed: img] forState:UIControlStateNormal];
        [self.addressBtn addTarget:self action:@selector(pickAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addressBtn];
    }else{
        [self setupAddressView];
    }

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MaxY(self.addressView), 320, 287)];
    imgView.image =[UIImage imageNamed:@"OrderPreviewViewController_TempBg"];
    [self.view addSubview:imgView];
    

    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  self.topBarOffset + [self contentHeightWithNavgationBar:YES withBottomBar:YES],
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight )];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
}

- (void)setupAddressView
{
    [self.addressView setup:self.address editable:NO selectable:NO];
}

- (void)pickAddress
{
    AddressListViewController *vc = [AddressListViewController new];
    vc.delegate = self;
    vc.pickedAddress = self.address;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitClick:(id)sender
{
    if(self.isAddressFilled){
        [SVProgressHUD showSuccessWithStatus:@"去支付宝支付" duration:1];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"请填写地址" duration:1];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPickAddress:(Address *)address
{
    self.addressBtn.hidden = address != nil;
    self.address = address;
    [self setupAddressView];
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
