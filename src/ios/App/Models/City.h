//
//  City.h
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"

@interface City : BaseModel

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int order;

- (City *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromUser:(City *)city;

@end
