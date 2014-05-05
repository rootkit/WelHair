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

#import "MessageConversation.h"

@implementation MessageConversation

- (MessageConversation *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"MessageConversationId"] intValue];
        self.messageCount = [[dictionary objectForKey:@"NewMessageCount"] intValue];
        self.messageSummary = [dictionary objectForKey:@"NewMessageSummary"];

        NSString *newMessageDate = [dictionary objectForKey:@"NewMessageDate"];
        if (newMessageDate.length > 0) {
            self.messageDate = [[NSDate dateFormatter] dateFromString:newMessageDate];
        }

        if ([dictionary objectForKey:@"UserId"]) {
            self.user = [[User alloc] initWithDic:dictionary];
        }
    }

    return self;
}

@end
