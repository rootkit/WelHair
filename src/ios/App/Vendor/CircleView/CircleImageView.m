// ==============================================================================
//
// This file is part of the WelStory.
//
// Create by Welfony Support <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import <QuartzCore/QuartzCore.h>

#import "CircleImageView.h"

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 3;
        self.borderColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
    }

    return self;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self drawRect];
}

- (void)setBorderWidth:(float)borderWidth
{
    _borderWidth = borderWidth;
    [self drawRect];
}


- (void)drawRect
{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:(CGRectGetHeight(self.frame) / 2)];
    [self.layer setBorderWidth:self.borderWidth];
    [self.layer setBorderColor:[self.borderColor CGColor]];
}

@end
