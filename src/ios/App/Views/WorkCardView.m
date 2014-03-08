//
//  WorkCardView.m
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WorkCardView.h"
#import "Work.h"
#import "UIImageView+WebCache.h"
#import "CircleImageView.h"
#import "Comment.h"
@interface WorkCardView ()

@property (nonatomic, strong) Work *workData;
@property (nonatomic, strong) UIImageView *hairImgView;
@property (nonatomic, strong) UIImageView *staffImgView;
@property (nonatomic, strong) UILabel *commentCountLbl;
@property (nonatomic, strong) UILabel *commentContentLbl;
@property (nonatomic, strong) UILabel *commentorNameLbl;

@end
@implementation WorkCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float width = 140;
        self.hairImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width -2, width-2)];
        [self addSubview:self.hairImgView];
        
        self.commentCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(self.hairImgView) + 5, width/2 ,20)];
        self.commentCountLbl.font = [UIFont systemFontOfSize:14];
        self.commentCountLbl.backgroundColor = [UIColor clearColor];
        self.commentCountLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
        [self addSubview:self.commentCountLbl];
        
        FAKIcon *heartIcon = [FAKIonIcons heartIconWithSize:25];
        [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
        UIButton *heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        heartBtn.frame = CGRectMake(WIDTH(self) - 25 - 15, MaxY(self.hairImgView) + 5,25, 25);
        [heartBtn addTarget:self action:@selector(favClick) forControlEvents:UIControlEventTouchUpInside];
        [heartBtn setImage:[heartIcon imageWithSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
        [self addSubview:heartBtn];
        
        UIView *linerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(heartBtn) + 5, WIDTH(self), 1)];
        linerView.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
        [self addSubview:linerView];
        
        self.staffImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(5,
                                                                              MaxY(linerView)+ 5,
                                                                              25,
                                                                              25)];
        [self addSubview:self.staffImgView];
        
        // comment
        self.commentorNameLbl =
        [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.staffImgView) + 5,
                                                  MaxY(linerView) + 5,
                                                  WIDTH(self) - (MaxX(self.staffImgView) + 10),
                                                  20)];
        self.commentorNameLbl.font = [UIFont systemFontOfSize:16];
        self.commentorNameLbl.backgroundColor = [UIColor clearColor];
        self.commentorNameLbl.textColor = [UIColor colorWithHexString:@"ba725a"];
        

        [self addSubview:self.commentorNameLbl];
        
        self.commentContentLbl =
        [[UILabel alloc] initWithFrame:CGRectMake(X(self.commentorNameLbl),
                                                  MaxY(self.commentorNameLbl),
                                                  WIDTH(self.commentorNameLbl),
                                                  40)];
        self.commentContentLbl.numberOfLines = 0;
        self.commentContentLbl.font = [UIFont systemFontOfSize:12];
        self.commentContentLbl.backgroundColor = [UIColor clearColor];
        self.commentContentLbl.textColor = [UIColor grayColor];

        [self addSubview:self.commentContentLbl];
        [self drawBottomShadowOffset:1 opacity:0.1];
    }
    return self;
}

//get calculated height
- (float) setupWithData:(Work *)workData
{
    self.workData = workData;
    [self.hairImgView setImageWithURL:[NSURL URLWithString:workData.imgUrlList[0]]];
    self.commentCountLbl.text = [NSString stringWithFormat:@"评论(%d)",workData.commentList.count];
    [self.staffImgView setImageWithURL:[NSURL URLWithString:workData.creator.avatorUrl]];
    Comment *comment = workData.commentList.count > 0? workData.commentList[0] : nil;
    self.commentorNameLbl.text = [NSString stringWithFormat:@"%@:",comment.commentorName];
    self.commentContentLbl.text = [NSString stringWithFormat:@"%@:",comment.title];
    return HEIGHT(self);
}



- (void)favClick
{
    
}


@end
