//
//  ToggleButton.m
//  WelHair
//
//  Created by lu larry on 4/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

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
    self.on = !self.on;
    [self setbgImg];
    self.toggleHandler(self.on);
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
