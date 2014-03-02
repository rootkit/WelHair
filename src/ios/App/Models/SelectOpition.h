//
//  SelectOpitions.h
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpitionCategory.h"

@interface SelectOpitions : NSObject

@property (nonatomic, strong) NSArray *opitionCateogries;

@property (nonatomic) float count;

- (BOOL) isValid;

- (NSArray *)selectedValue;
@end
