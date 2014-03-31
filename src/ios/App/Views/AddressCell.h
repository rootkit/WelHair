//
//  AppointmentCell.h
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
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