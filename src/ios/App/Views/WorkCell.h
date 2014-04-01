//
//  WorkCell.h
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "BrickView.h"
#import "Work.h"

@interface WorkCell : BrickViewCell

- (void)setupWithData:(Work *)leftData tapHandler:(CardTapHandler)tapHandler;

@end
