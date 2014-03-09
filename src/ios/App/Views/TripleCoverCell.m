//
//  TripleCoverCell.m
//  WelHair
//
//  Created by lu larry on 3/9/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "TripleCoverCell.h"
#import <UIImageView+WebCache.h>
@interface TripleCoverCell()

@property (nonatomic, strong) UIImageView *leftCoverView;
@property (nonatomic, strong) UIImageView *middleCoverView;
@property (nonatomic, strong) UIImageView *rightCoverView;
@property (nonatomic, strong) Work *leftData;
@property (nonatomic, strong) Work *middleData;
@property (nonatomic, strong) Work *rightData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation TripleCoverCell

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
               middleData:(Work *)middleData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler

{
    self.leftData = leftData;
    self.middleData = middleData;
    self.rightData = rightData;
    self.cardTapHandler = tapHandler;
    
    if(!self.leftCoverView && leftData){
        self.leftCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
        self.leftCoverView.userInteractionEnabled = YES;
        self.leftCoverView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.leftCoverView.layer.borderWidth = 1;
        [self addSubview:self.leftCoverView];
        self.leftCoverView.tag = 0;
        [self.leftCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.leftCoverView setImageWithURL:[NSURL URLWithString: self.leftData.imgUrlList[0]]];
    
    if(!self.middleCoverView && middleData){
        self.middleCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.leftCoverView) + 20, 10, 80, 80)];
        self.middleCoverView.userInteractionEnabled = YES;
        self.middleCoverView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.middleCoverView.layer.borderWidth = 1;
        [self addSubview:self.middleCoverView];
        self.middleCoverView.tag = 1;
        [self.middleCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.middleCoverView setImageWithURL:[NSURL URLWithString: self.middleData.imgUrlList[0]]];
    
    if(!self.rightCoverView && rightData){
        self.rightCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.middleCoverView) + 20, 10, 80, 80)];
        self.rightCoverView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.rightCoverView.layer.borderWidth = 2;
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
