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
#import "User.h"

@interface Comment : BaseModel

@property (nonatomic, strong) NSArray *imgUrlList;

@property (nonatomic) int rate;

@property (nonatomic, strong) User *commentor;

@property (nonatomic, strong) NSDate *createdDate;


- (Comment *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromComment:(Comment *)comment;

@end
