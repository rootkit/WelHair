//
//  WelQRReaderViewController.h
//  WelHair
//
//  Created by lu larry on 2/24/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ZXingObjC.h"
@protocol WelQRReaderDelegate;
@interface WelQRReaderViewController : UIViewController<ZXCaptureDelegate>

@property (nonatomic, weak) id<WelQRReaderDelegate> delegate;


@end

@protocol WelQRReaderDelegate

- (void) didCaptureText:(NSString *)result
            welQRReader:(WelQRReaderViewController *)readerVc;

- (void) didCancelWe:(WelQRReaderViewController *)readerVc;
@end

