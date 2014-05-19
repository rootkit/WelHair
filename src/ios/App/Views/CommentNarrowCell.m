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

#import "CommentNarrowCell.h"
#import "Comment.h"
#import "CircleImageView.h"

static const float kDateLblWidth = 100;

@interface CommentNarrowCell ()

@property (nonatomic, strong) Comment *comm;

@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) UILabel *dateLbl;

@property (nonatomic, strong) UIView *border;

@property (nonatomic, strong) NSMutableArray *picList;
@property (nonatomic, strong) ImageTapHandler imageTapHandler;

@end

@implementation CommentNarrowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
        self.contentView.layer.borderWidth = 1;
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self.contentView addSubview:self.imgView];
        
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  Y(self.imgView) + 2,
                                                                  WIDTH(self) - MaxY(self.imgView) - 20 - 15 - kDateLblWidth,
                                                                  20)];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.textAlignment = TextAlignmentLeft;
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"b9705d"];
        [self.contentView addSubview:self.titleLbl];
        
        self.descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 10,
                                                                        MaxY(self.titleLbl) + 4,
                                                                        WIDTH(self) - MaxY(self.imgView) - 10,
                                                                        0)];
        self.descriptionLbl.font = [UIFont systemFontOfSize:12];
        self.descriptionLbl.textAlignment = TextAlignmentLeft;
        self.descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLbl.numberOfLines = 0;
        self.descriptionLbl.backgroundColor = [UIColor clearColor];
        self.descriptionLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.descriptionLbl];
        
        self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.titleLbl), Y(self.titleLbl), kDateLblWidth - 10, 20)];
        self.dateLbl.font = [UIFont systemFontOfSize:12];
        self.dateLbl.textAlignment = TextAlignmentRight;
        self.dateLbl.backgroundColor = [UIColor clearColor];
        self.dateLbl.textColor = [UIColor colorWithHexString:@"89bae3"];
        [self.contentView addSubview:self.dateLbl];

        self.border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.contentView), 1)];
        self.border.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        [self.contentView addSubview:self.border];
        
        self.picList = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImageView *commentPicture = [[UIImageView alloc] init];
            commentPicture.userInteractionEnabled = YES;
            commentPicture.tag = i;
            [commentPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)]];
            [self.contentView addSubview:commentPicture];
            [self.picList addObject:commentPicture];
        }
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
    CGRect frame = self.frame;
    frame.origin.x = 10;
    frame.size.width = 300;
    self.frame = frame;
    self.imgView.frame = CGRectMake(5, 5, 50, 50);
    
    self.titleLbl.frame = CGRectMake(MaxX(self.imgView) + 5,
                                     Y(self.imgView) + 2,
                                     300 - MaxY(self.imgView) - 15 - kDateLblWidth,
                                     20);
    
    CGSize textSize = [Util textSizeForText:self.comm.description
                                   withFont:self.descriptionLbl.font
                              andLineHeight:20];
    self.descriptionLbl.frame = CGRectMake(MaxX(self.imgView) + 5,
                                           MaxY(self.titleLbl) + 4,
                                           220,
                                           textSize.height);
    
    CGFloat containerHeight = HEIGHT(self.titleLbl) + HEIGHT(self.descriptionLbl) + 24;
    if (containerHeight < 60) {
        containerHeight = 60;
    }
    
    if (self.comm.imgUrlList.count > 0) {
        containerHeight += 46;
        
        int i = 0;
        for (UIImageView *commentPic in self.picList) {
            commentPic.frame = CGRectMake(MinX(self.descriptionLbl) + i * 44 + i * 5, MaxY(self.descriptionLbl) + 6, 44, 44);
            i++;
        }
    }
    
    self.contentView.frame = CGRectMake(0, 0, WIDTH(self), containerHeight);
    self.border.frame = CGRectMake(0, HEIGHT(self.contentView) - 1, WIDTH(self.contentView), 1);
}

- (void)setup:(Comment *)comment tapHandler:(ImageTapHandler)tapHandler
{
    self.imageTapHandler = tapHandler;
    self.comm = comment;
    
    [self.imgView setImageWithURL:comment.commentor.avatarUrl];
    
    self.titleLbl.text = comment.commentor.nickname;
    self.descriptionLbl.text = comment.description;
    self.dateLbl.text = [[NSDate dateWithHMFormatter] stringFromDate:comment.createdDate];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *commentPic = self.picList[i];
        if (comment.imgUrlList.count > i) {
            [commentPic setImageWithURL:comment.imgUrlList[i]];
            commentPic.hidden = NO;
        } else {
            commentPic.hidden = YES;
        }
    }
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    self.imageTapHandler(self.picList, sender.view.tag);
}

@end

