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

- (User *)loginUser;

- (void) logout;
@end
