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

#import "OpitionButton.h"
#import "UploadWorkFormViewController.h"
#import "Work.h"
#import "CTAssetsPickerController.h"
#define  SelectedViewColor  @"206ba7"
#define  FaceStyleCircleNormal  @"UploadWorkViewControl_FaceStyleCircleNormal"
#define  FaceStyleCircleSelected  @"UploadWorkViewControl_FaceStyleCircleSelected"
#define  FaceStyleGuaZiNormal  @"UploadWorkViewControl_FaceStyleGuaZiNormal"
#define  FaceStyleGuaZiSelected  @"UploadWorkViewControl_FaceStyleGuaZiSelected"
#define  FaceStyleLongNormal  @"UploadWorkViewControl_FaceStyleLongNormal"
#define  FaceStyleLongSelected  @"UploadWorkViewControl_FaceStyleLongSelected"
#define  FaceStyleSquareNormal  @"UploadWorkViewControl_FaceStyleSquareNormal"
#define  FaceStyleSquareSelected  @"UploadWorkViewControl_FaceStyleSquareSelected"

#define  RequestUserInfoKeyUploadPictureIndex    @"UploadPictureIndex"

@interface UploadWorkFormViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) Work *work;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *infoTxtView;

@property (nonatomic, strong) UIImageView *uploadPic0;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator0;
@property (nonatomic, strong) UIImageView *uploadPic1;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator1;
@property (nonatomic, strong) UIImageView *uploadPic2;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator2;
@property (nonatomic, strong) UIImageView *uploadPic3;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator3;

@property (nonatomic, strong) NSMutableArray *uploadedPictures;

@property (nonatomic, strong) UIButton *selectedGenderBtn;
@property (nonatomic, strong) UIButton *selectedHairStylleBtn;
@property (nonatomic, strong) UIButton *selectedHairQualityBtn;

@end

@implementation UploadWorkFormViewController

static const float ScrollContentHeight = 420;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加作品";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"提交";

        self.uploadedPictures = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            self.uploadedPictures[i] = @"";
        }

        self.work = [Work new];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.infoTxtView.text forKey:@"Title"];
    [reqData setObject:@(self.work.gender) forKey:@"Gender"];
    [reqData setObject:@(self.work.hairStyle) forKey:@"HairStyle"];
    [reqData setObject:@(self.work.hairQuality) forKey:@"HairAmount"];

    NSMutableArray *faceStyle = [NSMutableArray array];
    if (self.work.faceStyleCircle) {
        [faceStyle addObject:@(1)];
    }
    if (self.work.faceStyleGuaZi) {
        [faceStyle addObject:@(2)];
    }
    if (self.work.faceStyleSquare) {
        [faceStyle addObject:@(3)];
    }
    if (self.work.faceStyleLong) {
        [faceStyle addObject:@(4)];
    }

    if (faceStyle.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请至少选择一种脸型" duration:1];
        return;
    }
    [reqData setObject:[faceStyle componentsJoinedByString:@","] forKey:@"Face"];

    NSMutableArray *uploadPictures = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSString *pictureURL in self.uploadedPictures) {
        if ([pictureURL isEqualToString:@""]) {
            continue;
        }

        [uploadPictures addObject:pictureURL];
    }

    if (uploadPictures.count < 1) {
        [SVProgressHUD showErrorWithStatus:@"请至少选择一张作品图片" duration:1];
        return;
    }
    if([self isUploadingPicutres]){
        [SVProgressHUD showErrorWithStatus:@"图片正在上传，请稍候" duration:1];
        return;
    }

    [reqData setObject:uploadPictures forKey:@"PictureUrl"];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_WORKS_CREATE]
                                                                andData:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createWorkFinish:)];
    [request setDidFailSelector:@selector(createWorkFail:)];
    [request startAsynchronous];
}

- (void)createWorkFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"work"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"添加作品失败，请重试！"];
}

- (void)createWorkFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加作品失败，请重试！"];
}

