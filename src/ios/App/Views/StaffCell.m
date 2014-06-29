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
#import "StaffCell.h"

@interface StaffCell()

@property (nonatomic, strong) Staff *staffData;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupLbl;
@property (nonatomic, strong) UILabel *groupAddressLbl;
@property (nonatomic, strong) UILabel *rateCoubtLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@end

@implementation StaffCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.imgView.layer.borderWidth = 0;
        [self addSubview:self.imgView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView),
                                                                 154,
                                                                 HEIGHT(self.imgView) / 3)];
        self.nameLbl.font = [UIFont systemFontOfSize:16];
        self.nameLbl.numberOfLines = 1;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
        [self addSubview:self.nameLbl];
    
        self.groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                    MaxY(self.nameLbl),
                                                                    WIDTH(self.nameLbl),
                                                                    HEIGHT(self.imgView) / 3)];
        self.groupLbl.font = [UIFont systemFontOfSize:13];
        self.groupLbl.numberOfLines = 1;
        self.groupLbl.backgroundColor = [UIColor clearColor];
        self.groupLbl.textColor = [UIColor colorWithHexString:@"666"];
        [self addSubview:self.groupLbl];

        self.groupAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  MaxY(self.groupLbl),
                                                                  WIDTH(self.nameLbl),
                                                                  HEIGHT(self.imgView) / 3)];
        self.groupAddressLbl.font = [UIFont systemFontOfSize:12];
        self.groupAddressLbl.numberOfLines = 1;
        self.groupAddressLbl.backgroundColor = [UIColor clearColor];
        self.groupAddressLbl.textColor = [UIColor grayColor];
        [self addSubview:self.groupAddressLbl];
        
        UIImageView *rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 2, Y(self.nameLbl) + 10 , 15, 15)];
        [self addSubview:rateImageView];
        rateImageView.image = [UIImage imageNamed:@"RateHand"];
        
        self.rateCoubtLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(rateImageView) + 5,
                                                                      Y(self.nameLbl)+10,
                                                                      50,
                                                                      HEIGHT(self.imgView)/3)];
        self.rateCoubtLbl.font = [UIFont systemFontOfSize:12];
        self.rateCoubtLbl.numberOfLines = 1;
        self.rateCoubtLbl.text = TextAlignmentLeft;
        self.rateCoubtLbl.backgroundColor = [UIColor clearColor];
        self.rateCoubtLbl.textColor = [UIColor colorWithHexString:@"b7bac1"];
        [self addSubview:self.rateCoubtLbl];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupAddressLbl), Y(self.groupAddressLbl) - 1, 20, 20)];
        FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bac1"]];
        locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
        [self addSubview:locationImg];
        
        self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(self.groupAddressLbl), 50, HEIGHT(self.groupAddressLbl))];
        self.distanceLbl.font = [UIFont systemFontOfSize:12];
        self.distanceLbl.numberOfLines = 1;
        self.distanceLbl.backgroundColor = [UIColor clearColor];
        self.distanceLbl.textColor = [UIColor colorWithHexString:@"b7bac1"];
        [self addSubview:self.distanceLbl];

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
        border.backgroundColor = [UIColor colorWithHexString:@"ddd"];
        [self addSubview:border];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Staff *)staff
{
    self.staffData = staff;
    [self.imgView setImageWithURL:self.staffData.avatorUrl];
    self.nameLbl.text = [NSString stringWithFormat:@"%@", staff.name];
    self.groupLbl.text = staff.group.name;
    self.groupAddressLbl.text = staff.group.address;
    self.rateCoubtLbl.text = [NSString stringWithFormat:@"%d", staff.ratingCount];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.1fkm", staff.distance / 1000];
}

@end

