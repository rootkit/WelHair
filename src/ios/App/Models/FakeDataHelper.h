//
//  FakeDataHelper.h
//  WelHair
//
//  Created by lu larry on 3/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeDataHelper : NSObject

+(id)SharedInstance;

+(NSArray *)getFakeHairWorkImgs;
+(NSArray *)getFakeWorkList;
+(NSArray *)getFakeGroupList;
@end
