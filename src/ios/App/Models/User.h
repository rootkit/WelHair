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

@interface User : BaseModel

@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, assign) BOOL followed;

- (User *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromUser:(User *)user;

@end
