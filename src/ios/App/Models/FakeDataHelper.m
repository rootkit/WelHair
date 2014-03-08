//
//  FakeDataHelper.m
//  WelHair
//
//  Created by lu larry on 3/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FakeDataHelper.h"
#import "Work.h"
#import "Comment.h"
#import "Group.h"
@implementation FakeDataHelper


+(id)SharedInstance
{
    static FakeDataHelper *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FakeDataHelper alloc] init];
    });
    return sharedInstance;
}

+(NSArray *)getFakeHairWorkImgs
{
    return @[@"http://pic.mf08s.com/201011/20/c30.jpg",
             @"http://model.zdface.com/news/smallimg/atitle201003041351546937.jpg",
             @"http://luxury.zdface.com/news/smallimg/atitle201010261025178428.jpg",
             @"http://man.zdface.com/news/smallimg/atitle201010191359289550.jpg",
             @"http://pic.mf08s.com/201011/18/t8.jpg",
             @"http://www.zdface.com/news/smallimg/atitle200909232126449011.jpg",
             @"http://beauty.zdface.com/news/smallimg/atitle201107021415336426.jpg",
             @"http://pic.mf08s.com/201106/13/b27.jpg",
             @"http://pic.mf08s.com/201011/20/c80.jpg",
             @"http://pic.mf08s.com/201011/18/t30.jpg"];
}

+(NSArray *)getFakeWorkList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Work *work = [Work new];
        
        work.imgUrlList = @[@"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg"];

        Comment *comment = [Comment new];
        comment.title = @"[ 发型不错，明天也去炸一个]";
        comment.commentorName = @"Andy";
        comment.commentorAvatorUrl = @"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg";
        work.commentList = @[comment];
        
        Staff *staff = [Staff new];
        staff.name = @"Larry";
        staff.avatorUrl = @"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg";
        work.creator = staff;
        [ar addObject:work];
    }
    return ar;
}

+(NSArray *)getFakeGroupList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Group *group = [Group new];
        
        group.imgUrl = @"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg";
        group.name = @"一剪美工作室";
        group.address = @"济南高新区牛王庄路西";
        group.distance = 1;
        [ar addObject:group];
    }
    return ar;
}

@end
