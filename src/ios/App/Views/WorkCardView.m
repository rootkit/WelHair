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
@end
@implementation WorkCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//get calculated height
- (float) setupWithData:(Work *)workData
                  width:(float)width
{
//    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    self.workData = workData;
    float height = width;
    UIImageView *hairImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width -2, width-2)];
    [hairImgView setImageWithURL:[NSURL URLWithString:workData.imgsUrl[0]]];
    [self addSubview:hairImgView];
    
    UILabel * commentCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(hairImgView) + 5, width/2 ,20)];
    commentCountLbl.font = [UIFont systemFontOfSize:14];
    commentCountLbl.backgroundColor = [UIColor clearColor];
    commentCountLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
    commentCountLbl.text = [NSString stringWithFormat:@"评论(%d)",workData.comments.count];
    [self addSubview:commentCountLbl];
    
    FAKIcon *heartIcon = [FAKIonIcons heartIconWithSize:25];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    UIButton *heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heartBtn.frame = CGRectMake(WIDTH(self) - 25 - 15, MaxY(hairImgView) + 5,25, 25);
    [heartBtn addTarget:self action:@selector(favClick) forControlEvents:UIControlEventTouchUpInside];
    [heartBtn setImage:[heartIcon imageWithSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [self addSubview:heartBtn];
    
    UIView *linerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(heartBtn) + 5, WIDTH(self), 1)];
    linerView.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self addSubview:linerView];
    
    CircleImageView *staffImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(5,
                                                                              MaxY(linerView)+ 5,
                                                                              25,
                                                                              25)];
    [staffImgView setImageWithURL:[NSURL URLWithString:workData.creator.avatorUrl]];
    [self addSubview:staffImgView];
    
    // comment
    Comment *comment = workData.comments.count > 0? workData.comments[0] : nil;
    UILabel * commentorNameLbl =
    [[UILabel alloc] initWithFrame:CGRectMake(MaxX(staffImgView) + 5,
                                              MaxY(linerView) + 5,
                                              WIDTH(self) - (MaxX(staffImgView) + 10),
                                              20)];
    commentorNameLbl.font = [UIFont systemFontOfSize:16];
    commentorNameLbl.backgroundColor = [UIColor clearColor];
    commentorNameLbl.textColor = [UIColor colorWithHexString:@"ba725a"];

    commentorNameLbl.text = [NSString stringWithFormat:@"%@:",comment.commentorName];
    [self addSubview:commentorNameLbl];
    
    UILabel * commentContentLbl =
    [[UILabel alloc] initWithFrame:CGRectMake(X(commentorNameLbl),
                                              MaxY(commentorNameLbl),
                                              WIDTH(commentorNameLbl),
                                              40)];
    commentContentLbl.numberOfLines = 0;
    commentContentLbl.font = [UIFont systemFontOfSize:12];
    commentContentLbl.backgroundColor = [UIColor clearColor];
    commentContentLbl.textColor = [UIColor grayColor];
    commentContentLbl.text = [NSString stringWithFormat:@"%@:",comment.title];
    [self addSubview:commentContentLbl];
//    CGSize size = [workData.comment sizeWithFont:[UIFont systemFontOfSize:10]
//                       constrainedToSize:CGSizeMake(WIDTH(commentorNameLbl), CGFLOAT_MAX)
//                           lineBreakMode:NSLineBreakByWordWrapping];
    [self drawBottomShadowOffset:1 opacity:0.1];

    return HEIGHT(self);
}


- (void)favClick
{
    
}


@end
