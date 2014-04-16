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

#import "CouponCell.h"
#import "UIImageView+WebCache.h"
#import "Coupon.h"

@interface CouponCell()
@property (nonatomic, strong) Coupon *couponData;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@end

@implementation CouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        
        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView),
                                                                 180,
                                                                 20)];
        self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
        self.groupNameLbl.numberOfLines = 1;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.groupNameLbl];

        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 MaxY(self.groupNameLbl),
                                                                 WIDTH(self.groupNameLbl),
                                                                 20)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor colorWithHexString:APP_BASE_COLOR];
        [self addSubview:self.nameLbl];
        
        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                    MaxY(self.nameLbl),
                                                                    WIDTH(self.nameLbl),
                                                                    20)];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        self.addressLbl.numberOfLines = 2;
        self.addressLbl.backgroundColor = [UIColor clearColor];
        self.addressLbl.textColor = [UIColor blackColor];
        [self addSubview:self.addressLbl];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self) - 60, Y(self.addressLbl),15,15)];
        FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:15];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
        locationImg.image = [locationIcon imageWithSize:CGSizeMake(15, 15)];
        [self addSubview:locationImg];
        
        self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),WIDTH(self) - MaxX(locationImg), HEIGHT(locationImg))];
        self.distanceLbl.textAlignment = NSTextAlignmentLeft;
        self.distanceLbl.textColor = [UIColor colorWithHexString:@"b7bcc2"];
        self.distanceLbl.backgroundColor = [UIColor clearColor];
        self.distanceLbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.distanceLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Coupon *)coupon
{
    self.couponData = coupon;
    [self.imgView setImageWithURL:[NSURL URLWithString:self.couponData.imgUrl]];
    self.groupNameLbl.text = [NSString stringWithFormat:@"%@:",coupon.groupName];
    self.nameLbl.text = [NSString stringWithFormat:@"%@:",coupon.name];
    self.addressLbl.text = [NSString stringWithFormat:@"%@:",coupon.address];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.0f千米",coupon.distance];
}
@end