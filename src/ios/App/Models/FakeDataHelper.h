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

#import <Foundation/Foundation.h>
#import "Group.h"
#import "Address.h"
@interface FakeDataHelper : NSObject

+(id)SharedInstance;

+(NSArray *)getFakeHairWorkImgs;
+(NSArray *)getFakeWorkList;
+(NSArray *)getFakeGroupList;
+(NSArray *)getFakeProductList;
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
