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

#import "DepositCell.h"

@interface DepositCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@property (nonatomic, strong) Deposit *deposit;

@end

@implementation DepositCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];

        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 20)];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.numberOfLines = 1;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [contentView addSubview:self.titleLbl];

        self.amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.titleLbl), 10, 60, HEIGHT(self.titleLbl))];
        self.amountLbl.font = [UIFont boldSystemFontOfSize:12];
        self.amountLbl.numberOfLines = 1;
        self.amountLbl.backgroundColor = [UIColor clearColor];
        self.amountLbl.textColor = [UIColor colorWithHexString:@"333"];
        self.amountLbl.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:self.amountLbl];

        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.titleLbl), MaxY(self.titleLbl), 200, 20)];
        self.datetimeLbl.font = [UIFont systemFontOfSize:12];
        self.datetimeLbl.numberOfLines = 1;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        [contentView addSubview:self.datetimeLbl];

        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.datetimeLbl), MinY(self.datetimeLbl), 100, HEIGHT(self.datetimeLbl))];
        self.statusLbl.font = [UIFont systemFontOfSize:12];
        self.statusLbl.numberOfLines = 1;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        self.statusLbl.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:self.statusLbl];

        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(contentView) + 1, 320, .2)];
        bottomBorder.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:bottomBorder];
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

- (void)setup:(Deposit *)deposit
{
    self.deposit = deposit;

    self.titleLbl.text = [NSString stringWithFormat:@"充值【%@】", self.deposit.depositNo];
    self.amountLbl.text = [NSString stringWithFormat:@"%.2f", self.deposit.amount];
    self.datetimeLbl.text = [[NSDate dateWithHMFormatter] stringFromDate:self.deposit.createdDate];
    switch (self.deposit.status) {
        case WHDepositStatusSuccess:
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"交易成功";
            break;
        case WHDepositStatusFailed:
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"交易失败";
            break;
        default:
            break;
    }
}

@end
