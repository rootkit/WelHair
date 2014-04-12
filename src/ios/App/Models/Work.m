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
        self.creator.id = !staffDic ? [[dictionary objectForKey:@"UserId"] intValue] : [[staffDic objectForKey:@"UserId"] intValue];
        self.creator.avatorUrl = [NSURL URLWithString:[staffDic objectForKey:@"AvatarUrl"]];
        self.creator.group.name = [staffDic objectForKey:@"Nickname"];

        self.commentCount = [[dictionary objectForKey:@"WorkCommentCount"] intValue];
        if (self.commentCount > 0) {
            NSDictionary *commentDic = [dictionary objectForKey:@"Comment"];
            self.lastComment = [[Comment alloc] initWithDic:commentDic];
        }

        if ([dictionary objectForKey:@"CreatedDate"]) {
            self.createdDate = [[NSDate dateFormatter] dateFromString:[dictionary objectForKey:@"CreatedDate"]];
        }

        if ([dictionary objectForKey:@"HairStyle"]) {
            self.hairStyle = (HairStyleEnum)[[dictionary objectForKey:@"HairStyle"] intValue];
        }

        if ([dictionary objectForKey:@"HairAmount"]) {
            self.hairQuality = (HairQualityEnum)[[dictionary objectForKey:@"HairAmount"] intValue];
        }

        if ([dictionary objectForKey:@"Gender"]) {
            self.gender = [[dictionary objectForKey:@"Gender"] intValue] == 1 ? GenderEnumFemale : GenderEnumMale;
        }

        if ([dictionary objectForKey:@"Face"]) {
            NSArray *faceArr = [[dictionary objectForKey:@"Face"] componentsSeparatedByString:@","];
            for (NSString *f in faceArr) {
                if ([f intValue] == 1) {
                    self.faceStyleCircle = true;
                }
                if ([f intValue] == 2) {
                    self.faceStyleGuaZi = true;
                }
                if ([f intValue] == 3) {
                    self.faceStyleSquare = true;
                }
                if ([f intValue] == 4) {
                    self.faceStyleLong = true;
                }
            }
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
