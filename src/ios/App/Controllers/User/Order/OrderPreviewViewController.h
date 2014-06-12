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

#import "Order.h"
#import "ProductDetailViewController.h"

@interface OrderPreviewViewController : BaseViewController

@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) ProductDetailViewController *productDetailController;

@end
