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

#import "Appointment.h"

@implementation Appointment

- (Appointment *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"AppointmentId"] intValue];
        self.price = [[dictionary objectForKey:@"Price"] floatValue];
        self.status = [[dictionary objectForKey:@"Status"] intValue];
        self.paymentTransactionId = [[dictionary objectForKey:@"PaymentTransactionId"] intValue];
        self.date = [[NSDate dateFormatter] dateFromString:[dictionary objectForKey:@"AppointmentDate"]];

        self.staff = [Staff new];
        self.staff.id = [[dictionary objectForKey:@"StaffId"] intValue];
        self.staff.name = [dictionary objectForKey:@"StaffName"];
        self.staff.avatorUrl = [NSURL URLWithString:[dictionary objectForKey:@"StaffAvatarUrl"]];

        self.staff.group = [Group new];
        self.staff.group.id = [[dictionary objectForKey:@"CompanyId"] intValue];
        self.staff.group.name = [dictionary objectForKey:@"CompanyName"];
        self.staff.group.address = [dictionary objectForKey:@"CompanyAddress"];

        self.client = [User new];
        self.client.username = [dictionary objectForKey:@"Username"];
        self.client.nickname = [dictionary objectForKey:@"Nickname"];
        self.client.avatarUrl = [NSURL URLWithString:[dictionary objectForKey:@"AvatarUrl"]];

        self.service = [Service new];
        self.service.id = [[dictionary objectForKey:@"ServiceId"] intValue];
        self.service.name = [dictionary objectForKey:@"ServiceTitle"];

        if ([dictionary objectForKey:@"IsLiked"]) {
            self.isLiked = [[dictionary objectForKey:@"IsLiked"] intValue] == 1;
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:appointment.id] forKey:@"AppointmentId"];

    return dic;
}

@end
