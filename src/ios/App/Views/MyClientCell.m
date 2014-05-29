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
#import "MyClientCell.h"

@interface MyClientCell()

@property (nonatomic, strong) StaffClient *userData;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end

@implementation MyClientCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 0;
        [self.contentView addSubview:self.imgView];

        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView) + 10,
                                                                 160,
                                                                 HEIGHT(self.imgView)/3)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.nameLbl.numberOfLines = 1;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLbl];

        self.detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  MaxY(self.nameLbl),
                                                                  WIDTH(self.nameLbl),
                                                                  HEIGHT(self.imgView)/3)];
        self.detailLbl.font = [UIFont systemFontOfSize:12];
        self.detailLbl.numberOfLines = 1;
        self.detailLbl.backgroundColor = [UIColor clearColor];
        self.detailLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.detailLbl];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(StaffClient *)client;
{
    self.userData = client;
    [self.imgView setImageWithURL:self.userData.user.avatarUrl];
    self.nameLbl.text = [NSString stringWithFormat:@"%@", self.userData.user.nickname];
    self.detailLbl.text = [NSString stringWithFormat:@"累计预约%d次", self.userData.appointmentCount];
}

@end
