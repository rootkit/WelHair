//
//  FakeDataHelper.h
//  WelHair
//
//  Created by lu larry on 3/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"
#import "Address.h"
@interface FakeDataHelper : NSObject

+(id)SharedInstance;

+(NSArray *)getFakeHairWorkImgs;
+(NSArray *)getFakeWorkList;
+(NSArray *)getFakeGroupList;
+(NSArray *)getFakeProductList;
+(NSArray *)getFakeChatGroupList;
+(NSArray *)getFakeCommentList;
+(NSArray *)getFakeStaffList;
+ (Group *)getFakeGroup;
+(NSArray *)getFakeCouponList;
+(NSArray *)getFakeAddressLit;
+(Address *)getFakeDefaultAddress;
+ (NSArray *)getFakeServiceList;
+(NSArray *)getFakeAppointmentList;
+ (NSArray *)getFakeOrderList:(BOOL)paid;

+ (bool)isLogin;
+ (void)login;
+ (void)logout;
+ (void)setUserCreateGroupSuccess;
+ (void)setUserJoinGroupSuccess;
+ (BOOL)isUserGroupAdmin;
+ (BOOL)isUserGroupStaff;
+ (void)savePickedCity:(NSString *)cityName;
+ (NSString *)getPickedCity;

@end
