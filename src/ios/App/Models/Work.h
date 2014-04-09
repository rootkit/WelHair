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

#import "BaseModel.h"
#import "Comment.h"
#import "Staff.h"

typedef NS_ENUM(int, HairStyleEnum) {
    HairStyleEnumShort = 1,
    HairStyleEnumLong = 2,
    HairStyleEnumPlait = 3,
    HairStyleEnumMiddle = 4,
};

typedef NS_ENUM(int, HairQualityEnum) {
    HairQualityHeavy = 1,
    HairQualityMiddle = 2,
    HairQualityLittle = 3
};

typedef NS_ENUM(int, GenderEnum) {
    GenderEnumUnspecific = 0,
    GenderEnumMale = 1,
    GenderEnumFemale= 2
};

@interface Work : BaseModel

@property (nonatomic, strong) NSArray *imgUrlList;

@property (nonatomic) BOOL isfav;
@property (nonatomic, strong) Staff *creator;

@property (nonatomic, strong) Comment *lastComment;
@property (nonatomic) int commentCount;

// work param
// face sytle
@property (nonatomic) BOOL faceStyleCircle;
@property (nonatomic) BOOL faceStyleGuaZi;
@property (nonatomic) BOOL faceStyleSquare;
@property (nonatomic) BOOL faceStyleLong;

// hair quality
@property (nonatomic) HairQualityEnum hairQuality;
// hair style
@property (nonatomic) HairStyleEnum hairStyle;
// gender
@property (nonatomic) GenderEnum gender;


- (Work *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromWork:(Work *)work;

@end
