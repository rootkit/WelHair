//
//  SettingManager.h
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseManager.h"
#import "City.h"
#define DB_TABLE_SETTING_ISINITIALSTART  @"DB_TABLE_SETTING_ISINITIALSTART"
#define DB_TABLE_SETTING_SELECTED_CITY  @"DB_TABLE_SETTING_SELECTED_CITY"
#define DB_TABLE_SETTING_ONLINEUSERID @"DB_TABLE_SETTING_ONLINEUSERID"

@interface SettingManager : BaseManager
+(id)SharedInstance;
- (BOOL)isInitialStart;
- (void)setFinishInitial;

- (int)loginedUserId;
- (void)setLoginedUserId:(int)userId;

- (int)selectedCityId;
- (void)setSelectedCityId:(int)cityId;
@end
