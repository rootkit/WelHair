//
//  CreateGroupViewController.m
//  WelHair
//
//  Created by lu larry on 3/13/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "City.h"
#import "CityListViewController.h"
#import "CreateGroupViewController.h"
#import "MapPickerViewController.h"

static const float kOffsetY = 40;
static const float kMargin = 10;

@interface CreateGroupViewController ()<UITextFieldDelegate, MapPickViewDelegate, CityPickViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel * cityLbl;
@property (nonatomic, strong) UITextField * groupNameTxt;
@property (nonatomic, strong) UITextField * phoneNumTxt;
@property (nonatomic, strong) UITextField * mobileTxt;
@property (nonatomic, strong) UITextField * groupAddressTxt;
@property (nonatomic, strong) UILabel * coordinateLbl;

@property (nonatomic, strong) City * selectedCity;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic) int uploadIndex;
@property (nonatomic) int uploadRemoveIndex;
@property (nonatomic, strong) UIImageView *uploadLogo;
@property (nonatomic, strong) UIImageView *uploadPic1;
@property (nonatomic, strong) UIImageView *uploadPic2;
@property (nonatomic, strong) UIImageView *uploadPic3;
@property (nonatomic, strong) UIImageView *uploadPic4;

@property (nonatomic, strong) NSMutableArray *uploadedPictures;

@end

