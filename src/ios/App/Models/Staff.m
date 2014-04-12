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

#import "Service.h"
#import "Staff.h"
#import "Work.h"

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
        if ([dictionary objectForKey:@"WorkCount"]) {
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
        if ([dictionary objectForKey:@"Services"]) {
            NSMutableArray *serviceArr = [NSMutableArray array];

            NSArray *services = [dictionary objectForKey:@"Services"];
            for (NSDictionary *serviceDic in services) {
                Service *sv = [Service new];
                sv.id = [[serviceDic objectForKey:@"ServiceId"] intValue];
                sv.name = [serviceDic objectForKey:@"Title"];
                sv.originalPrice = [[serviceDic objectForKey:@"OldPrice"] floatValue];
                sv.salePrice = [[serviceDic objectForKey:@"Price"] floatValue];

                [serviceArr addObject:sv];
            }

            self.services = serviceArr;
        }
        if ([dictionary objectForKey:@"Works"]) {
            NSMutableArray *workArr = [NSMutableArray array];

            NSArray *works = [dictionary objectForKey:@"Works"];
            for (NSDictionary *workDic in works) {
                Work *w = [[Work alloc] initWithDic:workDic];
                [workArr addObject:w];
            }

            self.works = workArr;
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
