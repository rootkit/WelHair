//
//  MyScoreCell.h
//  WelHair
//
//  Created by lu larry on 3/20/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScoreCell : UITableViewCell
- (void)setup:(NSDictionary  *)data
        isTop:(BOOL)isTop
     isBottom:(BOOL)isBottom;
@end
