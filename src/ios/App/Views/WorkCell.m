//
//  WorkCell.m
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WorkCell.h"
#import "WorkCardView.h"
#import "UIImageView+WebCache.h"

@interface WorkCell ()

@property (nonatomic, strong) WorkCardView *leftCardView;
@property (nonatomic, strong) WorkCardView *rightCardView;
@property (nonatomic, strong) Work *leftWorkData;
@property (nonatomic, strong) Work *rightWorkData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation WorkCell

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
    self.leftWorkData = leftData;
    self.rightWorkData = rightData;
    self.cardTapHandler = tapHandler;
    
    if(!self.leftCardView){
        self.leftCardView = [WorkCardView new];
        self.leftCardView.frame = CGRectMake(10, 5, 140, 250);
        [self addSubview:self.leftCardView];
        self.leftCardView.tag = 0;
        [self.leftCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.leftCardView setupWithData:leftData width:140];

    if(!self.rightCardView){
        self.rightCardView = [WorkCardView new];
        self.rightCardView.frame = CGRectMake(MaxX(self.leftCardView) + 20, 5, 140, 250);
        [self addSubview:self.rightCardView];
        self.rightCardView.tag = 1;
        [self.rightCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.rightCardView setupWithData:rightData width:140];
}

- (void)cardTapped:(id)sender
{
    UITapGestureRecognizer *tapView = (UITapGestureRecognizer *)sender;
    UIView *cardView = tapView.view;
    Work *work = cardView.tag == 0 ? self.leftWorkData : self.rightWorkData;
    self.cardTapHandler(work);
}

@end
