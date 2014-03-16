//
//  OpitionButton.h
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpitionItem.h"
@interface OpitionButton : UIButton

@property (nonatomic )BOOL choosen;
@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, strong) OpitionItem *opitionItem;

@end
