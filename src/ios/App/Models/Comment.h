//
//  Comment.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (nonatomic) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *commentorId;
@property (nonatomic, strong) NSString *commentorAvatorUrl;
@property (nonatomic, strong) NSString *commentorName;
@end
