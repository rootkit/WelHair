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

typedef enum {
    Unknown = 0,
    WHAdmin = 1,
    WHManager = 2,
    WHStaff = 3,
    WHClient = 4
} WHUserRole;

@interface User : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int groupId;
@property (nonatomic, assign) WHUserRole role;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *invitor;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, strong) NSArray *imgUrls;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL isApproving;

- (User *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromUser:(User *)user;

@end
