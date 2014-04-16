// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

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