- (void)loadView
{
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float margin =  10;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), 500);
    [self.view addSubview:self.scrollView];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(bgTapped)]];
    
    UILabel *info1lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, 100, 20)];
    info1lbl.backgroundColor = [UIColor clearColor];
    info1lbl.textColor = [UIColor blackColor];
    info1lbl.font = [UIFont boldSystemFontOfSize:14];
    info1lbl.text = @"多角度展示作品";
    info1lbl.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:info1lbl];

    UIView *uploadPictureView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(info1lbl) + 5, WIDTH(self.view) - 2 * margin, 80)];
    uploadPictureView.backgroundColor = [UIColor whiteColor];
    uploadPictureView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    uploadPictureView.layer.borderWidth = 1;
    uploadPictureView.layer.cornerRadius = 3;
    [self.scrollView addSubview:uploadPictureView];

    self.uploadPic0 = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 70 * 0, 5, 70, 70)];
    self.uploadPic0.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic0];

    UIButton *uploadPictureButton0 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton0.tag = 0;
    uploadPictureButton0.backgroundColor = [UIColor clearColor];
    uploadPictureButton0.frame = CGRectInset(self.uploadPic0.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton0];
    [uploadPictureButton0 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UILongPressGestureRecognizer *uploadPictureLongPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                          action:@selector(uploadPictureLongPress:)];
//    [uploadPictureButton0 addGestureRecognizer:uploadPictureLongPress1];

    self.uploadPictureActivityIndicator0 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic0.frame, 3, 3)];
    self.uploadPictureActivityIndicator0.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator0];

    self.uploadPic1 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic0) + 3, 5, 70, 70)];
    self.uploadPic1.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic1];

    UIButton *uploadPictureButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton1.tag = 1;
    uploadPictureButton1.backgroundColor = [UIColor clearColor];
    uploadPictureButton1.frame = CGRectInset(self.uploadPic1.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton1];
    [uploadPictureButton1 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UILongPressGestureRecognizer *uploadPictureLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                          action:@selector(uploadPictureLongPress:)];
//    [uploadPictureButton1 addGestureRecognizer:uploadPictureLongPress2];

    self.uploadPictureActivityIndicator2 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic1.frame, 3, 3)];
    self.uploadPictureActivityIndicator2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator2];

    self.uploadPic2 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic1) + 3, 5, 70, 70)];
    self.uploadPic2.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic2];

    UIButton *uploadPictureButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton2.tag = 2;
    uploadPictureButton2.backgroundColor = [UIColor clearColor];
    uploadPictureButton2.frame = CGRectInset(self.uploadPic2.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton2];
    [uploadPictureButton2 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UILongPressGestureRecognizer *uploadPictureLongPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                          action:@selector(uploadPictureLongPress:)];
//    [uploadPictureButton2 addGestureRecognizer:uploadPictureLongPress3];

    self.uploadPictureActivityIndicator2 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic2.frame, 3, 3)];
    self.uploadPictureActivityIndicator2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator2];

    self.uploadPic3 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic2) + 3, 5, 70, 70)];
    self.uploadPic3.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic3];

    UIButton *uploadPictureButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton3.tag = 3;
    uploadPictureButton3.backgroundColor = [UIColor clearColor];
    uploadPictureButton3.frame = CGRectInset(self.uploadPic3.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton3];
    [uploadPictureButton3 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UILongPressGestureRecognizer *uploadPictureLongPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                          action:@selector(uploadPictureLongPress:)];
//    [uploadPictureButton3 addGestureRecognizer:uploadPictureLongPress4];

    self.uploadPictureActivityIndicator3 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic3.frame, 3, 3)];
    self.uploadPictureActivityIndicator3.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator3];
    
    
    UILabel *info2lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(uploadPictureView) + margin, 100, 20)];
    info2lbl.backgroundColor = [UIColor clearColor];
    info2lbl.textColor = [UIColor blackColor];
    info2lbl.font = [UIFont boldSystemFontOfSize:14];
    info2lbl.text = @"作品备注";
    info2lbl.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:info2lbl];
    self.infoTxtView = [[UITextView alloc] initWithFrame: CGRectMake(X(uploadPictureView), MaxY(info2lbl) +margin, WIDTH(uploadPictureView), HEIGHT(uploadPictureView))];
    self.infoTxtView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    self.infoTxtView.layer.borderWidth = 1;
    self.infoTxtView.layer.cornerRadius = 3;
    [self.scrollView addSubview:self.infoTxtView];
    
