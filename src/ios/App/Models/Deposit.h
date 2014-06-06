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

#import "BaseModel.h"

typedef enum {
    WHDepositStatusFailed = 0,
    WHDepositStatusSuccess = 1
} WHDepositStatus;

@interface Deposit : BaseModel

@property (nonatomic, strong) NSString *depositNo;
@property (nonatomic, assign) WHDepositStatus status;
@property (nonatomic, assign) float amount;

@property (nonatomic, strong) NSDate *createdDate;

- (Deposit *)initWithDic:(NSDictionary *)dictionary;

@end
