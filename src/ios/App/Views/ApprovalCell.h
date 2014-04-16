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
#import "Staff.h"
@protocol ApprovalCellDelegate <NSObject>

- (void)didTapStaff:(Staff *)staff;

@end

@interface ApprovalCell : UITableViewCell
@property (nonatomic, weak) id<ApprovalCellDelegate> delegate;

- (void)setup:(NSDictionary *)dic;

@end
