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

typedef enum {
    WHWithdrawStatusPending = 0,
    WHWithdrawStatusSuccess = 1,
    WHWithdrawStatusFailed = 2
} WHWithdrawStatus;

@interface Withdraw : BaseModel

@property (nonatomic, strong) NSString *withdrawNo;
@property (nonatomic, assign) WHWithdrawStatus status;
@property (nonatomic, assign) float amount;

@property (nonatomic, strong) NSDate *createdDate;

- (Withdraw *)initWithDic:(NSDictionary *)dictionary;

@end
