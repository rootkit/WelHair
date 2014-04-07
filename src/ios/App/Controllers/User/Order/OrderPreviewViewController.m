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
    self.order = [FakeDataHelper getFakeOrderList][0];
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
    
    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, MaxY(self.addressView) + 5, 300, 150)];
    [self.view addSubview:detailView];
    UIImageView *barImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    barImgView.image =[UIImage imageNamed:@"OrderPreviewViewController_BgBar"];
    [detailView addSubview:barImgView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 290, 100)];
    bgImgView.image =[UIImage imageNamed:@"OrderPreviewViewController_Bg"];
    [detailView addSubview:bgImgView];
    
    UILabel *groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                        20,
                                                                        150,
                                                                        20)];
    groupNameLbl.font = [UIFont systemFontOfSize:16];
    groupNameLbl.numberOfLines = 2;
    groupNameLbl.backgroundColor = [UIColor clearColor];
    groupNameLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    groupNameLbl.text = self.order.group.name;
    [detailView addSubview:groupNameLbl];
    
    UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(groupNameLbl) + 5,
                                                                        Y(groupNameLbl),
                                                                        105,
                                                                        20)];
    totalPriceLbl.font = [UIFont systemFontOfSize:14];
    totalPriceLbl.numberOfLines = 1;
    totalPriceLbl.textAlignment = NSTextAlignmentRight;
    totalPriceLbl.backgroundColor = [UIColor clearColor];
    totalPriceLbl.textColor = [UIColor blackColor];
    totalPriceLbl.text = [NSString stringWithFormat:@"总价: ￥%.2f",self.order.price];
    [detailView addSubview:totalPriceLbl];
    
    UIView *seperaterView = [[UIView alloc] initWithFrame:CGRectMake(X(groupNameLbl),
                                                                     MaxY(groupNameLbl) + 10,
                                                                     280,
                                                                     1)];
    seperaterView.backgroundColor = [UIColor lightGrayColor];
    [detailView addSubview:seperaterView];
    
    UIImageView  *avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, MaxY(seperaterView) + 10, 60, 60)];
    [detailView addSubview:avatorImgView];
    avatorImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
    avatorImgView.layer.borderWidth = 2;
    
    UILabel *productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5,
                                                                      Y(avatorImgView),
                                                                      130,
                                                                      HEIGHT(avatorImgView)*2/3)];
    productNameLbl.font = [UIFont systemFontOfSize:14];
    productNameLbl.numberOfLines = 2;
    productNameLbl.backgroundColor = [UIColor clearColor];
    productNameLbl.textColor = [UIColor blackColor];
    productNameLbl.text = self.order.product.name;
    [detailView addSubview:productNameLbl];
    
    UILabel *productDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5,
                                                                  MaxY(productNameLbl),
                                                                  130,
                                                                  HEIGHT(avatorImgView)/3)];
    productDescLbl.font = [UIFont systemFontOfSize:12];
    productDescLbl.numberOfLines = 1;
    productDescLbl.backgroundColor = [UIColor clearColor];
    productDescLbl.textColor = [UIColor lightGrayColor];
    productDescLbl.text = @"300ml, 亮发"; //self.order.product.description;
    [detailView addSubview:productDescLbl];
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(productNameLbl) + 5,
                                                                  Y(productNameLbl),
                                                                  60,
                                                                  HEIGHT(avatorImgView)*2/3)];
    priceLbl.font = [UIFont systemFontOfSize:14];
    priceLbl.numberOfLines = 1;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", self.order.product.price];
    [detailView addSubview:priceLbl];
    

    UILabel *productCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(productDescLbl) + 5,
                                                                         Y(productDescLbl),
                                                                         60,
                                                                         HEIGHT(avatorImgView)/3)];
    productCountLbl.font = [UIFont systemFontOfSize:14];
    productCountLbl.numberOfLines = 1;
    productCountLbl.textAlignment = NSTextAlignmentRight;
    productCountLbl.backgroundColor = [UIColor clearColor];
    productCountLbl.textColor = [UIColor lightGrayColor];
    productCountLbl.text = [NSString stringWithFormat:@"%d",self.order.count];
    [detailView addSubview:productCountLbl];
    
    float scrollOffsetY = MaxY(productCountLbl) + 10;
    
    float detailHeight =  MIN(scrollOffsetY, [self contentHeightWithNavgationBar:YES withBottomBar:YES] - HEIGHT(self.addressView) - 5);
    detailView.frame = CGRectMake(10, MaxY(self.addressView) + 5, 300, detailHeight);
    detailView.contentSize = CGSizeMake(300, detailHeight);
    bgImgView.frame = CGRectMake(5, 5, 290, detailView.contentSize.height - 5);
    
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