#pragma face style view

    UILabel *faceStyleLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(self.infoTxtView) + margin,35,20)];
    faceStyleLbl.font = [UIFont systemFontOfSize:14];
    faceStyleLbl.textAlignment = NSTextAlignmentLeft;
    faceStyleLbl.backgroundColor = [UIColor clearColor];
    faceStyleLbl.textColor = [UIColor grayColor];
    faceStyleLbl.text = @"脸型:";
    [self.scrollView addSubview:faceStyleLbl];
    
    float faceStyleBtnheight = 60;
    float faceStyleBtnWidth = 55;
    UIButton *faceStyleCircleBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleLbl) + 5, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleCircleBtn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleNormal] forState:UIControlStateNormal];
    faceStyleCircleBtn.tag = 1;
    [faceStyleCircleBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleCircleBtn];
    
    UIButton *faceStyleGuaZiBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleCircleBtn) + 5, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleGuaZiBtn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
    faceStyleGuaZiBtn.tag = 2;
    [faceStyleGuaZiBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleGuaZiBtn];
    
    UIButton *faceStyleSquareBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleGuaZiBtn) + 5, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleSquareBtn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
    faceStyleSquareBtn.tag = 3;
    [faceStyleSquareBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleSquareBtn];
    
    UIButton *faceStyleLongBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleSquareBtn) + 5, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleLongBtn setBackgroundImage:[UIImage imageNamed:FaceStyleLongNormal] forState:UIControlStateNormal];
    faceStyleLongBtn.tag = 4;
    [faceStyleLongBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleLongBtn];

    float selectBtnWidth = 60;
    float selectBtnHeight = 25;

#pragma gender style view

    NSString *genderGroupName = @"GenderGroup";
    UILabel *genderLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(faceStyleCircleBtn) + margin,35,20)];
    genderLbl.font = [UIFont systemFontOfSize:14];
    genderLbl.textAlignment = NSTextAlignmentRight;
    genderLbl.backgroundColor = [UIColor clearColor];
    genderLbl.textColor = [UIColor grayColor];
    genderLbl.text = @"性别:";
    [self.scrollView addSubview:genderLbl];
    
    OpitionButton *femaleBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(genderLbl) + 5, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    femaleBtn.tag = 2;
    femaleBtn.Choosen = NO;
    [femaleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchDown];
    femaleBtn.groupName = genderGroupName;
    [self.scrollView addSubview:femaleBtn];
    
    OpitionButton *maleBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(femaleBtn) + 5, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [maleBtn setTitle:@"男" forState:UIControlStateNormal];
    maleBtn.tag = 1;
    maleBtn.Choosen = NO;
    maleBtn.groupName  =genderGroupName;
    [maleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:maleBtn];

