//
//  WorkCardView.h
//  WelHair
//
//  Created by lu larry on 3/6/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
@interface WorkCardView : UIView

- (float) setupWithData:(Work *)workData
                  width:(float)width;

@end
