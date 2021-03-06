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
typedef void (^CommentOrderHandler)(int goodId);

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) BaseViewController *baseController;

- (void)setup:(NSDictionary *)order commentHandler:(CommentOrderHandler)commentHalder;

@end
