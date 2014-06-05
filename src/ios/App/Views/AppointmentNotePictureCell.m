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

#import "AppointmentNotePictureCell.h"

@interface AppointmentNotePictureCell()

@property (nonatomic, strong) AppointmentNote *appointmentNote;
@property (nonatomic, strong) UIImageView *workImage;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation AppointmentNotePictureCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *workContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 145, 145 + 28)];
        workContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:workContainer];

        UIView *workContainerInner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 145, 145)];
        workContainerInner.backgroundColor = [UIColor whiteColor];
        workContainerInner.layer.borderWidth = 1;
        workContainerInner.layer.borderColor = [[UIColor colorWithHexString:@"dddddd"] CGColor];
        [workContainer addSubview:workContainerInner];

        UIImageView *dateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DateFlagBackground"]];
        dateBackground.frame = CGRectMake(MinX(workContainerInner) + 1, MaxY(workContainerInner) - 1, 76, 22);
        [workContainer addSubview:dateBackground];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(workContainerInner) + 3, MaxY(workContainerInner) - 1, 76, 22)];
        self.dateLabel.font = [UIFont systemFontOfSize:11];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        [workContainer addSubview:self.dateLabel];

        UIView *imgBg = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 139, 139)];
        imgBg.backgroundColor = [UIColor lightGrayColor];
        [workContainer addSubview:imgBg];

        self.workImage = [[UIImageView alloc] initWithFrame:imgBg.bounds];
        [imgBg addSubview:self.workImage];
    }

    return self;
}

- (void)setup:(AppointmentNote *)appointmentNote withPictureIndex:(int)pictureIndex
{
    self.appointmentNote = appointmentNote;

    self.dateLabel.text = [[NSDate dateWithYMDFormatter] stringFromDate:appointmentNote.createdDate];
    [self.workImage setImageWithURL:[NSURL URLWithString:appointmentNote.pictureUrl[pictureIndex]]];
}

@end