#pragma hair style view

    NSString *hairStyleGroupName = @"hairStyleGroup";
    UILabel *hairStyleLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(maleBtn) + margin,35,20)];
    hairStyleLbl.font = [UIFont systemFontOfSize:14];
    hairStyleLbl.textAlignment = NSTextAlignmentRight;
    hairStyleLbl.backgroundColor = [UIColor clearColor];
    hairStyleLbl.textColor = [UIColor grayColor];
    hairStyleLbl.text = @"发型:";
    [self.scrollView addSubview:hairStyleLbl];
    
    OpitionButton *hairStyleLongBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 5, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleLongBtn.tag = 2;
    [hairStyleLongBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [hairStyleLongBtn setTitle:@"长发" forState:UIControlStateNormal];
    hairStyleLongBtn.groupName = hairStyleGroupName;
    [self.scrollView addSubview:hairStyleLongBtn];
    
    OpitionButton *hairStyleMiddelBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLongBtn) + 5, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleMiddelBtn.tag = 4;
    hairStyleMiddelBtn.groupName = hairStyleGroupName;
    [hairStyleMiddelBtn setTitle:@"中发" forState:UIControlStateNormal];
    [hairStyleMiddelBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleMiddelBtn];

    OpitionButton *hairStylePlaitBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleMiddelBtn) + 5, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStylePlaitBtn.tag = 3;
    hairStylePlaitBtn.groupName = hairStyleGroupName;
    [hairStylePlaitBtn setTitle:@"编发" forState:UIControlStateNormal];
    [hairStylePlaitBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStylePlaitBtn];
    
    OpitionButton *hairStyleShortBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStylePlaitBtn) + 5, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleShortBtn.tag = 1;
    hairStyleShortBtn.groupName = hairStyleGroupName;
    [hairStyleShortBtn setTitle:@"短发" forState:UIControlStateNormal];
    [hairStyleShortBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleShortBtn];
    

