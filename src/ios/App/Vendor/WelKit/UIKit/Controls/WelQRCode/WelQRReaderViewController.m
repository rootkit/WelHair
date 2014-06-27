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
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "WelQRReaderViewController.h"

@interface WelQRReaderViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    
    UIView *overlayView;
}

@end

@implementation WelQRReaderViewController

static float CenterSquareSize = 200;

#pragma mark - View Controller Methods

- (id)init{
    self = [super init];
    if(self){
        self.leftNavItemTitle = @"取消";
        self.rightNavItemTitle = @"相册";
        self.title = @"扫描二维码";
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

- (void)leftNavItemClick
{
    [self cancel];
}

- (void)rightNavItemClick
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}

- (void) loadView
{
    [super loadView];
    
    float scannerHeight = [self contentHeightWithNavgationBar:YES withBottomBar:NO];
    scannerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           self.topBarOffset,
                                                           WIDTH(self.view),
                                                           scannerHeight)];
    scannerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scannerView];
    
    overlayView = [[UIView alloc] initWithFrame:scannerView.frame];
    [self.view addSubview:overlayView];
    overlayView.hidden = YES;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, (scannerHeight - CenterSquareSize)/2 , CenterSquareSize, CenterSquareSize)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [overlayView addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    line = [[UIImageView alloc] initWithFrame:CGRectMake(70, Y(imageView), CenterSquareSize - 20, 2)];
    line.image = [UIImage imageNamed:@"line.png"];
    [overlayView addSubview:line];
    
    float overlayAlpha = 0.7;
    UIView *topOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), (scannerHeight - CenterSquareSize)/2)];
    topOverlayView.backgroundColor = [UIColor blackColor];
    topOverlayView.alpha = overlayAlpha;
    [overlayView addSubview:topOverlayView];
    
    UIView *leftOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(topOverlayView), 60, CenterSquareSize)];
    leftOverlayView.backgroundColor = [UIColor blackColor];
    leftOverlayView.alpha = overlayAlpha;
    [overlayView addSubview:leftOverlayView];
    
    UIView *bottomOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(leftOverlayView), WIDTH(self.view), HEIGHT(scannerView) - MaxY(leftOverlayView))];
    bottomOverlayView.backgroundColor = [UIColor blackColor];
    bottomOverlayView.alpha = overlayAlpha;
    [overlayView addSubview:bottomOverlayView];
    
    UIView *rightOverlayView = [[UIView alloc] initWithFrame:CGRectMake(260, MaxY(topOverlayView), 60, CenterSquareSize)];
    rightOverlayView.backgroundColor = [UIColor blackColor];
    rightOverlayView.alpha = overlayAlpha;
    [overlayView addSubview:rightOverlayView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!isCameraInited) {
        [SVProgressHUD show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGImageRef imageToDecode = pickedImg.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError* error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints* hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
    ZXResult* result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        isCaptured = YES;
        [self playSound];
        [self cancel];
        [self.delegate didCaptureText:result.text welQRReaderViewController:self];
        
        // The barcode format, such as a QR code or UPC-A
        // ZXBarcodeFormat format = result.barcodeFormat;
    } else {
        [SVProgressHUD showErrorWithStatus:@"未识别的二维码" duration:1];
        [self cancel];
    }
}

- (void)startScan
{
    capture.layer.frame = scannerView.bounds;
    [scannerView.layer addSublayer:capture.layer];
    overlayView.hidden = NO;
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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)lineAnimation
{
    float height = (HEIGHT(scannerView) - CenterSquareSize)/2;
    if (upOrdown == NO) {
        num ++;
        line.frame = CGRectMake(70, height+2*num, 180, 2);
        if (2*num == 190) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        line.frame = CGRectMake(70, height+2*num, 180, 2);
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

- (void)playSound
{
    SystemSoundID SoundID;
    NSURL *buttonURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"flush" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonURL, &SoundID);
    AudioServicesPlaySystemSound(SoundID);
}


- (void)cancel
{
    [timer invalidate];
    [capture stop];
    [capture.layer removeFromSuperlayer];
    capture.delegate = nil;
    [self.delegate didCancelWelQRReaderViewController:self];
}

@end