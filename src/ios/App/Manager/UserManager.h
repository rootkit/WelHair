//
//  UserManager.h
//  WelHair
//
//  Created by lu larry on 3/23/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseManager.h"
#import "User.h"
@interface UserManager : BaseManager
@property (nonatomic, strong) User *userLogined;
+(id)SharedInstance;
- (void)signout;

@end