@implementation CreateGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加沙龙";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.rightNavItemTitle = @"确认添加";

        self.uploadIndex = -1;
        self.uploadRemoveIndex = -1;

        self.uploadedPictures = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            self.uploadedPictures[i] = @"";
        }
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    bool valid = (self.groupNameTxt.text.length > 0 &&
                  self.groupAddressTxt.text.length >0 &&
                  self.selectedCity.id > 0 &&
                  self.location != nil &&
                  self.phoneNumTxt.text.length >0);
    if(!valid){
        [SVProgressHUD showSuccessWithStatus:@"请填写所有项目" duration:1];
        return;
    }

    [FakeDataHelper setUserCreateGroupSuccess];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_CREATE_GROUP_SUCCESS object:nil];

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


    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), 600);
    [self.view addSubview:self.scrollView];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(resignInputResponder)]];

    UILabel *uploadLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, 100, 20)];
    uploadLogoLabel.backgroundColor = [UIColor clearColor];
    uploadLogoLabel.textColor = [UIColor blackColor];
    uploadLogoLabel.font = [UIFont boldSystemFontOfSize:14];
    uploadLogoLabel.text = @"沙龙Logo：";
    uploadLogoLabel.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:uploadLogoLabel];

    UIView *uploadLogoView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, MaxY(uploadLogoLabel) + kMargin / 2, WIDTH(self.view) - 2 * kMargin, 83)];
    uploadLogoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:uploadLogoView];

    self.uploadLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 73, 73)];
    self.uploadLogo.image = [UIImage imageNamed:@"AddImage"];
    [uploadLogoView addSubview:self.uploadLogo];

    UIButton *uploadLogoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadLogoButton.tag = 0;
    uploadLogoButton.backgroundColor = [UIColor clearColor];
    uploadLogoButton.frame = self.uploadLogo.frame;
    [uploadLogoView addSubview:uploadLogoButton];
    [uploadLogoButton addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, MaxY(uploadLogoView) + kMargin, WIDTH(self.view) - 2 * kMargin, 40)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:cityView];
    [cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickCity)]];

    self.cityLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.cityLbl.font = [UIFont systemFontOfSize:14];
    self.cityLbl.textAlignment = NSTextAlignmentLeft;
    self.cityLbl.backgroundColor = [UIColor clearColor];
    self.cityLbl.textColor = [UIColor lightGrayColor];
    self.cityLbl.text = @"选择城市";
    [cityView addSubview:self.cityLbl];

    FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(cityView) - 40, 10, 20, 20)];
    arrowImg.image = [arrowIcon imageWithSize:CGSizeMake(20, 20)];
    [cityView addSubview:arrowImg];


    self.groupNameTxt =  [UITextField plainTextField:CGRectMake(kMargin, MaxY(cityView) + kMargin, WIDTH(cityView), 40)
                                         leftPadding:kMargin];
    self.groupNameTxt.font = [UIFont systemFontOfSize:14];
    self.groupNameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.groupNameTxt.backgroundColor = [UIColor whiteColor];
    self.groupNameTxt.placeholder = @"沙龙名称";
    self.groupNameTxt.delegate = self;
    [self.scrollView addSubview:self.groupNameTxt];

    self.phoneNumTxt =  [UITextField plainTextField:CGRectMake(kMargin, MaxY(self.groupNameTxt) + kMargin, WIDTH(self.groupNameTxt), 40)
                                        leftPadding:kMargin];
    self.phoneNumTxt.backgroundColor = [UIColor whiteColor];
    self.phoneNumTxt.font = [UIFont systemFontOfSize:14];
    self.phoneNumTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneNumTxt.placeholder = @"电话号码";
    self.phoneNumTxt.delegate = self;
    [self.scrollView addSubview:self.phoneNumTxt];

    self.mobileTxt =  [UITextField plainTextField:CGRectMake(kMargin, MaxY(self.phoneNumTxt) + kMargin, WIDTH(self.groupNameTxt), 40)
                                        leftPadding:kMargin];
    self.mobileTxt.backgroundColor = [UIColor whiteColor];
    self.mobileTxt.font = [UIFont systemFontOfSize:14];
    self.mobileTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mobileTxt.placeholder = @"手机号码";
    self.mobileTxt.delegate = self;
    [self.scrollView addSubview:self.mobileTxt];

    self.groupAddressTxt =  [UITextField plainTextField:CGRectMake(kMargin, MaxY(self.mobileTxt) + kMargin, WIDTH(self.phoneNumTxt), 40)
                                            leftPadding:kMargin];
    self.groupAddressTxt.backgroundColor = [UIColor whiteColor];
    self.groupAddressTxt.font = [UIFont systemFontOfSize:14];
    self.groupAddressTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.groupAddressTxt.placeholder = @"沙龙地址";
    self.groupAddressTxt.delegate = self;
    [self.scrollView addSubview:self.groupAddressTxt];

    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, MaxY(self.groupAddressTxt) + kMargin, WIDTH(self.groupAddressTxt), 40)];
    locationView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:locationView];
    [locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locateTapped)]];

    self.coordinateLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200,20)];
    self.coordinateLbl.font = [UIFont systemFontOfSize:14];
    self.coordinateLbl.textAlignment = NSTextAlignmentLeft;
    self.coordinateLbl.backgroundColor = [UIColor clearColor];
    self.coordinateLbl.textColor = [UIColor lightGrayColor];
    self.coordinateLbl.text = @"获取地理坐标";
    [locationView addSubview:self.coordinateLbl];

    FAKIcon *arrowLocateIcon = [FAKIonIcons ios7LocationIconWithSize:20];
    [arrowLocateIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImageView *arrowLocateImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(locationView) - 40, 10, 20, 20)];
    arrowLocateImg.image = [arrowLocateIcon imageWithSize:CGSizeMake(20, 20)];
    [locationView addSubview:arrowLocateImg];

    UILabel *uploadPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, MaxY(locationView) + kMargin, 100, 20)];
    uploadPictureLabel.backgroundColor = [UIColor clearColor];
    uploadPictureLabel.textColor = [UIColor blackColor];
    uploadPictureLabel.font = [UIFont boldSystemFontOfSize:14];
    uploadPictureLabel.text = @"沙龙展示图：";
    uploadPictureLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:uploadPictureLabel];

    UIView *uploadPictureView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, MaxY(uploadPictureLabel) + kMargin / 2, WIDTH(self.view) - 2 * kMargin, 80)];
    uploadPictureView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:uploadPictureView];

    self.uploadPic1 = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 70 * 0, 5, 70, 70)];
    self.uploadPic1.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic1];

    UIButton *uploadPictureButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton1.tag = 1;
    uploadPictureButton1.backgroundColor = [UIColor clearColor];
    uploadPictureButton1.frame = self.uploadPic1.frame;
    [uploadPictureView addSubview:uploadPictureButton1];
    [uploadPictureButton1 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                         action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton1 addGestureRecognizer:uploadPictureLongPress1];

    self.uploadPic2 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic1) + 3, 5, 70, 70)];
    self.uploadPic2.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic2];

    UIButton *uploadPictureButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton2.tag = 2;
    uploadPictureButton2.backgroundColor = [UIColor clearColor];
    uploadPictureButton2.frame = self.uploadPic2.frame;
    [uploadPictureView addSubview:uploadPictureButton2];
    [uploadPictureButton2 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton2 addGestureRecognizer:uploadPictureLongPress2];

    self.uploadPic3 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic2) + 3, 5, 70, 70)];
    self.uploadPic3.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic3];

    UIButton *uploadPictureButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton3.tag = 3;
    uploadPictureButton3.backgroundColor = [UIColor clearColor];
    uploadPictureButton3.frame = self.uploadPic3.frame;
    [uploadPictureView addSubview:uploadPictureButton3];
    [uploadPictureButton3 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton3 addGestureRecognizer:uploadPictureLongPress3];

    self.uploadPic4 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic3) + 3, 5, 70, 70)];
    self.uploadPic4.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic4];

    UIButton *uploadPictureButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton4.tag = 4;
    uploadPictureButton4.backgroundColor = [UIColor clearColor];
    uploadPictureButton4.frame = self.uploadPic4.frame;
    [uploadPictureView addSubview:uploadPictureButton4];
    [uploadPictureButton4 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton4 addGestureRecognizer:uploadPictureLongPress4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;

    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;

    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;

    void (^animations)() = ^() {
        self.view.frame = CGRectMake(0,self.view.frame.origin.y - kOffsetY , WIDTH(self.view), HEIGHT(self.view));
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
        self.view.frame = CGRectMake(0,self.view.frame.origin.y + kOffsetY, WIDTH(self.view), HEIGHT(self.view));
    };

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}


