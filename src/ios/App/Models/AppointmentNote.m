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

#import "AppointmentNote.h"

@implementation AppointmentNote

- (AppointmentNote *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"AppointmentNoteId"] intValue];
        self.body = [dictionary objectForKey:@"Body"];
        self.appointmentId = [[dictionary objectForKey:@"AppointmentId"] intValue];
        self.pictureUrl = [dictionary objectForKey:@"PictureUrl"];
        self.createdDate = [[NSDate dateFormatter] dateFromString:[dictionary objectForKey:@"CreatedDate"]];
    }
    
    return self;
}

@end
