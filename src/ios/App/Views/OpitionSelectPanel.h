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

#import "SelectOpition.h"
#import "Staff.h"

typedef void(^cancelSelection)(void);
typedef void(^submitSelection)(SelectOpition *);

@interface OpitionSelectPanel : UIView

- (void)setupData:(Staff *)staff
         opitions:(SelectOpition *)selectOptioin
           cancel:(cancelSelection )cancelHandler
           submit:(submitSelection )submitHandler;


@end
