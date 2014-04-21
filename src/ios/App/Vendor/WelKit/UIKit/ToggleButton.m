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

#import "ToggleButton.h"

@interface ToggleButton()

@property (nonatomic, strong) UIImage *onImg;
@property (nonatomic, strong) UIImage *offImg;
@property (nonatomic, strong) ToggleButtonEventHandler toggleHandler;

@end
@implementation ToggleButton
@synthesize on = _on;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setToggleButtonOnImage:(UIImage *)onImg
                        offImg:(UIImage *)offImg
            toggleEventHandler:(ToggleButtonEventHandler)toggleEventHandler
{
    [self addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchDown];
    self.onImg = onImg;
    self.offImg = offImg;
    self.toggleHandler = toggleEventHandler;
    [self setbgImg];
}

- (BOOL)on{
    return _on;
}

- (void)setOn:(BOOL)on{
    _on = on;
    [self setbgImg];
}

- (void)toggle{
    if(self.toggleHandler(!self.on)){
        self.on = !self.on;
        [self setbgImg];
    }
}

- (void)setbgImg
{
    if(self.on){
        [self setBackgroundImage:self.onImg forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:self.offImg forState:UIControlStateNormal];
    }
}

@end
