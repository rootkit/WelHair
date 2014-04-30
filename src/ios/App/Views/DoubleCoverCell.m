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

#import "DoubleCoverCell.h"

@interface DoubleCoverCell()

@property (nonatomic, strong) UIView *outerRightView;
@property (nonatomic, strong) UIView *outerLeftView;
@property (nonatomic, strong) UIImageView *leftCoverView;
@property (nonatomic, strong) UIImageView *rightCoverView;
@property (nonatomic, strong) Work *leftData;
@property (nonatomic, strong) Work *rightData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation DoubleCoverCell

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

- (void)setupWithLeftData:(Work *)leftData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler
{
    self.leftData = leftData;
    self.rightData = rightData;
    self.cardTapHandler = tapHandler;
    
    if(!self.leftCoverView && leftData) {
        self.outerLeftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 145, 145)];
        self.outerLeftView.backgroundColor = [UIColor whiteColor];
        self.outerLeftView.layer.borderColor = [[UIColor colorWithHexString:@"dddddd"] CGColor];
        self.outerLeftView.layer.borderWidth = 1;
        [self addSubview:self.outerLeftView];

        UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 139, 139)];
        innerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [self.outerLeftView addSubview:innerView];

        self.leftCoverView = [[UIImageView alloc] initWithFrame:innerView.bounds];
        self.leftCoverView.userInteractionEnabled = YES;
        self.leftCoverView.tag = 0;
        [innerView addSubview:self.leftCoverView];

        [self.leftCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.leftCoverView setImageWithURL:[NSURL URLWithString: self.leftData.imgUrlList[0]]];

    if(!self.rightCoverView && rightData) {
        self.outerRightView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.outerLeftView) + 10, 10, 145, 145)];
        self.outerRightView.backgroundColor = [UIColor whiteColor];
        self.outerRightView.layer.borderColor = [[UIColor colorWithHexString:@"dddddd"] CGColor];
        self.outerRightView.layer.borderWidth = 1;
        [self addSubview:self.outerRightView];

        UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 139, 139)];
        innerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [self.outerRightView addSubview:innerView];

        self.rightCoverView = [[UIImageView alloc] initWithFrame:innerView.bounds];
        self.rightCoverView.userInteractionEnabled = YES;
        self.rightCoverView.tag = 1;
        [innerView addSubview:self.rightCoverView];

        [self.rightCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.rightCoverView setImageWithURL:[NSURL URLWithString: self.rightData.imgUrlList[0]]];
}


- (void)cardTapped:(id)sender
{
    UITapGestureRecognizer *tapView = (UITapGestureRecognizer *)sender;
    UIView *coverView = tapView.view;
    self.cardTapHandler(coverView.tag == 0 ? self.leftData : self.rightData);
}

@end
