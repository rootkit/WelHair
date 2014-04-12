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

#import "StaffServiceTableViewCell.h"

@interface StaffServiceTableViewCell()

@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *saledPriceLabel;

@end

@implementation StaffServiceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:backgroundView];

        self.originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        self.originalPriceLabel.backgroundColor = [UIColor clearColor];
        self.originalPriceLabel.textColor = [UIColor colorWithHexString:@"dddddd"];
        self.originalPriceLabel.textAlignment = TextAlignmentRight;
        [self.contentView addSubview:self.originalPriceLabel];

        self.saledPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 30)];
        self.saledPriceLabel.backgroundColor = [UIColor clearColor];
        self.saledPriceLabel.textColor = [UIColor colorWithHexString:@"4CD964"];
        self.saledPriceLabel.textAlignment = TextAlignmentRight;
        [self.contentView addSubview:self.saledPriceLabel];

        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
        borderView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:borderView];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Service *)service
{
    self.textLabel.text = service.name;
    self.originalPriceLabel.text = [NSString stringWithFormat:@"原价：%.1f元", service.originalPrice];
    self.saledPriceLabel.text = [NSString stringWithFormat:@"折后价：%.1f元", service.salePrice];
}

@end
