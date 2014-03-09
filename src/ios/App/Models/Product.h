//
//  Product.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Group.h"
@interface Product : BaseModel

@property (nonatomic) float price;
@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) NSArray *imgUrlList;

@end
