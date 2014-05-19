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
#import "Service.h"
#import "Staff.h"

typedef enum {
    WHApppointmentStatusPending = 0,
    WHApppointmentStatusPaid = 1,
    WHApppointmentStatusCompleted = 2,
    WHApppointmentStatusRefund = 3,
    WHApppointmentStatusCancelled = 4
} WHApppointmentStatus;


@interface Appointment : BaseModel

@property (nonatomic, strong) User *client;
@property (nonatomic, strong) Staff *staff;
@property (nonatomic, strong) Service *service;

@property (nonatomic) float price;
@property (nonatomic) WHApppointmentStatus status;
@property (nonatomic) int paymentTransactionId;

@property (nonatomic) BOOL isLiked;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *imgUrlList;

- (Appointment *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

@end
