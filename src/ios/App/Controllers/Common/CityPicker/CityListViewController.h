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

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "City.h"
@protocol CityPickViewDelegate

- (void) didPickCity:(City *)city;

@end

@interface CityListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) BOOL enableLocation;

@property (nonatomic, strong) City *selectedCity;

@property (nonatomic, strong) id<CityPickViewDelegate> delegate;


@end
