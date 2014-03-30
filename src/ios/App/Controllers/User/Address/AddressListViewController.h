//
//  AddressListViewController.h
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddressPickDeleate <NSObject>

- (void)didPickAddress:(Address *)address;

@end

@interface AddressListViewController : BaseViewController
@property (nonatomic) Address *pickedAddress;

@property (nonatomic, weak) id<AddressPickDeleate> delegate;
@end
