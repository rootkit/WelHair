// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "Message.h"

@implementation Message

- (Message *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"MessageId"] intValue];
        self.mediaType = [[dictionary objectForKey:@"MediaType"] intValue];
        self.mediaUrl = [NSURL URLWithString:@"MediaUrl"];
        self.body = [dictionary objectForKey:@"Body"];
        self.date = [[NSDate dateFormatter] dateFromString:[dictionary objectForKey:@"CreatedDate"]];

        self.from = [User new];
        self.from.id = [[dictionary objectForKey:@"FromUserId"] intValue];
        self.from.username = [dictionary objectForKey:@"FromUsername"];
        self.from.nickname = [dictionary objectForKey:@"FromNickname"];
        self.from.avatarUrl = [NSURL URLWithString:[dictionary objectForKey:@"FromAvatarUrl"]];

        self.to = [User new];
        self.to.id = [[dictionary objectForKey:@"ToUserId"] intValue];
        self.to.username = [dictionary objectForKey:@"ToUsername"];
        self.to.nickname = [dictionary objectForKey:@"ToNickname"];
        self.to.avatarUrl = [NSURL URLWithString:[dictionary objectForKey:@"ToAvatarUrl"]];
    }

    return self;
}

@end
