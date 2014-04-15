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

#import "BaseViewController.h"

@protocol AddressPickDeleate <NSObject>

- (void)didPickAddress:(Address *)address;

@end

@interface AddressListViewController : BaseViewController

@property (nonatomic) BOOL isPickingAddress;
@property (nonatomic) Address *pickedAddress;

@property (nonatomic, weak) id<AddressPickDeleate> delegate;

@end
