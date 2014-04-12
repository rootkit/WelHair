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

#import "StaffWorkCell.h"
#import "UserManager.h"
#import "Work.h"

@interface StaffWorkCell ()

@property (nonatomic, strong) UIImageView *workImage;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) Work *workData;

@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation StaffWorkCell

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

        FAKIcon *removeIcon = [FAKIonIcons ios7TrashOutlineIconWithSize:24];
        [removeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"]];

        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.removeButton.frame = CGRectMake(145 - 28, MinY(self.dateLabel), 28, 28);
        [self.removeButton setImage:[removeIcon imageWithSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(cardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [workContainer addSubview:self.removeButton];

        self.workImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 139, 139)];
        [workContainer addSubview:self.workImage];
    }

    return self;
}

- (void)setupWithData:(Work *)data tapHandler:(CardTapHandler)tapHandler
{
    self.workData = data;
    self.cardTapHandler = tapHandler;

    self.dateLabel.text = [[NSDate dateWithYMDFormatter] stringFromDate:data.createdDate];
    [self.workImage setImageWithURL:[NSURL URLWithString:data.imgUrlList[0]]];
    self.removeButton.hidden = (data.creator.id != [[UserManager SharedInstance] userLogined].id);
}

- (void)cardTapped:(id)sender
{
    self.cardTapHandler(self.workData);
}

@end
