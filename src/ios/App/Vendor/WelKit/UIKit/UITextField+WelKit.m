//
//  UITextField+WelKit.m
//  WelHair
//
//  Created by lu larry on 3/5/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "UITextField+WelKit.h"

@implementation UITextField (WelKit)

#pragma UI

+ (id)plainTextField:(CGRect )frame
         leftPadding:(float)padding
{
    UITextField *txt = [[UITextField alloc] initWithFrame:frame];
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, HEIGHT(txt))];
    txt.leftView = leftPaddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
    return txt;
}

#pragma Action
- (void)shake:(int)times withDelta:(CGFloat)delta
{
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:0.03 shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection
{
    [self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:shakeDirection];
}

- (void)_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection
{
	[UIView animateWithDuration:interval animations:^{
		self.transform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
	} completion:^(BOOL finished) {
		if(current >= times) {
			self.transform = CGAffineTransformIdentity;
			return;
		}
		[self _shake:(times - 1)
		   direction:direction * -1
		currentTimes:current + 1
		   withDelta:delta
			andSpeed:interval
      shakeDirection:shakeDirection];
	}];
}

@end
