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

#import <UIKit/UIKit.h>
typedef void (^ToggleButtonEventHandler)(BOOL isOn);

@interface ToggleButton : UIButton
@property (nonatomic) BOOL on;
- (void)setToggleButtonOnImage:(UIImage *)onImg
                        offImg:(UIImage *)offImg
            toggleEventHandler:(ToggleButtonEventHandler)toggleEventHandler;


- (void)toggle;

@end
