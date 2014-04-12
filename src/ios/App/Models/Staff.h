// ==============================================================================
//
// This file is part of the WelSpeak.
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

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
