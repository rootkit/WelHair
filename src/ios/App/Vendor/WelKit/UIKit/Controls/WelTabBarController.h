//
//  WelTabBarController.h
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelTabBarController : UITabBarController {
}

-(void)setupViewControls:(NSArray *)viewControls
               tabHeight:(float)tabHeight
         tabNormalImages:(NSArray *)tabNormalImages
       tabSelectedImages:(NSArray *)tabSelectedImages;

- (void)hideTabBarAnimation:(BOOL)animation;
- (void)showTabBarAnimation:(BOOL)animation;

@end
