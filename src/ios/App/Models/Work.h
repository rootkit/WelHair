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

typedef NS_ENUM(NSInteger, HairStyleEnum) {
    HairStyleEnumLong = 1,
    HairStyleEnumMiddle = 2,
    HairStyleEnumShort = 3
};

typedef NS_ENUM(NSInteger, HairQualityEnum) {
    HairQualityHeavy = 1,
    HairQualityMiddle = 2,
    HairQualityLittle = 3
};

typedef NS_ENUM(NSInteger, GenderEnum) {
    GenderEnumUnspecific = 0,
    GenderEnumMale = 1,
    GenderEnumFemale= 2
};

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

// hair quality
@property (nonatomic) HairStyleEnum hairQuality;
// hair style
@property (nonatomic) HairQualityEnum hairStyle;

//
@property (nonatomic) GenderEnum gender;

@end
