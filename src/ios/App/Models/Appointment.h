//
//  Appointment.h
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"
#import "Staff.h"
#import "Service.h"
@interface Appointment : BaseModel
@property (nonatomic, strong) Staff *staff;
@property (nonatomic, strong) Service *service;
@property (nonatomic) float price;
@property (nonatomic, strong) NSDate *date;

@end
