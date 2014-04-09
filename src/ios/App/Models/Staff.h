//
//  Staff.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"
#import "Group.h"

@interface Staff : BaseModel

@property (nonatomic, strong) NSURL *avatorUrl;
@property (nonatomic, strong) NSString *bio;

@property (nonatomic, strong) Group *group;

@property (nonatomic, strong) NSArray *works;
@property (nonatomic, strong) NSArray *services;

@property (nonatomic) int rating;
@property (nonatomic) int workCount;
@property (nonatomic) BOOL isLiked;

- (Staff *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromStaff:(Staff *)staff;

@end
