//
//  AddressView.h
//  WelHair
//
//  Created by lu larry on 3/30/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
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
