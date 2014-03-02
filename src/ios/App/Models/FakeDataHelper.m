//
//  FakeDataHelper.m
//  WelHair
//
//  Created by lu larry on 3/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FakeDataHelper.h"

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

@end
