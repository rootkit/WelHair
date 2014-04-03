//
//  Staff.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"

@interface Staff : BaseModel

@property (nonatomic, strong) NSURL *avatorUrl;
@property (nonatomic) float rate;
@property (nonatomic) int groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSArray *works;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSString *bio;

@end
