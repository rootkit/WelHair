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

#import "CommentCell.h"
#import "CircleImageView.h"

@interface CommentCell ()

@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) UILabel *dateLbl;

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15,5,50, 50)];
        [self addSubview:self.imgView];

        float dateLblWidth = 100;
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView)+10,
                                                                  Y(self.imgView),
                                                                  WIDTH(self) - MaxY(self.imgView) - 15 - dateLblWidth ,
                                                                  WIDTH(self.imgView)/2)];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.textAlignment = NSTextAlignmentLeft;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"b9705d"];
        [self addSubview:self.titleLbl];
        
        self.descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView)+10,
                                                                        MaxY(self.titleLbl),
                                                                        WIDTH(self)-MaxY(self.imgView) - 10 ,WIDTH(self.imgView)/2)];
        self.descriptionLbl.font = [UIFont systemFontOfSize:10];
        self.descriptionLbl.textAlignment = NSTextAlignmentLeft;
        self.descriptionLbl.backgroundColor = [UIColor clearColor];
        self.descriptionLbl.textColor = [UIColor blackColor];
        [self addSubview:self.descriptionLbl];
        
        self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.titleLbl), Y(self.titleLbl), dateLblWidth,15)];
        self.dateLbl.font = [UIFont systemFontOfSize:10];
        self.dateLbl.textAlignment = NSTextAlignmentLeft;
        self.dateLbl.backgroundColor = [UIColor clearColor];
        self.dateLbl.textColor = [UIColor colorWithHexString:@"89bae3"];
        [self addSubview:self.dateLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(Comment *)comment
{
    [self.imgView setImageWithURL:comment.commentor.avatarUrl];
    self.titleLbl.text = comment.commentor.nickname;
    self.descriptionLbl.text = comment.description;
    self.dateLbl.text = [[NSDate dateFormatter] stringFromDate:comment.createdDate];
}

@end

