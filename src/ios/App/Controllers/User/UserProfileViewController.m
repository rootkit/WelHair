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
@property (nonatomic, strong) UIImageView *avatorImgView;

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
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    bool valid = false;

    NSString *username;
    NSString *nickname;
    NSString *email;
    NSString *mobile;

    for (int i = 0; i < 5; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1000 + i];
        if (textField) {
            valid = textField.text.length > 0;

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

    if (self.avatorUrl.length > 0) {
        [reqData setObject:self.avatorUrl forKey:@"AvatarUrl"];
    }

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
            if (![responseMessage objectForKey:@"success"]) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGIN_SUCCESS object:nil];
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
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), 340);
    [self.view addSubview:self.scrollView];

    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(backgroundTapped)]];

    float margin = 15;
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

            self.avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(cellView) - 40, 4, 36, 36)];
            [self.avatorImgView setImageWithURL:userLogined.avatarUrl];
            [cellView addSubview:self.avatorImgView];
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

    [self getUserDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 3) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Album", nil), nil];
        [actionSheet showInView:self.view];
    }

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
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatorImgView.image = pickedImg;

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_UPLOAD_PICTURE]
                                                                andData:nil];
    [self.requests addObject:request];

    [request addData:UIImageJPEGRepresentation(pickedImg, 1) withFileName:@"uploadfile.jpg" andContentType:@"mage/JPEG" forKey:@"uploadfile"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadPictureFinish:)];
    [request setDidFailSelector:@selector(uploadPictureFail:)];
    [request startAsynchronous];
}

- (void)uploadPictureFinish:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if ([responseMessage objectForKey:@"Thumb480Url"] && [responseMessage objectForKey:@"Thumb480Url"] != [NSNull null]) {
            NSString *picUrl = [responseMessage objectForKey:@"Thumb480Url"];
            self.avatorUrl = picUrl;
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
    }
}

- (void)uploadPictureFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
}

- (void)getUserDetail
{
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
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if ([rst objectForKey:@"user"]) {
        User *user = [[User alloc] initWithDic:[rst objectForKey:@"user"]];

        UITextField *textField = (UITextField *)[self.view viewWithTag:1000];
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.text = user.username;
        textField = (UITextField *)[self.view viewWithTag:1001];
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.text = user.nickname;
        textField = (UITextField *)[self.view viewWithTag:1002];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.text = user.email;
        textField = (UITextField *)[self.view viewWithTag:1004];
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.text = user.mobile;

        self.avatorUrl = [user.avatarUrl absoluteString];
    }
}

- (void)failGetUserDetail:(ASIHTTPRequest *)request
{
}

- (void)backgroundTapped
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

@end
