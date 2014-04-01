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

@interface BaseViewController : UIViewController

@property (nonatomic, assign) float topBarOffset;
@property (nonatomic, assign) float bottomBarOffset;

@property (nonatomic, strong) UIImage *leftNavItemImg;
@property (nonatomic, strong) UIImage *rightNavItemImg;

@property (nonatomic, strong) NSString *leftNavItemTitle;
@property (nonatomic, strong) NSString *rightNavItemTitle; 

- (float)contentHeightWithNavgationBar:(BOOL)showNav
                     withBottomBar:(BOOL)showBottom;
- (void)leftNavItemClick;

- (void)rightNavItemClick;

- (void)setTopLeftCityName;
@end
