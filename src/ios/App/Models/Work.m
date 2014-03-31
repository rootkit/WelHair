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

#import "Work.h"

@implementation Work

- (id)init
{
    self = [super init];
    return self;
}

- (Work *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"WorkId"] intValue];
        self.imgUrlList = [dictionary objectForKey:@"PictureUrl"];
        self.creator = [Staff new];
        self.creator.avatorUrl = [[dictionary objectForKey:@"Staff"] objectForKey:@"AvatarUrl"];
        self.creator.groupName = [[dictionary objectForKey:@"Staff"] objectForKey:@"Nickname"];
    }

    return self;
}

- (NSDictionary *)dictionaryFromWork:(Work *)work
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:work.id] forKey:@"WorkId"];
    [dic setObject:[NSNumber numberWithInt:(int)work.hairStyle] forKey:@"HairStyle"];

    return dic;
}


@end
