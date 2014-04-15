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

#import "Address.h"

@protocol AddressCellDelegate;

@interface AddressCell : UITableViewCell

@property (nonatomic, weak) id<AddressCellDelegate> delegate;

- (void)setup:(Address *)address;
- (void)setPicked:(BOOL)picked;

@end

@protocol AddressCellDelegate <NSObject>

- (void)addressCell:(AddressCell *)addressCell
        didSelected:(Address *)address;

- (void)addressCell:(AddressCell *)addressCell
       didClickEdit:(Address *)address;

@end