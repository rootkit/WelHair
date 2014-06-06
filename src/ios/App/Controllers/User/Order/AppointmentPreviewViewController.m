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

#import "AppointmentPreviewViewController.h"
#import "CircleImageView.h"
#import "UserManager.h"

@interface AppointmentPreviewViewController ()

@end

@implementation AppointmentPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"预约信息";

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
    
    UIImageView *barImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.topBarOffset + 20, 300, 10)];
    barImgView.image =[UIImage imageNamed:@"OrderPreviewViewController_BgBar"];
    [self.view addSubview:barImgView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MaxY(barImgView)-5, 290, 100)];
    bgImgView.image =[UIImage imageNamed:@"OrderPreviewViewController_Bg"];
    [self.view addSubview:bgImgView];
    
     UIImageView  *avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(30, MaxY(barImgView) + 20, 60, 60)];
    [self.view addSubview:avatorImgView];
    avatorImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
    avatorImgView.layer.borderWidth = 0;
    [avatorImgView setImageWithURL:self.appointment.staff.avatorUrl];
    
    UILabel *staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5,
                                                             Y(avatorImgView),
                                                             130,
                                                             HEIGHT(avatorImgView)/3)];
    staffNameLbl.font = [UIFont systemFontOfSize:14];
    staffNameLbl.numberOfLines = 1;
    staffNameLbl.backgroundColor = [UIColor clearColor];
    staffNameLbl.textColor = [UIColor blackColor];
    staffNameLbl.text = self.appointment.staff.name;
    [self.view addSubview:staffNameLbl];
    
    UILabel *groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5,
                                                                 MaxY(staffNameLbl),
                                                                 130,
                                                                 HEIGHT(avatorImgView)/3)];
    groupLbl.font = [UIFont systemFontOfSize:14];
    groupLbl.numberOfLines = 1;
    groupLbl.backgroundColor = [UIColor clearColor];
    groupLbl.textColor = [UIColor blackColor];
    groupLbl.text = self.appointment.staff.group.name;
    [self.view addSubview:groupLbl];
    
    
    UILabel *groupAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5,
                                                                 MaxY(groupLbl),
                                                                 130,
                                                                 HEIGHT(avatorImgView)/3)];
    groupAddressLbl.font = [UIFont systemFontOfSize:14];
    groupAddressLbl.numberOfLines = 1;
    groupAddressLbl.backgroundColor = [UIColor clearColor];
    groupAddressLbl.textColor = [UIColor lightGrayColor];
    groupAddressLbl.text = self.appointment.staff.group.address;
    [self.view addSubview:groupAddressLbl];
    
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(staffNameLbl) + 5,
                                                                         Y(staffNameLbl),
                                                                         60,
                                                                         HEIGHT(avatorImgView)/3)];
    priceLbl.font = [UIFont systemFontOfSize:14];
    priceLbl.numberOfLines = 1;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", self.appointment.price];
    [self.view addSubview:priceLbl];
    
    
    UIView *seperaterView = [[UIView alloc] initWithFrame:CGRectMake(X(avatorImgView),
                                                                     MaxY(groupAddressLbl) + 10,
                                                                     WIDTH(self.view) - 2 * X(avatorImgView),
                                                                     1)];
    seperaterView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperaterView];
    
    UILabel *serviceNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(avatorImgView),
                                                                        MaxY(seperaterView) + 10,
                                                                        WIDTH(seperaterView),
                                                                        25)];
    serviceNameLbl.font = [UIFont systemFontOfSize:16];
    serviceNameLbl.backgroundColor = [UIColor clearColor];
    serviceNameLbl.textColor = [UIColor blackColor];
    serviceNameLbl.text =[NSString stringWithFormat:@"服务名称: %@", self.appointment.service.name];
    [self.view addSubview:serviceNameLbl];
    
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(serviceNameLbl),
                                                                 MaxY(serviceNameLbl),
                                                                 WIDTH(seperaterView),
                                                                 25)];
    dateLbl.font = [UIFont systemFontOfSize:16];
    dateLbl.backgroundColor = [UIColor clearColor];
    dateLbl.textColor = [UIColor blackColor];
    dateLbl.text = [NSString stringWithFormat:@"预约时间: %@", [[NSDate dateFormatter] stringFromDate:self.appointment.date]];
    [self.view addSubview:dateLbl];
    
    bgImgView.frame = CGRectMake(15, MaxY(barImgView)-5, 290, MaxY(dateLbl) + 10 - self.topBarOffset);
    
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

- (void)submitClick:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.appointment.staff.id] forKey:@"StaffId"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.appointment.service.id] forKey:@"ServiceId"];
    [reqData setObject:[[NSDate dateFormatter] stringFromDate:self.appointment.date] forKey:@"AppointmentDate"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_APPOINTMENTS_CREATE]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createAppointmentFinish:)];
    [request setDidFailSelector:@selector(createAppointmentFail:)];
    [request startAsynchronous];
}

- (void)createAppointmentFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"appointment"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD showSuccessWithStatus:@"添加预约成功！"];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_APPOINTMENTLIST object:nil];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"添加预约失败，请重试！"];
}

- (void)createAppointmentFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加预约失败，请重试！"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
