//
//  OrderPreviewViewController.h
//  WelHair
//
//  Created by lu larry on 3/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BaseViewController.h"
#import "Order.h"
@interface OrderPreviewViewController : BaseViewController
@property (nonatomic) BOOL isAddressFilled;
@property (nonatomic, strong) Order *order;
@end
