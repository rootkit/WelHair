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

#import "AddressListViewController.h"
#import "AddressView.h"
#import "OrderPreviewViewController.h"
#import "UserManager.h"

@interface OrderPreviewViewController () <AddressPickDeleate>

@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) AddressView *addressView;
@property (nonatomic, strong) Address *address;

@end

@implementation OrderPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单预览";

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

    self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(15, self.topBarOffset+10, 290, 80)];
    [self.addressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickAddress)]];
    [self.view addSubview:self.addressView];

    if(!self.address) {
        self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addressBtn.frame = self.addressView.frame;
        NSString *img = @"OrderPreviewViewController_AddressTempBtn";
        [self.addressBtn setBackgroundImage:[UIImage imageNamed: img] forState:UIControlStateNormal];
        [self.addressBtn addTarget:self action:@selector(pickAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addressBtn];
    } else {
        [self setupAddressView];
    }

    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(self.addressView) + 5, WIDTH(self.addressView), 44)];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    cellView.layer.borderWidth = 1;
    cellView.layer.cornerRadius = 3;
    [self.view addSubview:cellView];

    UILabel *cellInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, HEIGHT(cellView))];
    cellInfoLbl.backgroundColor = [UIColor clearColor];
    cellInfoLbl.textColor = [UIColor grayColor];
    cellInfoLbl.font = [UIFont boldSystemFontOfSize:14];
    cellInfoLbl.text = @"快递方式";
    cellInfoLbl.textAlignment = TextAlignmentLeft;
    [cellView addSubview:cellInfoLbl];

    UILabel *cellValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 210, HEIGHT(cellView))];
    cellValueLbl.backgroundColor = [UIColor clearColor];
    cellValueLbl.textColor = [UIColor colorWithHexString:@"777"];
    cellValueLbl.font = [UIFont boldSystemFontOfSize:12];
    cellValueLbl.text = @"申通快递";
    cellValueLbl.textAlignment = TextAlignmentRight;
    [cellView addSubview:cellValueLbl];

    UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, MaxY(cellView) + 5, 300, 350)];
    [self.view addSubview:detailView];

    UIImageView *barImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    barImgView.image =[UIImage imageNamed:@"OrderPreviewViewController_BgBar"];
    [detailView addSubview:barImgView];

    UIView *bgImgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 290, 300)];
    [detailView addSubview:bgImgView];

    UILabel *groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 170, 20)];
    groupNameLbl.font = [UIFont systemFontOfSize:14];
    groupNameLbl.numberOfLines = 2;
    groupNameLbl.backgroundColor = [UIColor clearColor];
    groupNameLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    groupNameLbl.text = self.order.product.group.name;
    [detailView addSubview:groupNameLbl];

    UIView *seperaterView = [[UIView alloc] initWithFrame:CGRectMake(X(groupNameLbl), MaxY(groupNameLbl) + 10, 280, 1)];
    seperaterView.backgroundColor = [UIColor lightGrayColor];
    [detailView addSubview:seperaterView];

    UIImageView  *avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, MaxY(seperaterView) + 10, 60, 60)];
    [detailView addSubview:avatorImgView];
    avatorImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
    avatorImgView.layer.borderWidth = 0;
    [avatorImgView setImageWithURL:[NSURL URLWithString:self.order.product.imgUrlList[0]]];

    UILabel *productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, Y(avatorImgView), 110, HEIGHT(avatorImgView)*2/3)];
    productNameLbl.font = [UIFont systemFontOfSize:14];
    productNameLbl.numberOfLines = 2;
    productNameLbl.backgroundColor = [UIColor clearColor];
    productNameLbl.textColor = [UIColor blackColor];
    productNameLbl.text = self.order.product.name;
    [detailView addSubview:productNameLbl];

    UILabel *productSpecLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, MaxY(productNameLbl), 160, HEIGHT(avatorImgView)*1/3)];
    productSpecLbl.font = [UIFont systemFontOfSize:12];
    productSpecLbl.numberOfLines = 2;
    productSpecLbl.backgroundColor = [UIColor clearColor];
    productSpecLbl.textColor = [UIColor lightGrayColor];
    productSpecLbl.text = [self.order selectedSpecStr];
    [detailView addSubview:productSpecLbl];

    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(productNameLbl) + 5, Y(productNameLbl), 100, HEIGHT(avatorImgView)*2/3)];
    priceLbl.font = [UIFont systemFontOfSize:14];
    priceLbl.numberOfLines = 1;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textAlignment = TextAlignmentRight;
    priceLbl.textColor = [UIColor colorWithHexString:@"777"];
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", self.order.singleProductPrice];
    [detailView addSubview:priceLbl];

    UILabel *productCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(productSpecLbl) + 5, Y(productSpecLbl), 50, HEIGHT(avatorImgView)/3)];
    productCountLbl.font = [UIFont systemFontOfSize:14];
    productCountLbl.numberOfLines = 1;
    productCountLbl.textAlignment = TextAlignmentRight;
    productCountLbl.backgroundColor = [UIColor clearColor];
    productCountLbl.textColor = [UIColor colorWithHexString:@"777"];
    productCountLbl.text = [NSString stringWithFormat:@"%d", self.order.count];
    [detailView addSubview:productCountLbl];

    seperaterView = [[UIView alloc] initWithFrame:CGRectMake(X(seperaterView), MaxY(productCountLbl) + 10, 280, 1)];
    seperaterView.backgroundColor = [UIColor colorWithHexString:@"ddd"];
    [detailView addSubview:seperaterView];

    UILabel *freightPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(seperaterView), MaxY(seperaterView) + 10, 120, 20)];
    freightPriceLbl.font = [UIFont systemFontOfSize:12];
    freightPriceLbl.numberOfLines = 1;
    freightPriceLbl.backgroundColor = [UIColor clearColor];
    freightPriceLbl.textAlignment = TextAlignmentLeft;
    freightPriceLbl.textColor = [UIColor colorWithHexString:@"777"];
    freightPriceLbl.text = [NSString stringWithFormat:@"运费：￥%.2f", 10.0];
    [detailView addSubview:freightPriceLbl];

    UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(freightPriceLbl) + 5, MinY(freightPriceLbl), 155, 20)];
    totalPriceLbl.font = [UIFont systemFontOfSize:14];
    totalPriceLbl.numberOfLines = 1;
    totalPriceLbl.textAlignment = TextAlignmentRight;
    totalPriceLbl.backgroundColor = [UIColor clearColor];
    totalPriceLbl.textColor = [UIColor blackColor];
    totalPriceLbl.text = [NSString stringWithFormat:@"总价: ￥%.2f",self.order.price + 10.0];
    [detailView addSubview:totalPriceLbl];

    float scrollOffsetY = MaxY(freightPriceLbl) + 20;

    float detailHeight =  MIN(scrollOffsetY, [self contentHeightWithNavgationBar:YES withBottomBar:YES] - HEIGHT(self.addressView) - 5);
    detailView.frame = CGRectMake(10, MaxY(cellView) + 5, 300, detailHeight);
    detailView.contentSize = CGSizeMake(300, detailHeight);

    bgImgView.frame = CGRectMake(5, 5, 290, detailView.contentSize.height - 5);

    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:bgImgView.bounds];
    bgImg.image = [[UIImage imageNamed:@"OrderPreviewViewController_Bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    [bgImgView insertSubview:bgImg atIndex:0];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset + [self contentHeightWithNavgationBar:YES withBottomBar:YES], WIDTH(self.view), kBottomBarHeight )];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
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
    vc.isPickingAddress = YES;
    vc.pickedAddress = self.address;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitClick:(id)sender
{
    if (![self checkLogin]) {
        return;
    }

    if (self.order.address) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:[NSString stringWithFormat:@"%d",[UserManager SharedInstance].userLogined.id] forKey:@"UserId"];
        [reqData setObject:[NSString stringWithFormat:@"%d", self.order.address.id] forKey:@"AddressId"];
        [reqData setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"PayType"];
        [reqData setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Distribution"];

        NSMutableDictionary *reqProduct = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqProduct setObject:[NSString stringWithFormat:@"%d", self.order.product.id] forKey:@"GoodsId"];
        [reqProduct setObject:[NSString stringWithFormat:@"%d", self.order.count] forKey:@"Num"];
        [reqProduct setObject:[NSString stringWithFormat:@"%d", self.order.product.group.id] forKey:@"CompanyId"];
        [reqProduct setObject:[NSString stringWithFormat:@"%d", self.order.productId] forKey:@"ProductId"];


        [reqData setObject:@[reqProduct] forKey:@"Items"];


        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_ORDER_CREATE]
                                                                    andData:reqData];
        [self.requests addObject:request];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(createOrderFinish:)];
        [request setDidFailSelector:@selector(createOrderFail:)];
        [request startAsynchronous];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请填写地址" duration:1];
    }
}

- (void)createOrderFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"order"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

            NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];

            NSDictionary *newOrder = [responseMessage objectForKey:@"order"];
            ASIFormDataRequest *requestPay = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_ORDER_PAY, [[newOrder objectForKey:@"OrderId"] intValue]]]
                                                                        andData:reqData];
            [self.requests addObject:requestPay];

            [requestPay setDelegate:self];
            [requestPay setDidFinishSelector:@selector(actionFinish:)];
            [requestPay setDidFailSelector:@selector(actionFail:)];
            [requestPay startAsynchronous];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"添加订单失败，请重试！"];
}

- (void)createOrderFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加订单失败，请重试！"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didPickAddress:(Address *)address
{
    self.addressBtn.hidden = address != nil;
    self.address = address;

    self.order.address = address;

    [self setupAddressView];
}

- (void)actionFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 0) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"操作成功！"];

            [self.navigationController popViewControllerAnimated:NO];
            if (self.productDetailController) {
                [self.productDetailController pushToOrderList];
            }

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

- (void)actionFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

@end
