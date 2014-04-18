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

#import "ZXingObjC.h"
#import "WFViewController.h"
@protocol WelQRReaderDelegate;
@interface WelQRReaderViewController : WFViewController<ZXCaptureDelegate>

@property (nonatomic, weak) id<WelQRReaderDelegate> delegate;

@end

@protocol WelQRReaderDelegate

- (void) didCaptureText:(NSString *)result
            welQRReaderViewController:(WelQRReaderViewController *)readerVc;

- (void) didCancelWelQRReaderViewController:(WelQRReaderViewController *)readerVc;
@end

