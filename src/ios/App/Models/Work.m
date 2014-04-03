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

#import "Comment.h"
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

        NSDictionary *staffDic = [dictionary objectForKey:@"Staff"];
        self.creator.id = [[staffDic objectForKey:@"UserId"] intValue];
        self.creator.avatorUrl = [NSURL URLWithString:[staffDic objectForKey:@"AvatarUrl"]];
        self.creator.groupName = [staffDic objectForKey:@"Nickname"];

        self.commentCount = [[dictionary objectForKey:@"WorkCommentCount"] intValue];
        if (self.commentCount > 0) {
            NSDictionary *commentDic = [dictionary objectForKey:@"Comment"];
            self.lastComment = [[Comment alloc] initWithDic:commentDic];
        }
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
