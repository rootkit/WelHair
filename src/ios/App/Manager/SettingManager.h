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
#define DB_TABLE_SETTING_ISINITIALSTART  @"DB_TABLE_SETTING_ISINITIALSTART"
#define DB_TABLE_SETTING_SELECTED_CITY  @"DB_TABLE_SETTING_SELECTED_CITY"
#define DB_TABLE_SETTING_LOCATED_CITY  @"DB_TABLE_SETTING_LOCATED_CITY"
#define DB_TABLE_SETTING_ONLINEUSERID @"DB_TABLE_SETTING_ONLINEUSERID"
#define DB_TABLE_SETTING_CITY_VERSION @"DB_TABLE_SETTING_CITY_VERSION"

@interface SettingManager : BaseManager
+(id)SharedInstance;
- (BOOL)isInitialStart;
- (void)setFinishInitial;

- (int)loginedUserId;
- (void)setLoginedUserId:(int)userId;

- (int)selectedCityId;
- (void)setSelectedCityId:(int)cityId;

- (int)locatedCityId;
- (void)setLocatedCityId:(int)cityId;

- (int)cityDataVersion;
- (void)setCityDataVersion:(int)version;
@end
