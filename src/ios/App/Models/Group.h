//
//  Group.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"
#import "City.h"

typedef enum {
    Invalid = 0,
    Valid = 1,
    Requested = 2
} WHGroupStatus;

@interface Group : BaseModel

@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *address;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSArray *imgUrls;

@property (nonatomic, strong) NSArray *staffList;
@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic) WHGroupStatus status;

@property (nonatomic) int rating;
@property (nonatomic) int staffCount;
@property (nonatomic) int commentCount;
@property (nonatomic) BOOL isLiked;


- (Group *)initWithDic:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromGroup:(Group *)group;

@end
