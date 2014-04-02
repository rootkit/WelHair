//
//  ToggleButton.h
//  WelHair
//
//  Created by lu larry on 4/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ToggleButtonEventHandler)(BOOL isOn);

@interface ToggleButton : UIButton
@property (nonatomic) BOOL on;
- (void)setToggleButtonOnImage:(UIImage *)onImg
                        offImg:(UIImage *)offImg
            toggleEventHandler:(ToggleButtonEventHandler)toggleEventHandler;


- (void)toggle;

@end
