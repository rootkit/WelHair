//
//  SelectOpitions.h
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpitionCategory.h"

@interface SelectOpition : NSObject

@property (nonatomic, strong) NSArray *opitionCateogries;
@property (nonatomic, strong) NSArray *selectedValues;
@property (nonatomic) float count;

- (NSArray *) unselectedCategory;

@end
