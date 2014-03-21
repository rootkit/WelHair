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

@class User;

@interface Util : NSObject

@property (nonatomic, strong) User *userLogined;

+ (instancetype)sharedInstance;

+ (CGSize)textSizeForText:(NSString *)txt withFont:(UIFont *)font andLineHeight:(CGFloat)lineHeight;

+ (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString;

+ (id)objectFromJson:(NSString *)JSONString;
+ (NSString *)parseJsonFromObject:(id)object;

- (void)signout;

@end
