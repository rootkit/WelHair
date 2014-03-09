//
//  DoubleCoverCell.h
//  WelHair
//
//  Created by lu larry on 3/9/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"

@interface DoubleCoverCell : UITableViewCell

- (void)setupWithLeftData:(Work *)leftData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler;

@end
