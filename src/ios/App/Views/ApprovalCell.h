//
//  ApprovalCell.h
//  WelHair
//
//  Created by lu larry on 4/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Staff.h"
@protocol ApprovalCellDelegate <NSObject>

- (void)didTapStaff:(Staff *)staff;

@end

@interface ApprovalCell : UITableViewCell
@property (nonatomic, weak) id<ApprovalCellDelegate> delegate;

- (void)setup:(NSDictionary *)dic;

@end
