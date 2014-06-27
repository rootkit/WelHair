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

#import "User.h"
#import "UserManager.h"
#import "UserProfileViewController.h"

@interface UserProfileViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *avatorUrl;

@property (nonatomic, strong) UIImageView *uploadLogo;
@property (nonatomic, strong) UIActivityIndicatorView *uploadLogoActivityIndicator;
@property (nonatomic, strong) UIImageView *uploadPic1;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator1;
@property (nonatomic, strong) UIImageView *uploadPic2;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator2;
@property (nonatomic, strong) UIImageView *uploadPic3;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator3;
@property (nonatomic, strong) UIImageView *uploadPic4;
@property (nonatomic, strong) UIActivityIndicatorView *uploadPictureActivityIndicator4;

@property (nonatomic, strong) NSMutableArray *uploadedPictures;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人信息";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.rightNavItemTitle = @"保存";

        self.uploadedPictures = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            self.uploadedPictures[i] = @"";
        }
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    NSString *username;
    NSString *nickname;
    NSString *email;
    NSString *mobile;

    for (int i = 0; i < 5; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1000 + i];
        if (textField) {
            if (i == 0) {
                username = textField.text;
            }
            if (i == 1) {
                nickname = textField.text;
            }
            if (i == 2) {
                email = textField.text;
            }
            if (i == 4) {
                mobile = textField.text;
            }
        }
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    [self backgroundTapped];

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:username forKey:@"Username"];
    [reqData setObject:nickname forKey:@"Nickname"];
    [reqData setObject:email forKey:@"Email"];
    [reqData setObject:mobile forKey:@"Mobile"];

    if (((NSString *)self.uploadedPictures[0]).length > 0) {
        [reqData setObject:self.uploadedPictures[0] forKey:@"AvatarUrl"];
    }

    NSMutableArray *uploadPictures = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSString *pictureURL in self.uploadedPictures) {
        if ([pictureURL isEqualToString:@""]) {
            continue;
        }

        [uploadPictures addObject:pictureURL];
    }
    [uploadPictures removeObjectAtIndex:0];
    [reqData setObject:uploadPictures forKey:@"ProfileBackgroundUrl"];

    ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_UPDATE, [UserManager SharedInstance].userLogined.id]]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(updateUserFinish:)];
    [request setDidFailSelector:@selector(updateUserFail:)];
    [request startAsynchronous];
}

- (void)updateUserFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 0) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_CHANGE object:nil];
            [SVProgressHUD showSuccessWithStatus:@"更新信息成功！"];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"更新信息失败，请重试！"];
}

