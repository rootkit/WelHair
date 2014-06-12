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

#import "CircleImageView.h"
#import "GroupRevenuCell.h"
#import "Staff.h"

@interface GroupRevenuCell ()

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) CircleImageView *clientAvatorImg;
@property (nonatomic, strong) UILabel *clientNameLbl;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *serviceNameLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@end

@implementation GroupRevenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.clientAvatorImg = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:self.clientAvatorImg];

        self.clientAvatorImg.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        [self.clientAvatorImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(staffTapped)]];
        self.clientAvatorImg.userInteractionEnabled = YES;
        self.clientAvatorImg.layer.borderWidth = 0;

        self.clientNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                 MaxY(self.clientAvatorImg) + 5,
                                                                 WIDTH(self.clientAvatorImg),
                                                                 20)];
        self.clientNameLbl.font = [UIFont boldSystemFontOfSize:10];
        self.clientNameLbl.numberOfLines = 1;
        self.clientNameLbl.textAlignment = NSTextAlignmentCenter;
        self.clientNameLbl.backgroundColor = [UIColor clearColor];
        self.clientNameLbl.textColor = [UIColor colorWithHexString:@"777"];
        [self addSubview:self.clientNameLbl];
        
        UIView *verticalLiner = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 80)];
        verticalLiner.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [self addSubview:verticalLiner];
        
        
        self.staffNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(verticalLiner) + 10, 10, 140, 40)];
        self.staffNameLbl.font = [UIFont systemFontOfSize:16];
        self.staffNameLbl.numberOfLines = 1;
        self.staffNameLbl.backgroundColor = [UIColor clearColor];
        self.staffNameLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
        [self addSubview:self.staffNameLbl];
        
        self.serviceNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(verticalLiner) + 10, MaxY(self.staffNameLbl), 140, 20)];
        self.serviceNameLbl.font = [UIFont systemFontOfSize:14];
        self.serviceNameLbl.numberOfLines = 1;
        self.serviceNameLbl.backgroundColor = [UIColor clearColor];
        self.serviceNameLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.serviceNameLbl];
        
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(verticalLiner) + 10, MaxY(self.serviceNameLbl), WIDTH(self.staffNameLbl), 20)];
        self.datetimeLbl.font = [UIFont systemFontOfSize:14];
        self.datetimeLbl.numberOfLines = 1;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.datetimeLbl];
        
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl), 10, 80, 40)];
        self.priceLbl.font = [UIFont systemFontOfSize:14];
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor blackColor];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLbl];
        
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffNameLbl), MinY(self.datetimeLbl), WIDTH(self.priceLbl), HEIGHT(self.datetimeLbl))];
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

    [self.clientAvatorImg setImageWithURL:[dic objectForKey:@"ClientAvatarUrl"]];
    self.clientNameLbl.text = [dic objectForKey:@"ClientNickname"];
    self.staffNameLbl.text = [dic objectForKey:@"StaffNickname"];
    self.serviceNameLbl.text = [dic objectForKey:@"ServiceName"];
    self.priceLbl.text = [NSString stringWithFormat:@"%.2f", [[dic objectForKey:@"Amount"] floatValue]];
    self.statusLbl.text= [[dic objectForKey:@"Status"] intValue] == 1 ? @"交易成功" : @"退款成功";

    NSDate *dateRevenue = [[NSDate dateFormatter] dateFromString:[dic objectForKey:@"CreateTime"]];
    self.datetimeLbl.text =[[NSDate dateWithYMDHFormatter] stringFromDate:dateRevenue];
    
}

- (void)staffTapped
{
    [self.delegate didTapStaff:[[self.dataDic objectForKey:@"staffId"] intValue]];
}

@end
