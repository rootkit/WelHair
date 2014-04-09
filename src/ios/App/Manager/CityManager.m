//
//  CityManager.m
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "CityManager.h"
#import "SettingManager.h"


@implementation CityManager

+(id)SharedInstance
{
    static CityManager *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CityManager alloc] init];
    });
    return sharedInstance;
}

- (void)refreshCityList:(NSArray *)cityList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            BOOL success = NO;
            NSString *removeData = @"delete from City ";
            
            success = [db executeUpdate:removeData];
            if(success){
                NSMutableString *sql = [NSMutableString string];
                for (City *city in cityList) {
                    [sql appendFormat:@"insert into City( CityId, CityName,SortOrder) values (%d,'%@',%d)",city.id,city.name,city.order];
                }
                success = [db executeUpdate:sql];
            }
            *rollback = !success;
        }
        @catch (NSException *exception) {
            NSLog(@"refresh city failed: %@",exception);
            *rollback = YES;
            return ;
        }
        @finally {
            
        }
    }];
}



- (NSDictionary *)getCityList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"Select * from City WHERE ParentId = 0 order by FirstChar asc"];
        while ([set next]) {
            City *city = [City new];
            city.id = [set intForColumn:@"CityId"];
            city.name = [set stringForColumn:@"CityName"];
            city.order = [set intForColumn:@"SortOrder"];
            city.firstChar = [set stringForColumn:@"FirstChar"];
            
            NSMutableArray *array = [dic objectForKey:city.firstChar];
            if(array == nil){
                array = [NSMutableArray array];
                [dic setObject:array forKey:city.firstChar];
            }
            [array addObject:city];
        }
        [set close];
        [db close];
    }

    return dic;
}

- (NSArray *)getAreaListByCity:(int)cityCode
{
    NSMutableArray *array = [NSMutableArray array];

    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"Select * from City WHERE ParentId = %d order by FirstChar asc", cityCode]];
        while ([set next]) {
            City *city = [City new];
            city.id = [set intForColumn:@"CityId"];
            city.name = [set stringForColumn:@"CityName"];
            city.order = [set intForColumn:@"SortOrder"];
            city.firstChar = [set stringForColumn:@"FirstChar"];

            [array addObject:city];
        }
        [set close];
        [db close];
    }

    return array;
}

- (City *)getSelectedCity
{
    City *city;
    int cityId = [[SettingManager SharedInstance] selectedCityId];
    if(cityId > 0){
        FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
        if ([db open]) {
            FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"Select * from City where CityId = %d", cityId]];
            while ([set next]) {
                city = [City new];
                city.id = [set intForColumn:@"CityId"];
                city.name = [set stringForColumn:@"CityName"];
                city.order = [set intForColumn:@"SortOrder"];
            }
            [set close];
            [db close];
        }
    }
    return city;
}

- (void)setSelectedCity:(int )cityId
{
    [[SettingManager SharedInstance] setSelectedCityId:cityId];
}


- (City *)getLocatedCity
{
    City *city;
    int cityId = [[SettingManager SharedInstance] locatedCityId];
    if(cityId > 0){
        FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
        if ([db open]) {
            FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"Select * from City where CityId = %d", cityId]];
            while ([set next]) {
                city = [City new];
                city.id = [set intForColumn:@"CityId"];
                city.name = [set stringForColumn:@"CityName"];
                city.order = [set intForColumn:@"SortOrder"];
            }
            [set close];
            [db close];
        }
    }
    return city;
}
- (void)setLocatedCity:(int)cityId
{
    [[SettingManager SharedInstance] setLocatedCityId:cityId];
}


- (City *)getCityByName:(NSString *)cityName
{
    City *city = [City new];
    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"Select * from City Where CityName like '%%%@%%'", cityName]];
        if ([set next]) {
            city.id = [set intForColumn:@"CityId"];
            city.name = [set stringForColumn:@"CityName"];
            city.order = [set intForColumn:@"SortOrder"];
        }
        [set close];
        [db close];
    }
    return city;
}
@end
