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

#import "ChatGroupCell.h"
#import "CircleImageView.h"
#import "M13BadgeView.h"

@interface ChatGroupCell ()

@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) UILabel *dateLbl;
@property (nonatomic, strong) M13BadgeView *countLbl;

@end

@implementation ChatGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];


        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        self.imgView.borderWidth = 0;
        [self addSubview:self.imgView];

        UIView *imgBg = [[UIView alloc] initWithFrame:CGRectMake(25, 20, 40, 40)];
        imgBg.backgroundColor = [UIColor clearColor];
        [self addSubview:imgBg];

        self.countLbl = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.countLbl.shadowBadge = YES;
        [imgBg addSubview:self.countLbl];

        float dateLblWidth = 70;
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 10,
                                                                  Y(self.imgView),
                                                                  WIDTH(self) - MaxY(self.imgView) - 15 - dateLblWidth,
                                                                  WIDTH(self.imgView) / 2)];
        self.titleLbl.font = [UIFont boldSystemFontOfSize:16];
        self.titleLbl.textAlignment = NSTextAlignmentLeft;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor blackColor];
        [self addSubview:self.titleLbl];
        
        self.descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 10,
                                                                        MaxY(self.titleLbl),
                                                                        WIDTH(self) - MaxY(self.imgView) - 10,
                                                                        WIDTH(self.imgView) / 2)];
        self.descriptionLbl.font = [UIFont systemFontOfSize:12];
        self.descriptionLbl.textAlignment = NSTextAlignmentLeft;
        self.descriptionLbl.backgroundColor = [UIColor clearColor];
        self.descriptionLbl.textColor = [UIColor grayColor];
        [self addSubview:self.descriptionLbl];
        
        self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self) - dateLblWidth - 10, Y(self.titleLbl), dateLblWidth, 15)];
        self.dateLbl.font = [UIFont systemFontOfSize:12];
        self.dateLbl.textAlignment = NSTextAlignmentLeft;
        self.dateLbl.backgroundColor = [UIColor clearColor];
        self.dateLbl.textColor = [UIColor colorWithHexString:@"6d6d6d"];
        [self addSubview:self.dateLbl];

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

- (void)setup:(MessageConversation *)session
{
    [self.imgView setImageWithURL:session.user.avatarUrl];
    self.titleLbl.text = session.user.nickname;
    self.descriptionLbl.text = session.messageSummary;
    self.dateLbl.text = [[NSDate dateWithHMFormatter] stringFromDate:session.messageDate];
    self.countLbl.text = [NSString stringWithFormat:@"%d", session.messageCount];
    self.countLbl.hidden = session.messageCount <= 0;
}

@end
