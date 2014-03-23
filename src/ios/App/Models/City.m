//
//  City.m
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "City.h"

@implementation City

- (City *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] intValue];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}
- (NSDictionary *)dictionaryFromUser:(City *)city
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:city.id] forKey:@"id"];
    [dic setObject:city.name forKey:@"name"];
    return dic;
}

@end
