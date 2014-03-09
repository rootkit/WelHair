// ==============================================================================
//
// This file is part of the WelSpeak.
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#ifndef Macros_h
#define Macros_h

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

#define Application_Frame [[UIScreen mainScreen] applicationFrame]

#define App_Frame_Height [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width [[UIScreen mainScreen] applicationFrame].size.width

#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width

#define X(v) (v).frame.origin.x
#define Y(v) (v).frame.origin.y
#define WIDTH(v) CGRectGetWidth((v).frame)
#define HEIGHT(v) CGRectGetHeight((v).frame)

#define MinX(v) CGRectGetMinX((v).frame)
#define MinY(v) CGRectGetMinY((v).frame)

#define MidX(v) CGRectGetMidX((v).frame)
#define MidY(v) CGRectGetMidY((v).frame)

#define MaxX(v) CGRectGetMaxX((v).frame)
#define MaxY(v) CGRectGetMaxY((v).frame)

#define kStatusBarHeight (20.f)

#define kToolBarHeight (44.f)
#define kTopBarHeight (44.f)
#define kBottomBarHeight (49.f)

#define kCellDefaultHeight (44.f)

#define kEnglishKeyboardHeight (216.f)
#define kChineseKeyboardHeight (252.f)

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif

#endif