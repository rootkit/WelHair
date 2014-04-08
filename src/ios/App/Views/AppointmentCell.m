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
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor blackColor];
        [self addSubview:self.priceLbl];
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl) + 5,
                                                                     MaxY(self.priceLbl),
                                                                     WIDTH(self.priceLbl),
                                                                     HEIGHT(self.priceLbl))];
        self.datetimeLbl.font = [UIFont systemFontOfSize:12];
        self.datetimeLbl.textAlignment = NSTextAlignmentRight;
        self.datetimeLbl.numberOfLines = 2;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor grayColor];
        [self addSubview:self.datetimeLbl];
        

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(245 , Y(self.addressLbl) , 60,25 )];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
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
    [self.imgView setImageWithURL:staff.avatorUrl];
    self.staffNameLbl.text = @"高级总监";
    self.groupNameLbl.text = staff.group.name;
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