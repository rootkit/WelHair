//
//  ChatSession.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseModel.h"

@interface ChatSession : BaseModel
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSDate *lastDate;
@end