#pragma hair quality view

    NSString *hairQualityGroupName = @"hairQualityGroup";
    UILabel *hairQualityLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(hairStyleShortBtn) + margin,35,20)];
    hairQualityLbl.font = [UIFont systemFontOfSize:14];
    hairQualityLbl.textAlignment = NSTextAlignmentRight;
    hairQualityLbl.backgroundColor = [UIColor clearColor];
    hairQualityLbl.textColor = [UIColor grayColor];
    hairQualityLbl.text = @"发量:";
    [self.scrollView addSubview:hairQualityLbl];
    
    OpitionButton *hairQualityheavyBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 5, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityheavyBtn.tag = 1;
    hairQualityheavyBtn.groupName = hairQualityGroupName;
    [hairQualityheavyBtn setTitle:@"多密" forState:UIControlStateNormal];
    [hairQualityheavyBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityheavyBtn];
    
    OpitionButton *hairQualityMiddleBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityheavyBtn) + 5, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityMiddleBtn.tag = 2;
    hairQualityMiddleBtn.groupName = hairQualityGroupName;
    [hairQualityMiddleBtn setTitle:@"中等" forState:UIControlStateNormal];
    [hairQualityMiddleBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityMiddleBtn];
    
    OpitionButton *hairQualityLittleBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityMiddleBtn) + 5, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityLittleBtn.tag = 3;
    hairQualityLittleBtn.groupName = hairQualityGroupName;
    [hairQualityLittleBtn setTitle:@"偏少" forState:UIControlStateNormal];
    [hairQualityLittleBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityLittleBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate){
        [self resignInputResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    void (^animations)() = ^() {
        self.scrollView.contentSize = CGSizeMake(WIDTH(self.scrollView), ScrollContentHeight + kChineseKeyboardHeight);
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    void (^animations)() = ^() {
        self.scrollView.contentSize = CGSizeMake(WIDTH(self.scrollView), ScrollContentHeight);
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}


- (void)bgTapped
{
    [self resignInputResponder];
}

// check if upload image is processing or not
- (BOOL)isUploadingPicutres
{
    for (NSString *url in self.uploadedPictures) {
        if(url.length == 0 ||  [url componentsSeparatedByString:@"http"].count > 1)
            continue;
        else {
            return YES;
        }
    }
    return NO;
}

- (int)uploadedImagesCount
{
    int i = 0;
    for (NSString *item in self.uploadedPictures) {
        i = item.length > 0? i+1 : i;
    }
    return i;
}

// get the empty upload image button index
- (int)tobeUploadingImageIndex
{
    int i = -1;
    for (int j = 0; j < self.uploadedPictures.count; j++) {
        if(((NSString *)self.uploadedPictures[j]).length == 0){
            return j;
        }
    }
    return i;
}

- (void)resetUploadImageViewAtIndex:(int)index
{
    switch (index) {
        case 0:
            self.uploadPic0.image  = [UIImage imageNamed:@"AddImage"];
            break;
        case 1:
            self.uploadPic1.image  = [UIImage imageNamed:@"AddImage"];
            break;
        case 2:
            self.uploadPic2.image  = [UIImage imageNamed:@"AddImage"];
            break;
        case 3:
            self.uploadPic3.image  = [UIImage imageNamed:@"AddImage"];
            break;
        default:
            break;
    }
    [self stopUploadActivityIndicator:index];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    int tag = actionSheet.tag;
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController
                                                animated:YES
                                              completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Album", nil)]) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelections = 4 - [self uploadedImagesCount];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Remove", nil)]) {
        int uploadRemoveIndex = tag ;
        [self resetUploadImageViewAtIndex:uploadRemoveIndex];
        self.uploadedPictures[uploadRemoveIndex] = @"";
        ASIHTTPRequest *uploadRequest ;
        for (ASIHTTPRequest *request in self.requests) {
            if([[request.userInfo objectForKey:RequestUserInfoKeyUploadPictureIndex] intValue] == uploadRemoveIndex){
                uploadRequest = request;
                break;
            }
        }
        if(uploadRequest){
            [uploadRequest clearDelegatesAndCancel];
            [self.requests removeObject:uploadRequest];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    pickedImg = [pickedImg createThumbnailWithWidth:MIN(pickedImg.size.width, pickedImg.size.height)];
    
    int tobeUploadingImageIndex = [self tobeUploadingImageIndex];
    if (tobeUploadingImageIndex == 0) {
        self.uploadPic0.image  = pickedImg;
        [self.uploadPictureActivityIndicator0 startAnimating];
    }
    if (tobeUploadingImageIndex == 1) {
        self.uploadPic1.image  = pickedImg;
        [self.uploadPictureActivityIndicator1 startAnimating];
    }
    if (tobeUploadingImageIndex == 2) {
        self.uploadPic2.image  = pickedImg;
        [self.uploadPictureActivityIndicator2 startAnimating];
    }
    if (tobeUploadingImageIndex == 3) {
        self.uploadPic3.image  = pickedImg;
        [self.uploadPictureActivityIndicator3 startAnimating];
    }
    
    if(tobeUploadingImageIndex >= 0){
        self.uploadedPictures[tobeUploadingImageIndex] = [NSString stringWithFormat:@"%d",tobeUploadingImageIndex];// put this tmp value for checking if uploading
        NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
        ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_UPLOAD_PICTURE]
                                                                    andData:reqData];
        [self.requests addObject:request];
        
        [request setUserInfo:@{RequestUserInfoKeyUploadPictureIndex: @(tobeUploadingImageIndex)}];
        [request addData:UIImageJPEGRepresentation(pickedImg, 1) withFileName:@"uploadfile.jpg" andContentType:@"mage/JPEG" forKey:@"uploadfile"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(uploadPictureFinish:)];
        [request setDidFailSelector:@selector(uploadPictureFail:)];
        [request startAsynchronous];
    }

}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    for (ALAsset *asset in assets) {
        int tobeUploadingImageIndex = [self tobeUploadingImageIndex];
        if (tobeUploadingImageIndex == 0) {
            self.uploadPic0.image  = [UIImage imageWithCGImage:asset.thumbnail];
            [self.uploadPictureActivityIndicator0 startAnimating];
        }
        if (tobeUploadingImageIndex == 1) {
            self.uploadPic1.image  = [UIImage imageWithCGImage:asset.thumbnail];
            [self.uploadPictureActivityIndicator1 startAnimating];
        }
        if (tobeUploadingImageIndex == 2) {
            self.uploadPic2.image  = [UIImage imageWithCGImage:asset.thumbnail];
            [self.uploadPictureActivityIndicator2 startAnimating];
        }
        if (tobeUploadingImageIndex == 3) {
            self.uploadPic3.image  = [UIImage imageWithCGImage:asset.thumbnail];
            [self.uploadPictureActivityIndicator3 startAnimating];
        }
        
        if(tobeUploadingImageIndex >= 0){
            self.uploadedPictures[tobeUploadingImageIndex] = [NSString stringWithFormat:@"%d",tobeUploadingImageIndex];// put this tmp value for checking if uploading
            NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
            UIImage *pickedImg =[UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]];
            pickedImg = [pickedImg createThumbnailWithWidth:MIN(pickedImg.size.width, pickedImg.size.height)];
            
            ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_UPLOAD_PICTURE]
                                                                        andData:reqData];
            [self.requests addObject:request];
            [request setUserInfo:@{RequestUserInfoKeyUploadPictureIndex: @(tobeUploadingImageIndex)}];
            [request addData:UIImageJPEGRepresentation(pickedImg, 1) withFileName:@"uploadfile.jpg" andContentType:@"mage/JPEG" forKey:@"uploadfile"];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(uploadPictureFinish:)];
            [request setDidFailSelector:@selector(uploadPictureFail:)];
            [request startAsynchronous];
        }
    }
}


