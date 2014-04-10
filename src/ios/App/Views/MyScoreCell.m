//
//  GroupCell.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "MyScoreCell.h"
#import "CircleImageView.h"

@interface MyScoreCell()
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic) BOOL isTop;
@property (nonatomic) BOOL isBottom;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *scoreLbl;
@property (nonatomic, strong) UILabel *dateLbl;
@property (nonatomic, strong) UIView  *linerView;
@end

@implementation MyScoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.linerView =[[UIView alloc] init];
        self.linerView.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
        [self addSubview:self.linerView];
        
        float iconSize = 20;
        float cellHeight = 100;
        self.imgView = [[CircleImageView alloc] initWithFrame: CGRectMake(30, (cellHeight - iconSize)/2, iconSize, iconSize)];
        [self addSubview:self.imgView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 0,
                                                                 170,
                                                                 cellHeight)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
        
        self.scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                    20,
                                                                    80,
                                                                    30)];
        self.scoreLbl.font = [UIFont systemFontOfSize:14];
        self.scoreLbl.numberOfLines = 1;
        self.scoreLbl.backgroundColor = [UIColor clearColor];
        self.scoreLbl.textColor = [UIColor colorWithHexString:APP_BASE_COLOR];
        self.scoreLbl.textAlignment= NSTextAlignmentRight;
        [self addSubview:self.scoreLbl];
        
        self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                  MaxY(self.scoreLbl),
                                                                  80,
                                                                  30)];
        self.dateLbl.font = [UIFont systemFontOfSize:14];
        self.dateLbl.numberOfLines = 1;
        self.dateLbl.backgroundColor = [UIColor clearColor];
        self.dateLbl.textColor = [UIColor lightGrayColor];
        self.dateLbl.textAlignment= NSTextAlignmentRight;
        [self addSubview:self.dateLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.isTop){
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:APP_BASE_COLOR] CGColor];
        self.imgView.layer.borderWidth = 2;
        self.imgView.backgroundColor = [UIColor whiteColor];
        self.linerView.frame =CGRectMake(37,
                                         HEIGHT(self)/2,
                                         6,
                                         HEIGHT(self)/2);
    }else if(self.isBottom){
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:APP_BASE_COLOR] CGColor];
        self.imgView.layer.borderWidth = 10;
        self.linerView.frame =CGRectMake(37,
                                         0,
                                         6,
                                         HEIGHT(self)/2);
    }else{
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:APP_BASE_COLOR] CGColor];
        self.imgView.layer.borderWidth = 10;
        self.linerView.frame =CGRectMake(37,
                                         0,
                                         6,
                                         HEIGHT(self));
    }
    self.nameLbl.text = @"开设账户";
    self.scoreLbl.text = @"100";
    self.dateLbl.text = @"2013-12-12";
}

- (void)setup:(NSDictionary *)data
        isTop:(BOOL)isTop
     isBottom:(BOOL)isBottom
{
    self.data = data;
    self.isTop = isTop;
    self.isBottom = isBottom;
}


@end
