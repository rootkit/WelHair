//
//  CityManager.h
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseManager.h"
#import "City.h"
@interface CityManager : BaseManager

+(id)SharedInstance;

- (void)refreshCityList:(NSArray *)cityList;

- (NSArray *)getCityList;

- (City *)getSelectedCity;
- (void)setSelectedCity:(int)cityId;

- (City *)getCityByName:(NSString *)cityName;
@end
