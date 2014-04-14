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

#import <AMRatingControl.h>
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
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) Appointment *appointment;

@end

@implementation AppointmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        [self addSubview:self.imgView];
        
        self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                      Y(self.imgView),
                                                                      120,
                                                                      HEIGHT(self.imgView)/2)];
        self.staffNameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.staffNameLbl.numberOfLines = 2;
        self.staffNameLbl.backgroundColor = [UIColor clearColor];
        self.staffNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.staffNameLbl];
        
        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                      MaxY(self.staffNameLbl),
                                                                      WIDTH(self.staffNameLbl),
                                                                      HEIGHT(self.imgView)/2)];
        self.groupNameLbl.font = [UIFont boldSystemFontOfSize:12];
        self.groupNameLbl.numberOfLines = 2;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.groupNameLbl];
        
        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.imgView) ,
                                                                    MaxY(self.imgView),
                                                                    200,
                                                                    HEIGHT(self.groupNameLbl))];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        self.addressLbl.numberOfLines = 2;
        self.addressLbl.backgroundColor = [UIColor clearColor];
        self.addressLbl.textColor = [UIColor grayColor];
        [self addSubview:self.addressLbl];
        
      
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl) + 5,
                                                                    Y(self.staffNameLbl),
                                                                    100,
                                                                    HEIGHT(self.staffNameLbl))];
        self.priceLbl.font = [UIFont systemFontOfSize:12];
        self.priceLbl.numberOfLines = 2;
        self.priceLbl.textAlignment = TextAlignmentRight;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor blackColor];
        [self addSubview:self.priceLbl];
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl) + 5,
                                                                     MaxY(self.priceLbl),
                                                                     WIDTH(self.priceLbl),
                                                                     HEIGHT(self.priceLbl))];
        self.datetimeLbl.font = [UIFont systemFontOfSize:12];
        self.datetimeLbl.textAlignment = TextAlignmentRight;
        self.datetimeLbl.numberOfLines = 2;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor grayColor];
        [self addSubview:self.datetimeLbl];

        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl) + 5,
                                                                   Y(self.addressLbl),
                                                                   100,
                                                                   HEIGHT(self.staffNameLbl))];
        self.statusLbl.font = [UIFont boldSystemFontOfSize:12];
        self.statusLbl.numberOfLines = 2;
        self.statusLbl.textAlignment = TextAlignmentRight;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor colorWithHexString:@"4CD964"];
        [self addSubview:self.statusLbl];


        self.actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(245 , Y(self.addressLbl), 60, 25)];
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.actionBtn.tag = 0;
        [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [self.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionBtn];
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

    self.staffNameLbl.text = appointment.staff.name;
    self.addressLbl.text = appointment.staff.group.address;
    self.groupNameLbl.text = appointment.staff.group.name;
    self.datetimeLbl.text = [[NSDate dateWithHMFormatter] stringFromDate:appointment.date];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", appointment.price];
    [self.imgView setImageWithURL:appointment.staff.avatorUrl];

    User *currentUser = [[UserManager SharedInstance] userLogined];

    switch (appointment.status) {
        case WHApppointmentStatusPending: {
            self.statusLbl.hidden = true;
            self.actionBtn.hidden = NO;
            self.actionBtn.tag = 1;
            [self.actionBtn setTitle:@"付款" forState:UIControlStateNormal];
            break;
        }
        case WHApppointmentStatusPaid: {
            if (currentUser.role == WHStaff) {
                self.statusLbl.hidden = true;
                self.actionBtn.hidden = NO;
                self.actionBtn.tag = 2;
                [self.actionBtn setTitle:@"完成" forState:UIControlStateNormal];
            } else {
                self.statusLbl.hidden = NO;
                self.actionBtn.hidden = YES;
                self.statusLbl.text = @"已付款";
            }
            break;
        }
        case WHApppointmentStatusCompleted: {
            self.statusLbl.hidden = NO;
            self.actionBtn.hidden = YES;
            self.statusLbl.text = @"已完成";
            break;
        }
        case WHApppointmentStatusCancelled: {
            self.statusLbl.hidden = NO;
            self.actionBtn.hidden = YES;
            self.statusLbl.text = @"已取消";
            break;
        }
        default:
            self.statusLbl.hidden = NO;
            self.actionBtn.hidden = YES;
            break;
    }
}

- (void)actionClick:(UIButton *)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    if (sender.tag == 2) {
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        [reqData setObject:[NSString stringWithFormat:@"%d", WHApppointmentStatusCompleted] forKey:@"Status"];

        ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_APPOINTMENTS_UPDATE, self.appointment.id]]
                                                                   andData:reqData];

        [request setDelegate:self];
        [request setDidFinishSelector:@selector(updateAppointmentFinish:)];
        [request setDidFailSelector:@selector(updateAppointmentFail:)];
        [request startAsynchronous];
    }
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