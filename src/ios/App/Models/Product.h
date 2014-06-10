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
#import "Group.h"

@interface Product : BaseModel

@property (nonatomic) float price;
@property (nonatomic, strong) Group *group;

@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) NSArray *imgUrlList;
@property (nonatomic, strong) NSArray *attrList;
@property (nonatomic, strong) NSArray *specList;
@property (nonatomic, strong) NSArray *productList;

@property (nonatomic) BOOL isLiked;

- (Product *)initWithDic:(NSDictionary *)dictionary;

@end
