//
//  TripleCoverCell.h
//  WelHair
//
//  Created by lu larry on 3/9/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"

@interface TripleCoverCell : UITableViewCell

- (void)setupWithLeftData:(Work *)leftData
                middleData:(Work *)middleData
                rightData:(Work *)rightData
               tapHandler:(CardTapHandler)tapHandler;


@end
