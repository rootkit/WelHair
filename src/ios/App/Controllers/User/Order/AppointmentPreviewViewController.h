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
#import "BaseViewController.h"
#import "StaffDetailViewController.h"

@interface AppointmentPreviewViewController : BaseViewController

@property (nonatomic, strong) Appointment *appointment;

@property (nonatomic, strong) StaffDetailViewController *staffDetailController;

@end
