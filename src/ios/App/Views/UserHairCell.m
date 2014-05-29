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

#import "AppointmentNote.h"
#import "UserHairCell.h"

@interface UserHairCell ()

@property (nonatomic, strong) AppointmentNote *appointmentNote;

@property (nonatomic, strong) UILabel *descriptionLbl;
@property (nonatomic, strong) UILabel *dateLbl;

@property (nonatomic, strong) UIView *border;

@property (nonatomic, strong) NSMutableArray *picList;
@property (nonatomic, strong) ImageTapHandler imageTapHandler;

@end

@implementation UserHairCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];


        self.descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                        87.5,
                                                                        WIDTH(self) - 20,
                                                                        0)];
        self.descriptionLbl.font = [UIFont systemFontOfSize:12];
        self.descriptionLbl.textAlignment = TextAlignmentLeft;
        self.descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLbl.numberOfLines = 0;
        self.descriptionLbl.backgroundColor = [UIColor clearColor];
        self.descriptionLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.descriptionLbl];

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

- (void)awakeFromNib
{
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize textSize = [Util textSizeForText:self.appointmentNote.body
                                   withFont:self.descriptionLbl.font
                              andLineHeight:20];
    self.descriptionLbl.frame = CGRectMake(10,
                                           87.5,
                                           220,
                                           textSize.height);

    CGFloat containerHeight = HEIGHT(self.descriptionLbl);

    if (self.appointmentNote.pictureUrl.count > 0) {
        containerHeight += 77.5;

        int i = 0;
        for (UIImageView *notePic in self.picList) {
            notePic.frame = CGRectMake(MinX(self.descriptionLbl) + i * 67.5 + i * 10, 10, 67.5, 67.5);
            i++;
        }
    }

    self.contentView.frame = CGRectMake(0, 0, WIDTH(self), containerHeight + 20);
    self.border.frame = CGRectMake(0, HEIGHT(self.contentView) - 1, WIDTH(self.contentView), 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(AppointmentNote *)appointmentNote tapHandler:(ImageTapHandler)tapHandler
{
    self.imageTapHandler = tapHandler;
    self.appointmentNote = appointmentNote;

    self.descriptionLbl.text = appointmentNote.body;
    self.dateLbl.text = [[NSDate dateWithHMFormatter] stringFromDate:appointmentNote.createdDate];

    for (int i = 0; i < 4; i++) {
        UIImageView *notePic = self.picList[i];
        if (appointmentNote.pictureUrl.count > i) {
            [notePic setImageWithURL:appointmentNote.pictureUrl[i]];
            notePic.hidden = NO;
        } else {
            notePic.hidden = YES;
        }
    }

}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    self.imageTapHandler(self.picList, sender.view.tag);
}

@end
