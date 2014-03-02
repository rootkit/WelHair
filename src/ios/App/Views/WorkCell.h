//
//  WorkCell.h
//  WelHair
//
//  Created by lu larry on 2/28/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imgTapHandler)(int);

@interface WorkCell : UITableViewCell

- (void)setupWithLeftData:(NSString *)leftData
                rightData:(NSString *)rightData
               tapHandler:(imgTapHandler)tapHandler;

@end
