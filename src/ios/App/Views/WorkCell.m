//
//  WorkCell.m
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WorkCell.h"
#import "UIImageView+WebCache.h"

@interface WorkCell ()

@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) imgTapHandler imgTapHandler;

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

- (void)setupWithLeftData:(NSString *)leftData
                rightData:(NSString *)rightData
           tapHandler:(imgTapHandler)tapHandler
{
    int margin = 5;
    self.imgTapHandler = tapHandler;
    if(!self.leftImg){
        self.leftImg = [[UIImageView alloc] init];
        self.leftImg.contentMode = UIViewContentModeScaleAspectFit;
        self.leftImg.frame = CGRectMake(margin,
                                        margin,
                                        (WIDTH(self) - 4* margin)/2,
                                        (WIDTH(self) - 4* margin)/2);
        self.leftImg.userInteractionEnabled = YES;
        [self.leftImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)]];
        [self addSubview:self.leftImg];
    }
    [self.leftImg setImageWithURL:[NSURL URLWithString:leftData]];



    if(!self.rightImg){
        self.rightImg = [[UIImageView alloc] init];
        self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImg.frame = CGRectMake(MaxX(self.leftImg) + 2 *margin,
                                         margin,
                                         (WIDTH(self) - 4* margin)/2,
                                         (WIDTH(self) - 4* margin)/2);
        self.rightImg.userInteractionEnabled = YES;
        [self.rightImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)]];
        [self addSubview:self.rightImg];
    }
    [self.rightImg setImageWithURL:[NSURL URLWithString:rightData]];
}

- (void)imgTapped:(id)sender
{
    self.imgTapHandler(0);
}

@end
