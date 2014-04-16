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

#import "CircleImageView.h"
#import "StaffCell.h"
#import "UIImageView+WebCache.h"

@interface StaffCell()

@property (nonatomic, strong) Staff *staffData;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupLbl;
@property (nonatomic, strong) UILabel *groupAddressLbl;
@property (nonatomic, strong) UILabel *workCountLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@end

@implementation StaffCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView),
                                                                 160,
                                                                 HEIGHT(self.imgView)/3)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.nameLbl.numberOfLines = 1;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
    
        self.groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                    MaxY(self.nameLbl),
                                                                    WIDTH(self.nameLbl),
                                                                    HEIGHT(self.imgView)/3)];
        self.groupLbl.font = [UIFont systemFontOfSize:12];
        self.groupLbl.numberOfLines = 1;
        self.groupLbl.backgroundColor = [UIColor clearColor];
        self.groupLbl.textColor = [UIColor blackColor];
        [self addSubview:self.groupLbl];

        self.groupAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  MaxY(self.groupLbl),
                                                                  WIDTH(self.nameLbl),
                                                                  HEIGHT(self.imgView)/3)];
        self.groupAddressLbl.font = [UIFont systemFontOfSize:12];
        self.groupAddressLbl.numberOfLines = 1;
        self.groupAddressLbl.backgroundColor = [UIColor clearColor];
        self.groupAddressLbl.textColor = [UIColor grayColor];
        [self addSubview:self.groupAddressLbl];
        
        UIImageView *workImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl), Y(self.nameLbl), HEIGHT(self.nameLbl),HEIGHT(self.nameLbl))];
        workImg.image = [UIImage imageNamed:@"StaffCellI_WorkIcon"];
        [self addSubview:workImg];
        
        self.workCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(workImg) + 5,
                                                                         Y(self.nameLbl),
                                                                         50,
                                                                         HEIGHT(self.imgView)/3)];
        self.workCountLbl.font = [UIFont systemFontOfSize:12];
        self.workCountLbl.numberOfLines = 1;
        self.workCountLbl.backgroundColor = [UIColor clearColor];
        self.workCountLbl.textColor = [UIColor colorWithHexString:@"019dda"];
        [self addSubview:self.workCountLbl];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupAddressLbl), Y(self.groupAddressLbl), HEIGHT(self.groupAddressLbl),HEIGHT(self.groupAddressLbl))];
        FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:14];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
        locationImg.image = [locationIcon imageWithSize:CGSizeMake(14, 14)];
        [self addSubview:locationImg];
        
        self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 5,
                                                                      Y(self.groupAddressLbl),
                                                                      50,
                                                                      HEIGHT(self.imgView)/3)];
        self.distanceLbl.font = [UIFont systemFontOfSize:12];
        self.distanceLbl.numberOfLines = 1;
        self.distanceLbl.backgroundColor = [UIColor clearColor];
        self.distanceLbl.textColor = [UIColor colorWithHexString:@"b7bcc2"];
        [self addSubview:self.distanceLbl];
        
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
    self.workCountLbl.text = [NSString stringWithFormat:@"%d件", staff.workCount];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.2f千米", staff.distance / 1000];
}

@end

