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
#import "WelQRReaderViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface WelQRReaderViewController ()
{
    BOOL isCameraInited;
    NSTimer *cameraInitedTimer;
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

- (id)init{
    self = [super init];
    if(self){
        cameraInitedTimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(checkCameraInited) userInfo:nil repeats:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            capture = [[ZXCapture alloc] init];
            capture.delegate = self;
            capture.rotation = 90.0f;
            // Use the back camera
            capture.camera = capture.back;
            isCameraInited = YES;
        });
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    scannerView = [[UIView alloc] initWithFrame:self.view.bounds];
    scannerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scannerView];
    
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
    if(!isCameraInited){
        [SVProgressHUD show];
    }
}

- (void)showRoundOverlayView
{
    UIView *topOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
    topOverlayView.backgroundColor = [UIColor blackColor];
    topOverlayView.alpha = 0.5;
    [self.view addSubview:topOverlayView];
    
    UIView *leftOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(topOverlayView), 60, 200)];
    leftOverlayView.backgroundColor = [UIColor blackColor];
    leftOverlayView.alpha = 0.5;
    [self.view addSubview:leftOverlayView];
    
    UIView *bottomOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(leftOverlayView), WIDTH(self.view), HEIGHT(self.view) - MaxY(leftOverlayView) - kToolBarHeight)];
    bottomOverlayView.backgroundColor = [UIColor blackColor];
    bottomOverlayView.alpha = 0.5;
    [self.view addSubview:bottomOverlayView];
    
    UIView *rightOverlayView = [[UIView alloc] initWithFrame:CGRectMake(260, MaxY(topOverlayView), 60, 200)];
    rightOverlayView.backgroundColor = [UIColor blackColor];
    rightOverlayView.alpha = 0.5;
    [self.view addSubview:rightOverlayView];
}

- (void)startScan
{
    capture.layer.frame = self.view.bounds;
    [scannerView.layer addSublayer:capture.layer];
    scannerView.backgroundColor = [UIColor clearColor];
    line.hidden = NO;
    [self showRoundOverlayView];
    [SVProgressHUD dismiss];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];

}

- (void)checkCameraInited
{
    if (isCameraInited) {
        [cameraInitedTimer invalidate];
        [SVProgressHUD dismiss];
        [self startScan];
    }
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