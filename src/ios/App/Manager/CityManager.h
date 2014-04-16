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

#import "BaseManager.h"
#import "City.h"
@interface CityManager : BaseManager

+(id)SharedInstance;

//- (void)refreshCityList:(NSArray *)cityList;

- (NSDictionary *)getCityList;
- (NSArray *)getAreaListByCity:(int)cityCode;

- (City *)getSelectedCity;
- (void)setSelectedCity:(int)cityId;

- (City *)getLocatedCity;
- (void)setLocatedCity:(int)cityId;

- (City *)getCityByName:(NSString *)cityName;
- (City *)getCityById:(int)cityId;
@end
