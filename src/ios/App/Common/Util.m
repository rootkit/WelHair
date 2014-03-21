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

#import "User.h"
#import "Util.h"

@implementation Util
{
    User *currentUser_;
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

+ (CGSize)textSizeForText:(NSString *)txt withFont:(UIFont *)font andLineHeight:(CGFloat)lineHeight
{
    CGFloat maxWidth = [UIScreen mainScreen].applicationFrame.size.width * 0.70f;
    CGFloat maxHeight = ([[txt componentsSeparatedByString:@"\n"] count] + 1) * lineHeight;

    CGSize stringSize;

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
        CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : font }
                                              context:nil];

        stringSize = CGRectIntegral(stringRect).size;
    }
    else {
        stringSize = [txt sizeWithFont:font
                     constrainedToSize:CGSizeMake(maxWidth, maxHeight)];
    }

    return CGSizeMake(roundf(stringSize.width), roundf(stringSize.height));
}

+ (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString
{

    NSMutableDictionary *md = [NSMutableDictionary dictionary];

    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];

    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;

        NSString *key = pair[0];
        NSString *value = pair[1];

        md[key] = value;
    }

    return md;
}

+ (id)objectFromJson:(NSString *)JSONString
{
    NSData * jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    id parsed = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if([parsed isKindOfClass:[NSDictionary class]] || [parsed isKindOfClass:[NSArray class]])
        return parsed;
    else
        return nil;
}

+ (NSString *)parseJsonFromObject:(id)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];

    if (!jsonData) {
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (void)signout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"CurrentLoginUser"];
    [defaults synchronize];
    
    currentUser_ = nil;
}

- (void)setUserLogined:(User *)userLogined
{
    currentUser_ = userLogined;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userLogined dictionaryFromUser:userLogined] forKey:@"CurrentLoginUser"];
    [defaults synchronize];
}

- (User *)userLogined
{
    if (!currentUser_) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"CurrentLoginUser"]) {
            return nil;
        }

        currentUser_ = [[User alloc] initWithDic:[defaults objectForKey:@"CurrentLoginUser"]];
    }
    return currentUser_;
}

@end
