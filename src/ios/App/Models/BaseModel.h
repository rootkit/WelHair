//
//  BaseModel.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic) int id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) float distance;

@end
