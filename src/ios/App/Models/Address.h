//
//  Address.h
//  WelHair
//
//  Created by lu larry on 3/30/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic) int id;
@property (nonatomic) BOOL isDefault;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *detailAddress;


@end
