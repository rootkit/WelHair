// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "BaseModel.h"
#import "User.h"

@interface MessageConversation : BaseModel

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int messageCount;
@property (nonatomic, strong) NSString *messageSummary;
@property (nonatomic, strong) NSDate *messageDate;

- (MessageConversation *)initWithDic:(NSDictionary *)dictionary;

@end
