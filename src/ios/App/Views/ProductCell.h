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

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductCell : UITableViewCell

- (void)setupWithLeftData:(Product *)leftData
                rightData:(Product *)rightData
               tapHandler:(CardTapHandler)tapHandler;

@end
