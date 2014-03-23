//
//  ListManager.m
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ListManager.h"


@implementation ListManager
+(id)SharedInstance
{
    static ListManager *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ListManager alloc] init];
    });
    return sharedInstance;
}

@end
