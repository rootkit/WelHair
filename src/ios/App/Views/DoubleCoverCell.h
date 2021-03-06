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

#import "Work.h"

@interface DoubleCoverCell : UITableViewCell

- (void)setupWithLeftData:(Work *)leftData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler;

@end
