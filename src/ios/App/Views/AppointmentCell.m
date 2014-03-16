//
//  AppointmentCell.m
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AppointmentCell.h"
#import "UIImageView+WebCache.h"
#import <AMRatingControl.h>
#import "Staff.h"
#import "CircleImageView.h"

@interface AppointmentCell()

@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@end

@implementation AppointmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        
        self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 10,
                                                                 Y(self.imgView),
                                                                 150,
                                                                 20)];
        self.staffNameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.staffNameLbl.numberOfLines = 2;
        self.staffNameLbl.backgroundColor = [UIColor clearColor];
        self.staffNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.staffNameLbl];
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                    MaxY(self.staffNameLbl),
                                                                    WIDTH(self.staffNameLbl),
                                                                    HEIGHT(self.imgView)/2)];
        self.datetimeLbl.font = [UIFont systemFontOfSize:12];
        self.datetimeLbl.numberOfLines = 2;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor grayColor];
        [self addSubview:self.datetimeLbl];
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl) + 5,
                                                                    MaxY(self.staffNameLbl),
                                                                    50,
                                                                    HEIGHT(self.staffNameLbl))];
        self.priceLbl.font = [UIFont systemFontOfSize:12];
        self.priceLbl.numberOfLines = 2;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor blackColor];
        [self addSubview:self.priceLbl];
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.datetimeLbl) + 5,
                                                                  MaxY(self.datetimeLbl),
                                                                  50,
                                                                  HEIGHT(self.datetimeLbl))];
        self.statusLbl.font = [UIFont systemFontOfSize:12];
        self.statusLbl.numberOfLines = 2;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor greenColor];
        [self addSubview:self.statusLbl];

        UIView *linerView = [[UIView alloc] initWithFrame:CGRectMake(20, MaxY(self.imgView) + 5, 280, 1)];
        linerView.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:linerView];
        
        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 ,
                                                                      MaxY(linerView) ,
                                                                      200,
                                                                      HEIGHT(self.staffNameLbl))];
        self.groupNameLbl.font = [UIFont boldSystemFontOfSize:12];
        self.groupNameLbl.numberOfLines = 2;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.groupNameLbl];
        
        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.groupNameLbl) ,
                                                                     MaxY(self.groupNameLbl),
                                                                     WIDTH(self.groupNameLbl),
                                                                     HEIGHT(self.groupNameLbl))];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        self.addressLbl.numberOfLines = 2;
        self.addressLbl.backgroundColor = [UIColor clearColor];
        self.addressLbl.textColor = [UIColor grayColor];
        [self addSubview:self.addressLbl];

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(X(self.statusLbl) , Y(self.groupNameLbl) + 10 , 50, 20)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.tag = 0;
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:cancelBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Appointment *)appointment;
{
    Staff *staff = [FakeDataHelper getFakeStaffList][0];
    [self.imgView setImageWithURL:[NSURL URLWithString: staff.avatorUrl]];
    self.staffNameLbl.text = @"高级总监";
    self.groupNameLbl.text = staff.groupName;
    self.datetimeLbl.text = @"2014-3-10 09:30";
    self.addressLbl.text = @"新泺大街11号";
    self.priceLbl.text = @"￥100";
    self.statusLbl.text = @"预约成功";
}

- (void)cancelClick
{
    [SVProgressHUD showSuccessWithStatus:@"取消预订" duration:1];
}

@end