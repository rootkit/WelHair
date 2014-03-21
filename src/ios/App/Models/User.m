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

@implementation User

- (User *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"UserId"] intValue];
        self.username = [dictionary objectForKey:@"Username"];
        self.nickname = [dictionary objectForKey:@"Nickname"];
        self.email = [dictionary objectForKey:@"Email"];

        if ([dictionary objectForKey:@"AvatarUrl"] && [dictionary objectForKey:@"AvatarUrl"] != [NSNull null]) {
            self.avatarUrl = [NSURL URLWithString:[dictionary objectForKey:@"AvatarUrl"]];
        }

        if ([dictionary objectForKey:@"Followed"] && [dictionary objectForKey:@"Followed"] != [NSNull null]) {
            self.followed = [[dictionary objectForKey:@"Followed"] intValue] == 1;
        }
    }

    return self;
}

- (NSDictionary *)dictionaryFromUser:(User *)user
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:user.id] forKey:@"UserId"];
    [dic setObject:user.username forKey:@"Username"];
    [dic setObject:user.nickname forKey:@"Nickname"];
    [dic setObject:user.email forKey:@"Email"];

    if (user.avatarUrl) {
        [dic setObject:[user.avatarUrl absoluteString] forKey:@"AvatarUrl"];
    }

    return dic;
}

@end