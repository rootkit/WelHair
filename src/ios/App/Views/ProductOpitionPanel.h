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

#import <Foundation/Foundation.h>
#import "SelectOpition.h"
#import "Product.h"
#import "Order.h"
typedef void(^cancelSelection)(void);
typedef void(^submitSelection)(SelectOpition *);

@interface ProductOpitionPanel : UIView


- (void)setupTitle:(NSString *)title
          opitions:(SelectOpition *)selectOptioin
             order:(Order *)order
            cancel:(cancelSelection )cancelHandler
            submit:(submitSelection )submitHandler;
;


@end