- (void)updateUserFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"更新信息失败，请重试！"];
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
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view) + 50);
    [self.view addSubview:self.scrollView];

    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(backgroundTapped)]];

    float margin = 10;
    float viewHeight = 44;
    CGColorRef borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    UIColor *bgColor = [UIColor whiteColor];

    User *userLogined = [[UserManager SharedInstance] userLogined];
    
    NSArray *titleArray = @[@"账号：", @"昵称：", @"邮箱：", @"头像：", @"手机号：", @"邀请人："];
   
    float offsetY = 0;
    for (int i = 0 ; i < titleArray.count; i++) {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(margin,
                                                                    offsetY + margin,
                                                                    WIDTH(self.view) - 2 * margin,
                                                                    viewHeight)];
        cellView.tag = i;
        cellView.backgroundColor =bgColor;
        cellView.layer.borderColor = borderColor;
        cellView.layer.borderWidth = 1;
        cellView.layer.cornerRadius = 3;
        [self.scrollView addSubview:cellView];

        UILabel *cellInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 60, HEIGHT(cellView))];
        cellInfoLbl.backgroundColor = [UIColor clearColor];
        cellInfoLbl.textColor = [UIColor grayColor];
        cellInfoLbl.font = [UIFont boldSystemFontOfSize:14];
        cellInfoLbl.text = [titleArray objectAtIndex:i];
        cellInfoLbl.textAlignment = TextAlignmentLeft;
        [cellView addSubview:cellInfoLbl];

        if (i == 3) {
            [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
            self.uploadLogo.tag = 0;
            self.uploadLogo = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(cellView) - 40, 4, 36, 36)];
            [self.uploadLogo setImageWithURL:userLogined.avatarUrl placeholderImage:[UIImage imageNamed:DefaultAvatorImage]];
            [cellView addSubview:self.uploadLogo];
        } else {
            UITextField *txtField = [UITextField plainTextField:CGRectMake(MaxX(cellInfoLbl) + 10, 0, 190, HEIGHT(cellView))
                                                    leftPadding:0];
            txtField.tag = 1000 + i;
            txtField.backgroundColor = [UIColor clearColor];
            txtField.textColor = [UIColor blackColor];
            txtField.font = [UIFont boldSystemFontOfSize:14];
            txtField.textAlignment = TextAlignmentRight;
            txtField.backgroundColor = [UIColor whiteColor];
            [cellView addSubview:txtField];
        }

        offsetY = MaxY(cellView);
    }

    UILabel *info1lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, offsetY + margin, 100, 20)];
    info1lbl.backgroundColor = [UIColor clearColor];
    info1lbl.textColor = [UIColor blackColor];
    info1lbl.font = [UIFont boldSystemFontOfSize:14];
    info1lbl.text = @"个人秀";
    info1lbl.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:info1lbl];

    UIView *uploadPictureView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(info1lbl) + 5, WIDTH(self.view) - 2 * margin, 80)];
    uploadPictureView.backgroundColor = [UIColor whiteColor];
    uploadPictureView.layer.borderColor = borderColor;
    uploadPictureView.layer.borderWidth = 1;
    uploadPictureView.layer.cornerRadius = 3;
    [self.scrollView addSubview:uploadPictureView];

    self.uploadPic1 = [[UIImageView alloc] initWithFrame:CGRectMake(5 + 70 * 0, 5, 70, 70)];
    self.uploadPic1.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic1];

    UIButton *uploadPictureButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton1.tag = 1;
    uploadPictureButton1.backgroundColor = [UIColor clearColor];
    uploadPictureButton1.frame = CGRectInset(self.uploadPic1.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton1];
    [uploadPictureButton1 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton1 addGestureRecognizer:uploadPictureLongPress1];

    self.uploadPictureActivityIndicator1 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic1.frame, 3, 3)];
    self.uploadPictureActivityIndicator1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator1];

    self.uploadPic2 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic1) + 3, 5, 70, 70)];
    self.uploadPic2.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic2];

    UIButton *uploadPictureButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton2.tag = 2;
    uploadPictureButton2.backgroundColor = [UIColor clearColor];
    uploadPictureButton2.frame = CGRectInset(self.uploadPic2.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton2];
    [uploadPictureButton2 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton2 addGestureRecognizer:uploadPictureLongPress2];

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
    UILongPressGestureRecognizer *uploadPictureLongPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton3 addGestureRecognizer:uploadPictureLongPress3];

    self.uploadPictureActivityIndicator3 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic3.frame, 3, 3)];
    self.uploadPictureActivityIndicator3.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator3];

    self.uploadPic4 = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.uploadPic3) + 3, 5, 70, 70)];
    self.uploadPic4.image = [UIImage imageNamed:@"AddImage"];
    [uploadPictureView addSubview:self.uploadPic4];

    UIButton *uploadPictureButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadPictureButton4.tag = 4;
    uploadPictureButton4.backgroundColor = [UIColor clearColor];
    uploadPictureButton4.frame = CGRectInset(self.uploadPic4.frame, 3, 3);
    [uploadPictureView addSubview:uploadPictureButton4];
    [uploadPictureButton4 addTarget:self action:@selector(uploadPictureTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *uploadPictureLongPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(uploadPictureLongPress:)];
    [uploadPictureButton4 addGestureRecognizer:uploadPictureLongPress4];

    self.uploadPictureActivityIndicator4 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectInset(self.uploadPic4.frame, 3, 3)];
    self.uploadPictureActivityIndicator4.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [uploadPictureView addSubview:self.uploadPictureActivityIndicator4];

    [self getUserDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 3) {
        int index = 0;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Album", nil), nil];
        actionSheet.tag = index;
        [actionSheet showInView:self.view];
    }

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = actionSheet.tag;
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.view.tag = index;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController
                                                animated:YES
                                              completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Album", nil)]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.view.tag = index;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        [self presentViewController:imagePickerController
                           animated:YES
                         completion:nil];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Remove", nil)]) {
        if (index == 0) {
            self.uploadLogo.image  = [UIImage imageNamed:@"AddImage"];
        }

        if (index == 1) {
            self.uploadPic1.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (index == 2) {
            self.uploadPic2.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (index == 3) {
            self.uploadPic3.image  = [UIImage imageNamed:@"AddImage"];
        }
        if (index == 4) {
            self.uploadPic4.image  = [UIImage imageNamed:@"AddImage"];
        }

        self.uploadedPictures[index] = @"";
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    int index = picker.view.tag;
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    pickedImg = [pickedImg createThumbnailWithWidth:pickedImg.size.width];

    if (index == 0) {
        self.uploadLogo.image  = pickedImg;
        [self.uploadLogoActivityIndicator startAnimating];
    }

    if (index == 1) {
        self.uploadPic1.image  = pickedImg;
        [self.uploadPictureActivityIndicator1 startAnimating];
    }
    if (index == 2) {
        self.uploadPic2.image  = pickedImg;
        [self.uploadPictureActivityIndicator2 startAnimating];
    }
    if (index == 3) {
        self.uploadPic3.image  = pickedImg;
        [self.uploadPictureActivityIndicator3 startAnimating];
    }
    if (index == 4) {
        self.uploadPic4.image  = pickedImg;
        [self.uploadPictureActivityIndicator4 startAnimating];
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_UPLOAD_PICTURE]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setUserInfo:@{@"UploadPictureIndex": @(index)}];
    [request addData:UIImageJPEGRepresentation(pickedImg, 1) withFileName:@"uploadfile.jpg" andContentType:@"mage/JPEG" forKey:@"uploadfile"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadPictureFinish:)];
    [request setDidFailSelector:@selector(uploadPictureFail:)];
    [request startAsynchronous];
}

