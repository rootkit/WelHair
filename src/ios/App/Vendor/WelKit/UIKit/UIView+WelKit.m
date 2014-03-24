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

#import "UIView+WelKit.h"

@implementation UIView (WelKit)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.width, self.height);
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize) size
{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail
{
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail
{
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom
{
    [self setTail:bottom];
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (void)drawBottomShadowOffset:(float)offset
                       opacity:(float)opacity
{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    ////    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, offset);
    self.layer.shadowOpacity = opacity;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}
@end

