//
//  Comment.m
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

- (Comment *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"CommentId"] intValue];
        self.description = [dictionary objectForKey:@"Body"];


        if ([dictionary objectForKey:@"CreatedBy"] && [dictionary objectForKey:@"CreatedBy"] != [NSNull null]) {
            self.commentor = [User new];
            NSDictionary *userDic = [dictionary objectForKey:@"CreatedBy"];
            self.commentor.id = [[userDic objectForKey:@"UserId"] intValue];
            self.commentor.avatarUrl = [NSURL URLWithString:[userDic objectForKey:@"AvatarUrl"]];
            self.commentor.nickname = [userDic objectForKey:@"Nickname"];
        }

        if ([dictionary objectForKey:@"PictureUrl"] && [dictionary objectForKey:@"PictureUrl"] != [NSNull null]) {
            self.imgUrlList = [dictionary objectForKey:@"PictureUrl"];
        }
    }

    return self;
}

- (NSDictionary *)dictionaryFromComment:(Comment *)comment
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:comment.id] forKey:@"CommentId"];

    return dic;
}

@end
