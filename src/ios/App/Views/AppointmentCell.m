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

#import "AppointmentCell.h"
#import "CircleImageView.h"
#import "Staff.h"
#import "User.h"
#import "UserManager.h"

@interface AppointmentCell()

@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UILabel *serviceLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) Appointment *appointment;

@end

@implementation AppointmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        topBorder.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:topBorder];

        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 130)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];

        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"fafafa"] CGColor];
        self.imgView.layer.borderWidth = 2;
        [contentView addSubview:self.imgView];
        
        self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                      Y(self.imgView),
                                                                      120,
                                                                      HEIGHT(self.imgView) / 3)];
        self.staffNameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.staffNameLbl.numberOfLines = 1;
        self.staffNameLbl.backgroundColor = [UIColor clearColor];
        self.staffNameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [contentView addSubview:self.staffNameLbl];
        
        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.staffNameLbl),
                                                                      MaxY(self.staffNameLbl),
                                                                      WIDTH(self.staffNameLbl),
                                                                      HEIGHT(self.imgView) / 3)];
        self.groupNameLbl.font = [UIFont boldSystemFontOfSize:12];
        self.groupNameLbl.numberOfLines = 1;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        [contentView addSubview:self.groupNameLbl];

        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.staffNameLbl),
                                                                    MaxY(self.groupNameLbl),
                                                                    WIDTH(self.staffNameLbl),
                                                                    HEIGHT(self.imgView) / 3)];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        self.addressLbl.numberOfLines = 1;
        self.addressLbl.backgroundColor = [UIColor clearColor];
        self.addressLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        [contentView addSubview:self.addressLbl];
        
      
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl) + 5,
                                                                    Y(self.staffNameLbl),
                                                                    100,
                                                                    HEIGHT(self.staffNameLbl))];
        self.priceLbl.font = [UIFont boldSystemFontOfSize:12];
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.textAlignment = TextAlignmentRight;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor colorWithHexString:@"206ba5"];
        [contentView addSubview:self.priceLbl];


        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl) + 5,
                                                                   MaxY(self.priceLbl),
                                                                   100,
                                                                   HEIGHT(self.staffNameLbl))];
        self.statusLbl.font = [UIFont boldSystemFontOfSize:12];
        self.statusLbl.numberOfLines = 2;
        self.statusLbl.textAlignment = TextAlignmentRight;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor colorWithHexString:@"4CD964"];
        [contentView addSubview:self.statusLbl];

        UIView *speBorder = [[UIView alloc] initWithFrame:CGRectMake(20, MaxY(self.addressLbl) + 10, 284, 1)];
        speBorder.backgroundColor = [UIColor colorWithHexString:@"e7e6e4"];
        [contentView addSubview:speBorder];

        self.serviceLbl = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    MaxY(speBorder) + 5,
                                                                    200,
                                                                    HEIGHT(self.priceLbl))];
        self.serviceLbl.font = [UIFont boldSystemFontOfSize:12];
        self.serviceLbl.textAlignment = TextAlignmentLeft;
        self.serviceLbl.numberOfLines = 1;
        self.serviceLbl.backgroundColor = [UIColor clearColor];
        self.serviceLbl.textColor = [UIColor colorWithHexString:@"4b4b4b"];
        [contentView addSubview:self.serviceLbl];

        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     MaxY(self.serviceLbl),
                                                                     WIDTH(self.serviceLbl),
                                                                     HEIGHT(self.serviceLbl))];
        self.datetimeLbl.font = [UIFont boldSystemFontOfSize:12];
        self.datetimeLbl.textAlignment = TextAlignmentLeft;
        self.datetimeLbl.numberOfLines = 1;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor colorWithHexString:@"4b4b4b"];
        [contentView addSubview:self.datetimeLbl];


        self.actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, MaxY(speBorder) + 10, 60, 25)];
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.actionBtn.tag = 0;
        [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [self.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.actionBtn];

        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(175 , MaxY(speBorder) + 10, 60, 25)];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.cancelBtn.tag = 0;
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [self.cancelBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.cancelBtn];

        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(contentView) + 1, 320, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:bottomBorder];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Appointment *)appointment;
{
    self.appointment = appointment;

    User *currentUser = [[UserManager SharedInstance] userLogined];

    if (currentUser.role == WHStaff && appointment.staff.id == currentUser.id) {
        self.staffNameLbl.text = appointment.client.nickname;
        [self.imgView setImageWithURL:appointment.client.avatarUrl];
    } else {
        self.staffNameLbl.text = appointment.staff.name;
        [self.imgView setImageWithURL:appointment.staff.avatorUrl];
    }

    self.groupNameLbl.text = appointment.staff.group.name;
    self.addressLbl.text = appointment.staff.group.address;
    self.serviceLbl.text = [NSString stringWithFormat:@"项目：%@", appointment.service.name];
    self.datetimeLbl.text = [NSString stringWithFormat:@"时间：%@", [[NSDate dateWithHMFormatter] stringFromDate:appointment.date]];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", appointment.price];


    switch (appointment.status) {
        case WHApppointmentStatusPending: {
            self.statusLbl.hidden = true;
            self.cancelBtn.hidden = YES;

            self.actionBtn.hidden = NO;
            self.actionBtn.tag = 1;
            [self.actionBtn setTitle:@"付款" forState:UIControlStateNormal];
            break;
        }
        case WHApppointmentStatusPaid: {
            if (currentUser.role == WHStaff && appointment.staff.id == currentUser.id) {
                self.statusLbl.hidden = true;

                self.cancelBtn.hidden = NO;
                [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];

                self.actionBtn.hidden = NO;
                self.actionBtn.tag = 2;
                [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
            } else {
                self.statusLbl.hidden = NO;
                self.cancelBtn.hidden = YES;
                self.actionBtn.hidden = YES;
                self.statusLbl.text = @"已付款";
            }
            break;
        }
        case WHApppointmentStatusCompleted: {
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"已完成";
            self.cancelBtn.hidden = YES;

            if (currentUser.role == WHStaff && appointment.staff.id == currentUser.id) {
                self.actionBtn.tag = 3;
                [self.actionBtn setTitle:@"效果图" forState:UIControlStateNormal];
            } else {
                self.actionBtn.tag = 4;

                if (appointment.isLiked) {
                    [self.actionBtn setTitle:@"已赞" forState:UIControlStateNormal];
                    self.actionBtn.enabled = false;
                    [self.actionBtn setBackgroundColor:[UIColor lightGrayColor]];
                } else {
                    [self.actionBtn setTitle:@"赞" forState:UIControlStateNormal];
                }
            }
            break;
        }
        case WHApppointmentStatusCancelled: {
            self.statusLbl.hidden = NO;
            self.cancelBtn.hidden = YES;
            self.actionBtn.hidden = YES;
            self.statusLbl.text = @"已取消";
            break;
        }
        default: {
            self.statusLbl.hidden = NO;
            self.cancelBtn.hidden = YES;
            self.actionBtn.hidden = YES;
            break;
        }
    }
}

- (void)actionClick:(UIButton *)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    if (sender.tag == 0) {
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:[NSString stringWithFormat:@"%d", WHApppointmentStatusCancelled] forKey:@"Status"];

        ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_APPOINTMENTS_UPDATE, self.appointment.id]]
                                                                   andData:reqData];

        if (self.baseController) {
            [self.baseController.requests addObject:request];
        }

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(updateAppointmentFinish:)];
        [request setDidFailSelector:@selector(updateAppointmentFail:)];
        [request startAsynchronous];
    }

    if (sender.tag == 1) {
        [SVProgressHUD showSuccessWithStatus:@"去支付宝了"];
    }

    if (sender.tag == 2) {
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:[NSString stringWithFormat:@"%d", WHApppointmentStatusCompleted] forKey:@"Status"];

        ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_APPOINTMENTS_UPDATE, self.appointment.id]]
                                                                   andData:reqData];

        if (self.baseController) {
            [self.baseController.requests addObject:request];
        }

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(updateAppointmentFinish:)];
        [request setDidFailSelector:@selector(updateAppointmentFail:)];
        [request startAsynchronous];
    }

    if (sender.tag == 3) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOTO_HAIR_RECORD_VIEW object:self.appointment userInfo:nil];
    }

    if (sender.tag == 4) {
        [SVProgressHUD dismiss];

        self.appointment.isLiked = !self.appointment.isLiked;
        [self.actionBtn setTitle:self.appointment.isLiked ? @"已赞" : @"赞" forState:UIControlStateNormal];
        if(self.appointment.isLiked){
            self.actionBtn.enabled = false;
            [self.actionBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:[NSString stringWithFormat:@"%d", self.appointment.isLiked ? 1 : 0] forKey:@"IsLiked"];

        ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_APPOINTMENTS_UPDATE, self.appointment.id]]
                                                                   andData:reqData];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(likeStaffFinish:)];
        [request setDidFailSelector:@selector(likeStaffFail:)];
        if (self.baseController) {
            [self.baseController.requests addObject:request];
        }
        [request startAsynchronous];
    }
}

- (void)likeStaffFinish:(ASIHTTPRequest *)request
{
    debugLog(@"likeStaffFinish %@",request.responseString);
}

- (void)likeStaffFail:(ASIHTTPRequest *)request
{
    debugLog(@"likeStaffFail %@",request.responseString);
}

- (void)updateAppointmentFinish:(ASIHTTPRequest *)request
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
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_APPOINTMENT object:nil];
            [SVProgressHUD showSuccessWithStatus:@"操作成功！"];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

- (void)updateAppointmentFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"操作失败，请重试！"];
}

@end