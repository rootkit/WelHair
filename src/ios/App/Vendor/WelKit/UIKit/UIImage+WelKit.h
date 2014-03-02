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

@interface UIImage (WelKit)

+ (UIImage *)imageFromView:(UIView *)view;

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *) circularImageWithColor:(UIColor *)color
                                size:(CGSize)size;

- (UIImage *) imageWithMinimumSize:(CGSize)size;

+ (UIImage *) stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *) stepperMinusImageWithColor:(UIColor *)color;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)cropImage:(CGRect)rect;

- (UIImage *)applyBlurWithImage:(UIImage *)theImage;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
