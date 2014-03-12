//
//  Group.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Group : BaseModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *imgUrls;
@property (nonatomic, strong) NSArray *staffList;
@property (nonatomic, strong) NSArray *commentList;

@end
