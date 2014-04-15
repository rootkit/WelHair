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


@protocol AddressViewDelegate;

@interface AddressView : UIView

@property (nonatomic, weak) id<AddressViewDelegate> delegate;
@property (nonatomic) BOOL selected;

- (void)setup:(Address *)address
     editable:(BOOL)editable
   selectable:(BOOL)selectable;

@end

@protocol AddressViewDelegate <NSObject>

- (void)addressView:(AddressView *)addressView
        didSelected:(Address *)address;

- (void)addressView:(AddressView *)addressView
       didClickEdit:(Address *)address;

@end
