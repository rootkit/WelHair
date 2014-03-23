//
//  UserManager.m
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "UserManager.h"
#import "SettingManager.h"
@implementation UserManager
@synthesize userLogined = _userLogined;


+(id)SharedInstance
{
    static UserManager *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserManager alloc] init];
    });
    return sharedInstance;
}

#pragma User related

- (User *)userLogined
{
    if(!_userLogined){
        int userId = [[SettingManager SharedInstance] loginedUserId];
        if(userId > 0){
            FMDatabase * db = [FMDatabase databaseWithPath:self.databasePath];
            User *user;
            if ([db open]) {
                NSString *findUser =[NSString stringWithFormat:@"select * from User where UserId = %d ",userId];
                FMResultSet *set = [db executeQuery:findUser];
                while ([set next]) {
                    user = [[User alloc] init];
                    user.id = [set intForColumn:@"UserId"];
                    user.email = [set stringForColumn:@"Email"];
                    user.username = [set stringForColumn:@"UserName"];
                    user.nickname = [set stringForColumn:@"NickName"];
                    user.avatarUrl = [NSURL URLWithString:[set stringForColumn:@"AvatorUrl"]];
                    user.role = [set intForColumn:@"Role"];
                    user.followed = [set boolForColumn:@"Followed"];
                    _userLogined = user;
                    break;
                }
                [set close];
                [db close];
            }
        }
    }
    return _userLogined;
}


- (void)setUserLogined:(User *)userLogined
{
    if(userLogined.id <= 0){
        return;
    }
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            
#pragma update user table
            NSString *findUserSql =[NSString stringWithFormat:@"select * from User where UserId = %d", userLogined.id];
            FMResultSet *set = [db executeQuery:findUserSql];
            NSString *userSql;
            if ([set next]) {
                userSql = @"update User set UserId = ?, UserName = ?, Email = ?,AvatorUrl = ?,NickName = ?, Role = ?";
            }else{
                userSql = @"insert into User (UserId, UserName, Email,AvatorUrl,NickName, Role) values(?,?,?,?,?,?) ";
            }
            [set close];
            BOOL runSqlSuccess = [db executeUpdate:userSql,
                                  @(userLogined.id),
                             userLogined.username,
                             userLogined.email,
                             userLogined.avatarUrl,
                             userLogined.nickname,
                             @(userLogined.role)];

            
            if (!runSqlSuccess) {
                *rollback = YES;
                debugLog(@"error when set user online");
            } else {
                debugLog(@"succ to save user ");
            }
            
#pragma update setting table 
            NSString *findSettingValue =[NSString stringWithFormat:@"select * from Settings where SettingKey = '%@' ",DB_TABLE_SETTING_ONLINEUSERID];
            FMResultSet *settingSet = [db executeQuery:findSettingValue];
            NSString *settingSql ;
            if([settingSet next]){
                settingSql = @"update Settings set SettingValue = ? where SettingKey = ?";
            }else{
                settingSql = @"insert into Settings (SettingValue,SettingKey) values (?,?)";
            }
            
            runSqlSuccess = [db executeUpdate:settingSql,[NSString stringWithFormat:@"%d",userLogined.id],DB_TABLE_SETTING_ONLINEUSERID];
            if(!runSqlSuccess){
                *rollback= YES;
            }else{
                debugLog(@"success update setting  info");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"fail to set user online");
            *rollback = YES;
        }
        @finally {
        }
    }];
}

- (void)signout
{
    [[SettingManager SharedInstance] setLoginedUserId:0];
    _userLogined = nil;
}
@end
