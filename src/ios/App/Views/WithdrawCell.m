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

#import "WithdrawCell.h"


@interface WithdrawCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *datetimeLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) NSDictionary *withdraw;

@end

@implementation WithdrawCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        topBorder.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:topBorder];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 130)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];
        
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                      10,
                                                                      200,
                                                                      20)];
        self.titleLbl.font = [UIFont boldSystemFontOfSize:16];
        self.titleLbl.numberOfLines = 1;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [contentView addSubview:self.titleLbl];
        
        self.datetimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.titleLbl),
                                                                      Y(self.titleLbl),
                                                                      100,
                                                                      20)];
        self.datetimeLbl.font = [UIFont boldSystemFontOfSize:12];
        self.datetimeLbl.numberOfLines = 1;
        self.datetimeLbl.backgroundColor = [UIColor clearColor];
        self.datetimeLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        [contentView addSubview:self.datetimeLbl];
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.datetimeLbl),
                                                                    MaxY(self.datetimeLbl),
                                                                    WIDTH(self.datetimeLbl),
                                                                    HEIGHT(self.datetimeLbl))];
        self.statusLbl.font = [UIFont systemFontOfSize:12];
        self.statusLbl.numberOfLines = 1;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        self.statusLbl.textColor = [UIColor colorWithHexString:@"ababab"];
        self.statusLbl.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:self.statusLbl];
        
        self.actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(250 , MaxY(self.datetimeLbl), 60, 25)];
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.actionBtn.tag = 0;
        [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [self.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.actionBtn];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(contentView) + 1, 320, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
        [self.contentView addSubview:bottomBorder];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(NSDictionary *)withdraw;
{
    self.withdraw = withdraw;
    
    
    self.titleLbl.text = [NSString stringWithFormat:@"申请提现 %@",[self.withdraw objectForKey:@"amount"]];
    self.datetimeLbl.text = [self.withdraw objectForKey:@"date"];
    int status = [[self.withdraw objectForKey:@"status"] intValue];
    switch (status) {
        case 1:
            // 审批中
            self.actionBtn.hidden = NO;
            self.statusLbl.hidden = YES;
            break;
        case 2:
            // 提现完成
            self.actionBtn.hidden = YES;
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"完成";
            break;
        case 3:
            // 取消
            self.actionBtn.hidden = YES;
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"取消";
            break;
            
        default:
            break;
    }
}

- (void)actionClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CANCEL_REQUEST_WITHDRAW object:[self.withdraw objectForKey:@"id"]];
}
@end