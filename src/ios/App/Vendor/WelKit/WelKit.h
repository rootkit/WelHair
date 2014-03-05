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

#ifndef WelKit_h
#define WelKit_h

#ifndef __IPHONE_5_0
#error "WelKit_h uses features only available in iOS SDK 5.0 and later."
#endif

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WelKitMacros.h"
#endif

#endif

#import "UIView+WelKit.h"
#import "UINavigationBar+WelKit.h"
#import "UITextField+WelKit.h"
