//
//  Coupon.h
//  WelHair
//
//  Created by lu larry on 3/12/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"

@interface Coupon : BaseModel
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *phoneNum;
@end
