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
#import "User.h"

@interface StaffClient : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) int appointmentCount;
@property (nonatomic, assign) int completedAppointmentCount;

@end
