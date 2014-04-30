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

#import "Group.h"
#import "CityManager.h"

@implementation Group

- (Group *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"CompanyId"] intValue];
        self.name = [dictionary objectForKey:@"Name"];
        self.logoUrl = [dictionary objectForKey:@"LogoUrl"];
        self.imgUrls = [dictionary objectForKey:@"PictureUrl"];
        self.address = [dictionary objectForKey:@"Address"];
        self.tel = [dictionary objectForKey:@"Tel"];
        self.mobile = [dictionary objectForKey:@"Mobile"];
        self.coordinate = CLLocationCoordinate2DMake([[dictionary objectForKey:@"Latitude"] doubleValue], [[dictionary objectForKey:@"Longitude"] doubleValue]);

        if ([dictionary objectForKey:@"City"]) {
            self.city = [[CityManager SharedInstance] getCityById:[[dictionary objectForKey:@"City"] intValue]];
        }
        if ([dictionary objectForKey:@"Rate"]) {
            self.rating = [[dictionary objectForKey:@"Rate"] intValue];
        }
        if ([dictionary objectForKey:@"StaffCount"]) {
            self.staffCount = [[dictionary objectForKey:@"StaffCount"] intValue];
        }
        if ([dictionary objectForKey:@"CommentCount"]) {
            self.commentCount = [[dictionary objectForKey:@"CommentCount"] intValue];
        }
        if ([dictionary objectForKey:@"Distance"]) {
            self.distance = [[dictionary objectForKey:@"Distance"] doubleValue];
        }
        if ([dictionary objectForKey:@"IsLiked"]) {
            self.isLiked = [[dictionary objectForKey:@"IsLiked"] intValue] > 0;
        }
    }

    return self;
}

- (NSDictionary *)dictionaryFromGroup:(Group *)group
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:group.id] forKey:@"CompanyId"];
    [dic setObject:[NSNumber numberWithInt:(int)group.status] forKey:@"Status"];

    return dic;
}


@end
