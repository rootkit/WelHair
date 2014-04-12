// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "OpitionItem.h"

@interface OpitionButton : UIButton

@property (nonatomic )BOOL choosen;
@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, strong) OpitionItem *opitionItem;

@end
