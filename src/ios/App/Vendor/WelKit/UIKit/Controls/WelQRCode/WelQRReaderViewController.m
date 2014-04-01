//
//  WelQRReaderViewController.m
//  WelHair
//
//  Created by lu larry on 2/24/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WelQRReaderViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface WelQRReaderViewController ()
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    ZXCapture *capture;
    BOOL isCaptured;
    UIImageView  *line;
    
    UIView *scannerView;
}

@end

@implementation WelQRReaderViewController

#pragma mark - View Controller Methods

- (void) loadView
{
    [super loadView];
    
    scannerView = [[UIView alloc] initWithFrame:self.view.bounds];
    scannerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scannerView];
    [SVProgressHUD show];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 240, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=3;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右。";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, 200, 200)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    line = [[UIImageView alloc] initWithFrame:CGRectMake(70, 110, 180, 2)];
    line.image = [UIImage imageNamed:@"line.png"];
    line.hidden = YES;
    [self.view addSubview:line];
    

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =CGRectMake(0,
                              HEIGHT(self.view) - kToolBarHeight,
                              WIDTH(self.view),
                              kToolBarHeight);
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancelBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self performSelector:@selector(startScan) withObject:nil afterDelay:1];
}

- (void)startScan
{
    capture = [[ZXCapture alloc] init];
    capture.delegate = self;
    capture.rotation = 90.0f;
    // Use the back camera
    capture.camera = capture.back;
    capture.layer.frame = self.view.bounds;
    [scannerView.layer addSublayer:capture.layer];
    scannerView.backgroundColor = [UIColor clearColor];
    line.hidden = NO;
    [SVProgressHUD dismiss];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];

}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
//}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)lineAnimation
{
    if (upOrdown == NO) {
        num ++;
        line.frame = CGRectMake(70, 110+2*num, 180, 2);
        if (2*num == 190) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        line.frame = CGRectMake(70, 110+2*num, 180, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result && !isCaptured) {
        isCaptured = YES;
        [self playSound];
        [self cancel];
        [self.delegate didCaptureText:result.text welQRReaderViewController:self];
    }
}


- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
    
}

- (void) playSound
{
    SystemSoundID SoundID;
    NSURL *buttonURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"flush" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonURL, &SoundID);
    AudioServicesPlaySystemSound(SoundID);
}


- (void)cancel
{
    [timer invalidate];
    [capture.layer removeFromSuperlayer];
    [capture stop];
    [self.delegate didCancelWelQRReaderViewController:self];
}
@end