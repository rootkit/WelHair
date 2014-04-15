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

#import "City.h"

@interface Address : NSObject

@property (nonatomic) int id;

@property (nonatomic) BOOL isDefault;

@property (nonatomic, strong) City *city;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *detailAddress;

- (Address *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromAddress:(Address *)address;

@end
