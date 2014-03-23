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
                    [sql appendFormat:@"insert into City( CityId, CityName,Order) values (%d,'%@',%d)",city.id,city.name,city.order];
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



- (NSArray *)getCityList
{
    NSMutableArray *list =[NSMutableArray array];
    FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"Select * from City order"];
        while ([set next]) {
            City *city = [City new];
            city.id = [set intForColumn:@"CityId"];
            city.name = [set stringForColumn:@"CityName"];
            city.order = [set intForColumn:@"Order"];
            [list addObject:city];
        }
        [set close];
        [db close];
    }
    return list;
}

- (City *)selectedCity
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
                city.order = [set intForColumn:@"Order"];
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

@end
