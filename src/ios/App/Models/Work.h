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
#import "Staff.h"
@interface Work : NSObject
@property (nonatomic) int Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *imgsUrl;

@property (nonatomic, strong) Staff *creator;
@property (nonatomic, strong) NSArray *comments;


@end
