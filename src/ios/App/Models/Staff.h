//
//  Staff.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Staff : BaseModel

@property (nonatomic, strong) NSString *avatorUrl;
@property (nonatomic) float rate;
@property (nonatomic) int groupId;
@property (nonatomic, strong) NSString *groupName;

@end
