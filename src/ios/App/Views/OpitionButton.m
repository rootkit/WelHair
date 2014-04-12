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

#import "OpitionButton.h"

@implementation OpitionButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [[UIColor colorWithHexString:@"cccccc"] CGColor];;
        self.layer.borderWidth = .5;
        self.layer.cornerRadius = 3;

        self.clipsToBounds = YES;
        self.titleLabel.font  =[UIFont systemFontOfSize:14];

        [self unChoosenStyle];
    }

    return self;
}

- (void)setChoosen:(BOOL)choosen
{
    if (choosen) {
        [self choosenStyle];

        for (UIView *view in self.superview.subviews) {
            if([view isKindOfClass:[OpitionButton class]]){
                OpitionButton *btn = (OpitionButton *)view;
                if([btn.groupName isEqualToString:self.groupName] && ![btn isEqual:self]) {
                    [btn unChoosenStyle];
                }
            }
        }
    } else {
        [self unChoosenStyle];
    }
}

- (void)choosenStyle
{
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"206ba7"] cornerRadius:0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)unChoosenStyle
{
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"73757d"] forState:UIControlStateNormal];
}

@end
