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

#import <UIKit/UIKit.h>

@interface NSString (WelKit)

- (NSString*) MD5;
- (NSString*) SHA1;
- (NSString*) SHA256;

- (BOOL)isValidEmailWithStricterFilter:(BOOL)stricterFilter;
- (BOOL)isNilOrEmpty;

@end