- (void)uploadPictureFinish:(ASIHTTPRequest *)request
{
    int index = [[request.userInfo objectForKey:@"UploadPictureIndex"] intValue];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if ([responseMessage objectForKey:@"Thumb480Url"] && [responseMessage objectForKey:@"Thumb480Url"] != [NSNull null]) {
            NSString *picUrl = [responseMessage objectForKey:@"Thumb480Url"];
            self.uploadedPictures[index] = picUrl;
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
    }

    [self stopUploadActivityIndicator:index];
}

- (void)uploadPictureFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];

    int index = [[request.userInfo objectForKey:@"UploadPictureIndex"] intValue];
    [self stopUploadActivityIndicator:index];
}

- (void)stopUploadActivityIndicator:(int)index
{
    if (index == 0) {
        [self.uploadLogoActivityIndicator stopAnimating];
    }
    if (index == 1) {
        [self.uploadPictureActivityIndicator1 stopAnimating];
    }
    if (index == 2) {
        [self.uploadPictureActivityIndicator2 stopAnimating];
    }
    if (index == 3) {
        [self.uploadPictureActivityIndicator3 stopAnimating];
    }
    if (index == 4) {
        [self.uploadPictureActivityIndicator4 stopAnimating];
    }
}

- (void)getUserDetail
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_DETAIL, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:nil];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetUserDetail:)];
    [request setDidFailSelector:@selector(failGetUserDetail:)];
    [request startAsynchronous];
}

- (void)finishGetUserDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if ([rst objectForKey:@"user"]) {
        User *user = [[User alloc] initWithDic:[rst objectForKey:@"user"]];

        UITextField *textField = (UITextField *)[self.view viewWithTag:1000];
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.text = user.username;
        textField.enabled = user.username.length == 0;
        textField.textColor = textField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        textField = (UITextField *)[self.view viewWithTag:1001];
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.text = user.nickname;
        textField = (UITextField *)[self.view viewWithTag:1002];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.text = user.email;
        textField.enabled = user.email.length == 0;
        textField.textColor = textField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        textField = (UITextField *)[self.view viewWithTag:1004];
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.text = user.mobile;

        self.uploadedPictures[0] = [user.avatarUrl absoluteString];
        [self.uploadLogo setImageWithURL:user.avatarUrl  placeholderImage:[UIImage imageNamed:DefaultAvatorImage]];

        for (int i =0 ; i < user.imgUrls.count; i++) {
            self.uploadedPictures[i + 1] = user.imgUrls[i];
            if (i == 0) {
                [self.uploadPic1 setImageWithURL:[NSURL URLWithString:user.imgUrls[i]]];
            } else if (i== 1) {
                [self.uploadPic2 setImageWithURL:[NSURL URLWithString:user.imgUrls[i]]];
            } else if (i== 2) {
                [self.uploadPic3 setImageWithURL:[NSURL URLWithString:user.imgUrls[i]]];
            } else if (i== 3) {
                [self.uploadPic4 setImageWithURL:[NSURL URLWithString:user.imgUrls[i]]];
            }
        }
    }
}

- (void)failGetUserDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
}

- (void)backgroundTapped
{
    [self resignInputResponder];
}

- (void)resignInputResponder
{
    for (int i = 0; i < 6; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1000 + i];
        if (textField) {
            [textField resignFirstResponder];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGSize size = self.scrollView.contentSize;
    size.height += kChineseKeyboardHeight;
    self.scrollView.contentSize = size;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGSize size = self.scrollView.contentSize;
    size.height -= kChineseKeyboardHeight;
    self.scrollView.contentSize = size;
}


- (void)uploadPictureLongPress:(UILongPressGestureRecognizer *)gesture
{
    [self resignInputResponder];

    int index = gesture.view.tag;
    if (gesture.state == UIGestureRecognizerStateEnded) {

        if ([self.uploadedPictures[index] isEqualToString:@""]) {
            return;
        }

        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Remove", nil), nil];
        actionSheet.tag = index;
        [actionSheet showInView:self.view];
    }
}

- (void)uploadPictureTapped:(UIButton *)sender
{
    [self resignInputResponder];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Album", nil), nil];
    actionSheet.tag = sender.tag;
    [actionSheet showInView:self.view];
}

@end
