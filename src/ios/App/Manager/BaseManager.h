//
//  BaseManager.h
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface BaseManager : NSObject

+ (instancetype)SharedInstance;

- (NSString *)databasePath;

@end