//
//  Order.h
//  WelHair
//
//  Created by lu larry on 4/7/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"
#import "Group.h"
#import "Product.h"
#import "Order.h"

typedef NS_ENUM(NSInteger, OrderStatusEnum) {
    OrderStatusEnum_UnPaid = 0,
    OrderStatusEnum_Paid = 1
};

@interface Order : BaseModel

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) Product *product;
@property (nonatomic) int count;
@property (nonatomic) float price;
@property (nonatomic) OrderStatusEnum status;
@property (nonatomic, strong) Address *address;
@end
