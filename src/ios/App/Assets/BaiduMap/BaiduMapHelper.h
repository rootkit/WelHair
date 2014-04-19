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

#import <Foundation/Foundation.h>
#import "City.h"
#import <CoreLocation/CoreLocation.h>

@interface BDLocation:NSObject

@property (nonatomic, strong) City *locatedCity;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

typedef void (^LocateCompleteHandler)(BDLocation *location);

@interface BaiduMapHelper : NSObject

+(id)SharedInstance;

- (void)locateCityWithCompletion:(LocateCompleteHandler)completion;
- (void)locateCoordinateWithCompletion:(LocateCompleteHandler)completion;

@end
