//
//  ProductCell.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductCell : UITableViewCell

- (void)setupWithLeftData:(Product *)leftData
                rightData:(Product *)rightData
               tapHandler:(CardTapHandler)tapHandler;

@end
