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

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@protocol MapPickViewDelegate

- (void) didPickLocation:(CLLocation *)location;

@end
@interface MapPickViewController : BaseViewController
@property (nonatomic, weak) id<MapPickViewDelegate> delegate;
@property (nonatomic,strong) CLLocation *location;

@end
