//
//  OpitionButton.m
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OpitionButton.h"

@implementation OpitionButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [[UIColor colorWithHexString:@"c0bfbf"] CGColor];;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        [self unChoosenStyle];
        self.titleLabel.font  =[UIFont systemFontOfSize:14];
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setChoosen:(BOOL)choosen
{
    if(choosen){
        [self choosenStyle];
        for (UIView *view in self.superview.subviews) {
            if([view isKindOfClass:[OpitionButton class]]){
                OpitionButton *btn = (OpitionButton *)view;
                if([btn.groupName isEqualToString:self.groupName] && ![btn isEqual:self]){
                    [btn unChoosenStyle];
                }
            }
        }
    }else{
        [self unChoosenStyle];
    }
}

- (void)choosenStyle
{
    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"206ba7"]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)unChoosenStyle
{
    [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"73757d"] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
