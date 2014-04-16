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
#import <UIImageView+WebCache.h>
@interface DoubleCoverCell()

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
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithLeftData:(Work *)leftData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler
{
    self.leftData = leftData;
    self.rightData = rightData;
    self.cardTapHandler = tapHandler;
    
    if(!self.leftCoverView && leftData) {
        self.leftCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 130, 130)];
        self.leftCoverView.userInteractionEnabled = YES;
        self.leftCoverView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.leftCoverView.layer.borderWidth = 1;
        [self addSubview:self.leftCoverView];
        self.leftCoverView.tag = 0;
        [self.leftCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.leftCoverView setImageWithURL:[NSURL URLWithString: self.leftData.imgUrlList[0]]];
    if(!self.rightCoverView && rightData){
        self.rightCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.leftCoverView) + 20, 10, 130, 130)];
        self.rightCoverView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.rightCoverView.layer.borderWidth = 1;
        self.rightCoverView.userInteractionEnabled = YES;
        [self addSubview:self.rightCoverView];
        self.rightCoverView.tag = 1;
        [self.rightCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.rightCoverView setImageWithURL:[NSURL URLWithString: self.rightData.imgUrlList[0]]];
}


- (void)cardTapped:(id)sender
{
    UITapGestureRecognizer *tapView = (UITapGestureRecognizer *)sender;
    UIView *coverView = tapView.view;
    self.cardTapHandler(    coverView.tag == 0 ? self.leftData : self.rightData);
}

@end
