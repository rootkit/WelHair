//
//  Staff.m
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "Staff.h"

@implementation Staff

- (Staff *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"UserId"] intValue];
        self.name = [dictionary objectForKey:@"Nickname"];
        self.avatorUrl = [NSURL URLWithString:[dictionary objectForKey:@"AvatarUrl"]];

        if ([dictionary objectForKey:@"Rate"]) {
            self.rating = [[dictionary objectForKey:@"Rate"] intValue];
        }
        if ([dictionary objectForKey:@"StaffCount"]) {
            self.workCount = [[dictionary objectForKey:@"WorkCount"] intValue];
        }
        if ([dictionary objectForKey:@"Company"]) {
            NSDictionary *companyDic = [dictionary objectForKey:@"Company"];
            self.distance = [[companyDic objectForKey:@"Distance"] doubleValue];

            self.group = [[Group alloc] initWithDic:companyDic];
        }
        if ([dictionary objectForKey:@"IsLiked"]) {
            self.isLiked = [[dictionary objectForKey:@"IsLiked"] intValue] > 0;
        }
    }

    return self;
}

- (NSDictionary *)dictionaryFromStaff:(Staff *)staff
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:staff.id] forKey:@"UserId"];

    return dic;
}

@end
