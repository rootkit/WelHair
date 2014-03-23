//
//  SettingManager.m
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "SettingManager.h"


@implementation SettingManager

+(id)SharedInstance
{
    static SettingManager *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SettingManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isInitialStart
{
    NSString *value = [self getSettingBySettingKey:DB_TABLE_SETTING_ISINITIALSTART];
     return [value isEqualToString:@"1"]? NO:YES;
}

- (void)setFinishInitial
{
    [self setSettingValue:@"1" forKey:DB_TABLE_SETTING_ISINITIALSTART];
}

- (NSString *) getSettingBySettingKey:(NSString *)settingKey
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    NSString *settingValue;
    if ([db open]) {
        NSString *findSettingValue =[NSString stringWithFormat:@"select SettingValue from Settings where SettingKey = '%@' ",settingKey];
        FMResultSet *set = [db executeQuery:findSettingValue];
        
        while ([set next]) {
            settingValue = [set stringForColumn:@"SettingValue"];
            break;
        }
        [set close];
        [db close];
    }
    return settingValue;
}

- (void)setSettingValue:(NSString *)settingValue
                 forKey:(NSString *)settingKey
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql;
        NSString *findSettingValue =[NSString stringWithFormat:@"select * from Settings where SettingKey = '%@' ",settingKey];
        FMResultSet *set = [db executeQuery:findSettingValue];
        if([set next]){
            sql = @"update Settings set SettingValue = ? where SettingKey = ?";
        }else{
            sql = @"insert into Settings (SettingValue,SettingKey) values (?,?)";
        }
        
        if([db executeUpdate:sql,settingValue,settingKey]){
            debugLog(@"succ to update setting info");
        }else{
            debugLog(@"fail update setting  info");
        }
        [set close];
    }];
}


#pragma logined user
- (int)loginedUserId
{
    int userId = 0;
    NSString *value = [self getSettingBySettingKey:DB_TABLE_SETTING_ONLINEUSERID];
    if(value.length >0){
        userId = [value intValue];
    }
    return userId;
}

- (void)setLoginedUserId:(int)userId
{
    [self setSettingValue:[NSString stringWithFormat:@"%d",userId] forKey:DB_TABLE_SETTING_ONLINEUSERID];
}

#pragma city
- (int)selectedCityId
{
    int cityId = 0;
    NSString *value = [self getSettingBySettingKey:DB_TABLE_SETTING_SELECTED_CITY];
    if(value.length >0){
        cityId = [value intValue];
    }
    return cityId;
}

- (void)setSelectedCityId:(int)cityId
{
    [self setSettingValue:[NSString stringWithFormat:@"%d",cityId] forKey:DB_TABLE_SETTING_SELECTED_CITY];
}
@end
