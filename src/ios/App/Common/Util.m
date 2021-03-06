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
    CGFloat maxHeight = 9999;

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

+ (float)heightFortext:(NSString *)string minumHeight:(float)minmunHeight fixedWidth:(float)fixedWidth
{
    if(string.length == 0){
        return minmunHeight;
    }
    CGSize constrainedSize = CGSizeMake(fixedWidth  , 9999);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:12], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesDictionary];
    
    CGRect requiredHeight = [str boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return MAX(requiredHeight.size.height, minmunHeight);
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



- (void)prepareApplicationData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
            NSString *resourceFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
            NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
            [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath
                                                    contents:mainBundleFile
                                                  attributes:nil];
        }
    });
}

+ (BOOL)validPhoneNum:(NSString *)phoneStr
{
    NSString *phoneRegex = @"^[1][358][0-9]{9}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:phoneStr];
}


+(void)phoneCall:(NSString *)phoneNumStr
{
    if(phoneNumStr.length  > 0){
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneNumStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

+ (BOOL)compareOnlineVersion:(NSString *)onlineVersion withLocalVersion:(NSString *)localVersion
{
    if(onlineVersion.length == 0){
        return NO;
    }
    NSArray *local = [localVersion componentsSeparatedByString:@"."];
    NSArray *online= [onlineVersion componentsSeparatedByString:@"."];
    int localNumber = [local[local.count-1] intValue];
    for (int i = local.count -1; i >=0 ; i--) {
        localNumber += [local[i] intValue] * 10 ^i;
    }
    int onlineNumber = [online[online.count-1] intValue];
    for (int i = online.count -1; i >=0 ; i--) {
        onlineNumber += [online[i] intValue] * 10 ^i;
    }
    
    return onlineNumber > localNumber;
}

@end
