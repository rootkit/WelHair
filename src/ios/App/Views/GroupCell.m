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
@end

@implementation GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
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
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    [img setImageWithURL:[NSURL URLWithString:self.groupData.imgUrl]];
    [self addSubview:img];
    img.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
    img.layer.borderWidth = 2;
    
   UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(img) + 5,
                                              Y(img),
                                              130,
                                              HEIGHT(img)/2)];
    nameLbl.font = [UIFont boldSystemFontOfSize:16];
    nameLbl.numberOfLines = 2;
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor blackColor];
    nameLbl.text = [NSString stringWithFormat:@"%@:",group.name];
    [self addSubview:nameLbl];
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(img) + 5,
                                                                 MaxY(nameLbl),
                                                                 WIDTH(nameLbl),
                                                                 HEIGHT(img)/2)];
    addressLbl.font = [UIFont systemFontOfSize:12];
    addressLbl.numberOfLines = 2;
    addressLbl.backgroundColor = [UIColor clearColor];
    addressLbl.textColor = [UIColor blackColor];
    addressLbl.text = [NSString stringWithFormat:@"%@:",group.address];
    [self addSubview:addressLbl];
    
    AMRatingControl *rateControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(MaxX(nameLbl) + 5, Y(nameLbl))
                                                                  emptyColor:[UIColor colorWithHexString:@"ffc62a"]
                                                                  solidColor:[UIColor colorWithHexString:@"ffc62a"]
                                                                         andMaxRating:5];
    
    rateControl.enabled = NO;
    [self addSubview:rateControl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self) - 60, Y(addressLbl)    + 10,15,15)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:15];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(15, 15)];
    [self addSubview:locationImg];
    
    UILabel *distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),WIDTH(self) - MaxX(locationImg), HEIGHT(locationImg))];
    distanceLbl.textAlignment = NSTextAlignmentLeft;
    distanceLbl.textColor = [UIColor colorWithHexString:@"b7bcc2"];
    distanceLbl.backgroundColor = [UIColor clearColor];
    distanceLbl.font = [UIFont systemFontOfSize:12];
    distanceLbl.text = [NSString stringWithFormat:@"%.0f千米",group.distance];
    [self addSubview:distanceLbl];
}


@end
