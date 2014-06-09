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

#import "Withdraw.h"

@implementation Withdraw

- (Withdraw *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"WithdrawalId"] intValue];
        self.withdrawNo = [dictionary objectForKey:@"WithdrawalNo"];
        self.amount = [[dictionary objectForKey:@"Amount"] floatValue];
        self.status = [[dictionary objectForKey:@"Status"] intValue];

        self.createdDate = [[NSDate dateFormatter] dateFromString:[dictionary objectForKey:@"CreateTime"]];
    }

    return self;
}

@end
