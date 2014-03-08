//
//  WorkCell.h
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"

@interface WorkCell : UITableViewCell

- (void)setupWithLeftData:(Work *)leftData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler;

@end
