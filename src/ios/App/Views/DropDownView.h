//
//  DropDownView.h
//  WelHair
//
//  Created by lu larry on 3/9/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropDownDelegate

- (void)didPickItemAtIndex:(int)index
                   forView:(UIView *)view;

@end

@interface DropDownView : UIView
@property (nonatomic, weak) id<DropDownDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
      contentHeight:(float) contentHeight;

- (void)showData:(NSArray *)datasource
   selectedIndex:(int)selectedIndex
     pointToView:(UIView *)view;

- (void)hide;
@end
