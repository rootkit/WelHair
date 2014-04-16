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

#import <Foundation/Foundation.h>
#import "OpitionCategory.h"

@interface SelectOpition : NSObject

@property (nonatomic, strong) NSArray *opitionCateogries;
@property (nonatomic, strong) NSArray *selectedValues;
@property (nonatomic) float count;

- (NSArray *) unselectedCategory;

@end
