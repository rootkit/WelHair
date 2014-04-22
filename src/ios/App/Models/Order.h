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
#import "Group.h"
#import "Product.h"
#import "Order.h"

typedef NS_ENUM(NSInteger, OrderStatusEnum) {
    OrderStatusEnum_UnPaid = 0,
    OrderStatusEnum_Paid = 1
};

@interface Order : BaseModel

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSMutableDictionary *productSelectedSpecs;
@property (nonatomic) int count;
@property (nonatomic) float price; // total price
@property (nonatomic) float singleProductPrice; // total price
@property (nonatomic) OrderStatusEnum status;
@property (nonatomic, strong) Address *address;

// check if need pick spec
- (NSString *)unSelectedSpecStr;

- (NSString *)selectedSpecStr;
@end

