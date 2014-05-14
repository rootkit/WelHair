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

#import "Message.h"
#import "UserManager.h"
#import "SettingManager.h"
#import "WebSocketUtil.h"

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
                    user.groupId = [set intForColumn:@"GroupId"];
                    user.email = [set stringForColumn:@"Email"];
                    user.username = [set stringForColumn:@"UserName"];
                    user.nickname = [set stringForColumn:@"NickName"];
                    user.avatarUrl = [NSURL URLWithString:[set stringForColumn:@"AvatorUrl"]];
                    user.role = [set intForColumn:@"Role"];
                    user.followed = [set boolForColumn:@"Followed"];
                    user.approveStatus = [set intForColumn:@"ApproveStatus"];
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
            BOOL runSqlSuccess = NO;
            if ([set next]) {
                userSql = @"update User set GroupId = ?, UserName = ?, Email = ?,AvatorUrl = ?,NickName = ?, Role = ?, Followed = ?, ApproveStatus = ? where UserId = ?";
               runSqlSuccess  = [db executeUpdate:userSql,
                                 @(userLogined.groupId),
                                   userLogined.username,
                                   userLogined.email,
                                   userLogined.avatarUrl,
                                   userLogined.nickname,
                                   @(userLogined.role),
                                   @(userLogined.followed),
                                   @(userLogined.approveStatus),
                                 @(userLogined.id)];
            }else{
                userSql = @"insert into User (UserId, GroupId, UserName, Email,AvatorUrl,NickName, Role, Followed, ApproveStatus) values(?,?,?,?,?,?,?,?,?) ";
                runSqlSuccess  = [db executeUpdate:userSql,
                                   @(userLogined.id),
                                    @(userLogined.groupId),
                                  userLogined.username,
                                  userLogined.email,
                                  userLogined.avatarUrl,
                                  userLogined.nickname,
                                  @(userLogined.role),
                                  @(userLogined.followed),
                                  @(userLogined.approveStatus)];
            }
            [set close];
  
            if (!runSqlSuccess) {
                *rollback = YES;
                debugLog(@"error when set user online");
            } else {
                _userLogined = userLogined;
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
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dicData setObject:[NSNumber numberWithInt:0] forKey:@"UserId"];
    [dicData setObject:[NSNumber numberWithInt:WHMessageTypeUpdateUser] forKey:@"Type"];

    NSString *message = [Util parseJsonFromObject:dicData];
   // [[WebSocketUtil sharedInstance].webSocket send:message];

    [[SettingManager SharedInstance] setLoginedUserId:0];
    _userLogined = nil;
}
@end
