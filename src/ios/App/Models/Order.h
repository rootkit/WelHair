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
@interface Order : BaseModel

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) Product *product;
@property (nonatomic) int count;
@property (nonatomic) float price;
@property (nonatomic, strong) Address *address;
@end
