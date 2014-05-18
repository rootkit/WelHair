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

#import "StaffRevenuCell.h"
#import "CircleImageView.h"
#import "Staff.h"
@interface StaffRevenuCell ()

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) CircleImageView *clientAvatorImg;
@property (nonatomic, strong) UILabel *clientNameLbl;
@property (nonatomic, strong) UILabel *serviceNameLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@end



@implementation StaffRevenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clientAvatorImg = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:self.clientAvatorImg];
        self.clientAvatorImg.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.clientAvatorImg.layer.borderWidth = 2;
        self.clientNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                       MaxY(self.clientAvatorImg),
                                                                       WIDTH(self.clientAvatorImg),
                                                                       20)];
        self.clientNameLbl.font = [UIFont boldSystemFontOfSize:12];
        self.clientNameLbl.numberOfLines = 1;
        self.clientNameLbl.textAlignment = NSTextAlignmentCenter;
        self.clientNameLbl.backgroundColor = [UIColor clearColor];
        self.clientNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.clientNameLbl];
        
        UIView *verticalLiner = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 80)];
        verticalLiner.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [self addSubview:verticalLiner];
        
        
        self.serviceNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(verticalLiner) +10,
                                                                      0,
                                                                      140,
                                                                      50)];
        self.serviceNameLbl.font = [UIFont systemFontOfSize:16];
        self.serviceNameLbl.numberOfLines = 2;
        self.serviceNameLbl.backgroundColor = [UIColor clearColor];
        self.serviceNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.serviceNameLbl];
        
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(verticalLiner) +10,
                                                                     MaxY(self.serviceNameLbl),
                                                                     WIDTH(self.serviceNameLbl),
                                                                     HEIGHT(self.serviceNameLbl))];
        self.datetimeLbl.font = [UIFont systemFontOfSize:14];
        self.datetimeLbl.numberOfLines = 1;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.datetimeLbl];
        
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.serviceNameLbl),
                                                                  0,
                                                                  80,
                                                                  50)];
        self.priceLbl.font = [UIFont systemFontOfSize:14];
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor blackColor];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLbl];
        
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.serviceNameLbl),
                                                                   MaxY(self.priceLbl),
                                                                   WIDTH(self.priceLbl),
                                                                   HEIGHT(self.priceLbl))];
        self.statusLbl.font = [UIFont systemFontOfSize:14];
        self.statusLbl.numberOfLines = 1;
        self.statusLbl.textAlignment = NSTextAlignmentRight;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.statusLbl];
        
        UIView *bottomLiner = [[UIView alloc] initWithFrame:CGRectMake(0, 99, WIDTH(self), 1)];
        bottomLiner.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [self addSubview:bottomLiner];
    }
    return self;
}


- (void)setup:(NSDictionary *)dic
{
    self.dataDic = dic;
    Staff *s =  [FakeDataHelper getFakeStaffList][0];
    [self.clientAvatorImg setImageWithURL:s.avatorUrl];
    self.clientNameLbl.text = @"客户名字";
    self.serviceNameLbl.text =@"精剪，剃须";
    self.priceLbl.text = @"+500";
    self.statusLbl.text= @"交易成功";
    self.datetimeLbl.text = @"2014-1-1";
    
}

@end
