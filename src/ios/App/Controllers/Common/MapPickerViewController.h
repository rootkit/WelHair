//
//  MapPickPointViewController.h
//  WelHair
//
//  Created by lu larry on 3/5/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@protocol MapPickViewDelegate

- (void) didPickLocation:(CLLocation *)location;

@end
@interface MapPickViewController : BaseViewController
@property (nonatomic, weak) id<MapPickViewDelegate> delegate;

@end
