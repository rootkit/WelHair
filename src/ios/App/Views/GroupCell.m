//
//  GroupCell.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "GroupCell.h"
#import "UIImageView+WebCache.h"
#import <AMRatingControl.h>
@interface GroupCell()
@property (nonatomic, strong) Group *groupData;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) AMRatingControl *rateControl;
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
                                                                     130,
                                                                     HEIGHT(self.imgView)/2)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
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
        
        self.rateControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(MaxX(self.nameLbl) + 5, Y(self.nameLbl))
                                                                      emptyColor:[UIColor colorWithHexString:@"ffc62a"]
                                                                      solidColor:[UIColor colorWithHexString:@"ffc62a"]
                                                                    andMaxRating:5];
        
        self.rateControl.enabled = NO;
        [self addSubview:self.rateControl];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self) - 60, Y(self.addressLbl)    + 10,15,15)];
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
    [self.imgView setImageWithURL:[NSURL URLWithString:self.groupData.imgUrls[0]]];
    self.nameLbl.text = [NSString stringWithFormat:@"%@:",group.name];
    self.rateControl.rating = 0.8;
    self.addressLbl.text = [NSString stringWithFormat:@"%@:",group.address];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.0f千米",group.distance];
}


@end
