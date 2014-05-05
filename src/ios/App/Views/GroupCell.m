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
#import "GroupCell.h"

@interface GroupCell()

@property (nonatomic, strong) Group *groupData;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) UIImageView *rateHandImageView;
@property (nonatomic, strong) UILabel *rateLbl;

@end

@implementation GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                     Y(self.imgView),
                                                                     160,
                                                                     HEIGHT(self.imgView)/2)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
        
        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                        MaxY(self.nameLbl),
                                                                        WIDTH(self.nameLbl),
                                                                        HEIGHT(self.imgView)/2)];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        self.addressLbl.numberOfLines = 2;
        self.addressLbl.backgroundColor = [UIColor clearColor];
        self.addressLbl.textColor = [UIColor blackColor];
        [self addSubview:self.addressLbl];
        
        self.rateHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl), Y(self.nameLbl)+10 , 15, 15)];
        [self addSubview:self.rateHandImageView];
        self.rateHandImageView.image = [UIImage imageNamed:@"RateHand"];
        
        self.rateLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.rateHandImageView)+5,
                                                                    Y(self.nameLbl)+10,
                                                                    50,
                                                                    15)];
        self.rateLbl.font = [UIFont systemFontOfSize:12];
        self.rateLbl.numberOfLines = 2;
        self.rateLbl.text = TextAlignmentLeft;
        self.rateLbl.backgroundColor = [UIColor clearColor];
        self.rateLbl.textColor = [UIColor colorWithHexString:@"b7bcc2"];
        [self addSubview:self.rateLbl];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self) - 80, Y(self.addressLbl)    + 10,15,15)];
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

- (void)setup:(Group *)group
{
    self.groupData = group;

    [self.imgView setImageWithURL:[NSURL URLWithString:group.logoUrl]];
    self.nameLbl.text = [NSString stringWithFormat:@"%@", group.name];
    self.rateLbl.text = @"120";
    self.addressLbl.text = [NSString stringWithFormat:@"地址：%@", group.address];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.0f千米", group.distance / 1000];
}

@end