- (void)resignInputResponder
{
    [self.groupNameTxt resignFirstResponder];
    [self.groupAddressTxt resignFirstResponder];
    [self.phoneNumTxt resignFirstResponder];
}

- (void)pickCity
{
    CityListViewController *picker = [CityListViewController new];
    picker.selectedCity = self.selectedCity;
    picker.delegate = self;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
}

- (void)locateTapped
{
    [self resignInputResponder];

    MapPickViewController *picker = [MapPickViewController new];
    picker.delegate = self;
    picker.location = self.location;
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)didPickLocation:(CLLocation *)location
{
    self.location = location;
    if(!self.location){
        self.coordinateLbl.text = @"获取地理坐标";
    }else{
        self.coordinateLbl.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.longitude, location.coordinate.latitude];
    }

}

- (void)didPickCity:(City *)city
{
    self.selectedCity = city;
    self.cityLbl.text = city.name;
}

- (void)uploadPictureLongPress:(UILongPressGestureRecognizer *)gesture
{
    [self resignInputResponder];

    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.uploadRemoveIndex = gesture.view.tag;

        if ([self.uploadedPictures[self.uploadRemoveIndex] isEqualToString:@""]) {
            return;
        }

        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Remove", nil), nil];
        [actionSheet showInView:self.view];
    }
}

- (void)uploadPictureTapped:(UIButton *)sender
{
    [self resignInputResponder];

    self.uploadIndex = sender.tag;

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Album", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController
                                                animated:YES
                                              completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Album", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Remove", nil)]) {
        if (self.uploadRemoveIndex == 0) {
            self.uploadLogo.image  = [UIImage imageNamed:@"AddImage"];
        }

        if (self.uploadRemoveIndex == 1) {
            self.uploadPic1.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (self.uploadRemoveIndex == 2) {
            self.uploadPic2.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (self.uploadRemoveIndex == 3) {
            self.uploadPic3.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (self.uploadRemoveIndex == 4) {
            self.uploadPic4.image  = [UIImage imageNamed:@"AddImage"];
        }

        self.uploadRemoveIndex = -1;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.uploadIndex == 0) {
        self.uploadLogo.image  = pickedImg;
    }

    if (self.uploadIndex == 1) {
        self.uploadPic1.image  = pickedImg;
    }
    if (self.uploadIndex == 2) {
        self.uploadPic2.image  = pickedImg;
    }
    if (self.uploadIndex == 3) {
        self.uploadPic3.image  = pickedImg;
    }
    if (self.uploadIndex == 4) {
        self.uploadPic4.image  = pickedImg;
    }

    self.uploadedPictures[self.uploadIndex] = @"http://baidu.com";

    self.uploadIndex = -1;
}

@end
