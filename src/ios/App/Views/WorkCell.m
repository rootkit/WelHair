//
//  WorkCell.m
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WorkCell.h"
#import "WorkCardView.h"

@interface WorkCell ()

@property (nonatomic, strong) WorkCardView *cardView;
@property (nonatomic, strong) Work *workData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation WorkCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setupWithData:(Work *)data tapHandler:(CardTapHandler)tapHandler
{
    self.workData = data;
    self.cardTapHandler = tapHandler;

    if(!self.cardView){
        self.cardView = [[WorkCardView alloc] initWithFrame:CGRectMake(10, 5, 140, data.commentList.count > 0 ? 250 : 174)];
        self.cardView.tag = 0;
        [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
        [self addSubview:self.cardView];
    }

    self.cardView.frame = CGRectMake(10, 5, 140, data.commentList.count > 0 ? 250 : 174);

    [self.cardView setupWithData:data];
}

- (void)cardTapped:(id)sender
{
    self.cardTapHandler(self.workData);
}

@end
