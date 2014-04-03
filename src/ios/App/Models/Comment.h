//
//  Comment.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

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
