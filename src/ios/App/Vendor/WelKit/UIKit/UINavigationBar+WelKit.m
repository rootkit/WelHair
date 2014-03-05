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

#import "UIImage+WelKit.h"
#import "UINavigationBar+WelKit.h"

@implementation UINavigationBar (WelKit)

- (void)configureNavigationBarWithColor:(UIColor *)color
{
    [self setBackgroundImage:[UIImage imageWithColor:color cornerRadius:0]
               forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
    NSMutableDictionary *titleTextAttributes = [[self titleTextAttributes] mutableCopy];
    if (!titleTextAttributes) {
        titleTextAttributes = [NSMutableDictionary dictionary];
    }
    
    if (&NSShadowAttributeName != NULL) {
        // iOS6 methods
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowOffset:CGSizeZero];
        [shadow setShadowColor:[UIColor clearColor]];
        [titleTextAttributes setObject:shadow forKey:NSShadowAttributeName];
        [titleTextAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [titleTextAttributes setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    } else {
        // Pre-iOS6 methods
        [titleTextAttributes setValue:[UIColor clearColor] forKey:UITextAttributeTextShadowColor];
        [titleTextAttributes setValue:[NSValue valueWithUIOffset:UIOffsetZero] forKey:UITextAttributeTextShadowOffset];
    }
    
    [self setTitleTextAttributes:titleTextAttributes];
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    }
}

@end
