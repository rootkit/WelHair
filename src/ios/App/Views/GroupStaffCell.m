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
#import "GroupStaffCell.h"
#import "UIImageView+WebCache.h"
#import "CircleImageView.h"
#import <AMRatingControl.h>
@interface GroupStaffCell()
@property (nonatomic, strong) Staff *staffData;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupLbl;
@property (nonatomic, strong) AMRatingControl *rateControl;
@end

@implementation GroupStaffCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, WIDTH(self) - 40, 50)];
        [self addSubview:contentView];
        contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [contentView addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView),
                                                                 110,
                                                                 HEIGHT(self.imgView)/2)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [contentView addSubview:self.nameLbl];
        
        self.groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  MaxY(self.nameLbl),
                                                                  WIDTH(self.nameLbl),
                                                                  HEIGHT(self.imgView)/2)];
        self.groupLbl.font = [UIFont systemFontOfSize:12];
        self.groupLbl.numberOfLines = 2;
        self.groupLbl.backgroundColor = [UIColor clearColor];
        self.groupLbl.textColor = [UIColor blackColor];
        [contentView addSubview:self.groupLbl];
        
        
        self.rateControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(MaxX(self.nameLbl) + 5, Y(self.nameLbl))
                                                          emptyColor:[UIColor colorWithHexString:@"ffc62a"]
                                                          solidColor:[UIColor colorWithHexString:@"ffc62a"]
                                                        andMaxRating:5];
        
        self.rateControl.enabled = NO;
        [contentView addSubview:self.rateControl];
        
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
    self.nameLbl.text = [NSString stringWithFormat:@"%@:",staff.name];
    self.rateControl.rating = 0.8;
    self.groupLbl.text = [NSString stringWithFormat:@"%@:",staff.group.name];
}

@end

