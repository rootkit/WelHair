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

#define NOTIFICATION_PUSH_TO_PAIDORDER_PREVIEW_VIEW @"Notification_PushToPaidOrderPreviewView"

#import "OrderCell.h"
@interface OrderPaidTableView : UIView

@property (nonatomic, strong) BaseViewController *baseController;
@property (nonatomic, strong) CommentOrderHandler commentOrderHandler;
@end
