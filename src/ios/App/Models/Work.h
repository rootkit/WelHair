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
#import "BaseModel.h"
@interface Work : BaseModel
@property (nonatomic, strong) NSArray *imgUrlList;

@property (nonatomic, strong) Staff *creator;
@property (nonatomic, strong) NSArray *commentList;

// work param
// face sytle
@property (nonatomic) BOOL faceStyleLong;
@property (nonatomic) BOOL faceStyleSquare;
@property (nonatomic) BOOL faceStyleCircle;
@property (nonatomic) BOOL faceStyleGuaZi;
// hair style
@property (nonatomic) BOOL hairStyleLong;
@property (nonatomic) BOOL hairStyleMiddle;
@property (nonatomic) BOOL hairStyleShort;
// hair quality
@property (nonatomic) BOOL hairQualityHeavy;
@property (nonatomic) BOOL hairQualityMiddle;
@property (nonatomic) BOOL hairQualityLittle;
//
@property (nonatomic) BOOL forMale;

@end
