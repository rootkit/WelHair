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

@interface AppointmentNote : BaseModel

@property (nonatomic, assign) int appointmentId;
@property (nonatomic, strong) NSArray *pictureUrl;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *createdDate;

- (AppointmentNote *)initWithDic:(NSDictionary *)dictionary;

@end