- (void)uploadPictureFinish:(ASIHTTPRequest *)request
{
    int uploadIndex = [[request.userInfo objectForKey:RequestUserInfoKeyUploadPictureIndex] intValue];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if ([responseMessage objectForKey:@"Thumb480Url"] && [responseMessage objectForKey:@"Thumb480Url"] != [NSNull null]) {
            NSString *picUrl = [responseMessage objectForKey:@"Thumb480Url"];
            self.uploadedPictures[uploadIndex] = picUrl;
            [self stopUploadActivityIndicator:uploadIndex];
            return;
        }
    }
    [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
    [self resetUploadImageViewAtIndex:uploadIndex];
    self.uploadedPictures[uploadIndex] = @"";
}

- (void)uploadPictureFail:(ASIHTTPRequest *)request
{
    int uploadIndex = [[request.userInfo objectForKey:@"UploadPictureIndex"] intValue];
    [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
    [self resetUploadImageViewAtIndex:uploadIndex];
    self.uploadedPictures[uploadIndex] = @"";
}

- (void)stopUploadActivityIndicator:(int)index
{
    if (index == 0) {
        [self.uploadPictureActivityIndicator0 stopAnimating];
    }
    if (index == 1) {
        [self.uploadPictureActivityIndicator2 stopAnimating];
    }
    if (index == 2) {
        [self.uploadPictureActivityIndicator2 stopAnimating];
    }
    if (index == 3) {
        [self.uploadPictureActivityIndicator3 stopAnimating];
    }
}

- (void)faceStyleBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            self.work.faceStyleCircle = !self.work.faceStyleCircle;
            if(self.work.faceStyleCircle){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 2:
        {
            self.work.faceStyleGuaZi = !self.work.faceStyleGuaZi;
            if(self.work.faceStyleGuaZi){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 3:
        {
            self.work.faceStyleSquare = !self.work.faceStyleSquare;
            if(self.work.faceStyleSquare){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 4:
        {
            self.work.faceStyleLong = !self.work.faceStyleLong;
            if(self.work.faceStyleLong){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongNormal] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

- (void)genderClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    self.work.gender = (GenderEnum)btn.tag;
    btn.choosen = YES;
}

- (void)hairStyleClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    self.work.hairStyle = (HairStyleEnum)btn.tag;
    btn.choosen = YES;
}

- (void)hairQualityClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    self.work.hairQuality = (HairQualityEnum)btn.tag;
    btn.choosen = YES;
}

- (void)resignInputResponder
{
    [self.infoTxtView resignFirstResponder];
}

- (void)uploadPictureTapped:(UIButton *)sender
{
    [self resignInputResponder];
    
    if ([self.uploadedPictures[sender.tag] isEqualToString:@""]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Album", nil), nil];
        actionSheet.tag = sender.tag;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Remove", nil), nil];
        actionSheet.tag = sender.tag;
        [actionSheet showInView:self.view];
    }
}

@end
