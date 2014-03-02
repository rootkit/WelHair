//
//  OpitionCategory.h
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpitionItem.h"

@interface OpitionCategory : NSObject
@property (nonatomic) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *opitionItems;
@property (nonatomic, strong) OpitionItem *selectedItem;
@end
