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

#import <AMRatingControl.h>
#import "CommentComposorViewController.h"
#import "UserManager.h"

@interface CommentComposorViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) AMRatingControl *ratingControl;
@property (nonatomic, strong) UITextView *commentBodyView;

@property (nonatomic) int uploadIndex;
@property (nonatomic) int uploadRemoveIndex;
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

@implementation CommentComposorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"新评论";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.rightNavItemTitle = @"提交";

        self.uploadIndex = -1;
        self.uploadRemoveIndex = -1;

        self.uploadedPictures = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            self.uploadedPictures[i] = @"";
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    float margin =  10;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), 500);
    [self.view addSubview:self.scrollView];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(bgTapped)]];

    UIView *viewRatingContainer = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, 300, 40)];
    viewRatingContainer.backgroundColor = [UIColor whiteColor];
    viewRatingContainer.layer.cornerRadius = 5;
    [self.scrollView addSubview:viewRatingContainer];

    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, 110, 20)];
    ratingLabel.font = [UIFont systemFontOfSize:16];
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.textColor = [UIColor blackColor];
    ratingLabel.text = @"星级评分：";
    [viewRatingContainer addSubview:ratingLabel];

    self.ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(90, 7)
                                                        emptyColor:[UIColor colorWithHexString:@"ffc62a"]
                                                        solidColor:[UIColor colorWithHexString:@"ffc62a"]
                                                      andMaxRating:5];
    [viewRatingContainer addSubview:self.ratingControl];

    UILabel *commentBodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(viewRatingContainer) + margin, 100, 20)];
    commentBodyLabel.backgroundColor = [UIColor clearColor];
    commentBodyLabel.textColor = [UIColor blackColor];
    commentBodyLabel.font = [UIFont boldSystemFontOfSize:14];
    commentBodyLabel.text = @"评论内容：";
    commentBodyLabel.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:commentBodyLabel];

    self.commentBodyView = [[UITextView alloc] initWithFrame: CGRectMake(margin, MaxY(commentBodyLabel), 300, 80)];
    self.commentBodyView.layer.cornerRadius = 5;
    [self.scrollView addSubview:self.commentBodyView];

    UILabel *uploadPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(self.commentBodyView) + margin, 100, 20)];
    uploadPictureLabel.backgroundColor = [UIColor clearColor];
    uploadPictureLabel.textColor = [UIColor blackColor];
    uploadPictureLabel.font = [UIFont boldSystemFontOfSize:14];
    uploadPictureLabel.text = @"图片添加：";
    uploadPictureLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:uploadPictureLabel];

    UIView *uploadPictureView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(uploadPictureLabel) + 5, WIDTH(self.view) - 2 * margin, 80)];
    uploadPictureView.backgroundColor = [UIColor whiteColor];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavItemClick
{
    if (self.ratingControl.rating <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请给个评分吧。" duration:1];
        return;
    }
    if (self.commentBodyView.text.length <= 0) {
        [SVProgressHUD showSuccessWithStatus:@"请写点什么吧。" duration:1];
        return;
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:self.commentBodyView.text forKey:@"Body"];
    [reqData setObject:@(self.ratingControl.rating) forKey:@"Rate"];
    [reqData setObject:@(self.workId) forKey:@"WorkId"];
    [reqData setObject:@(self.goodsId) forKey:@"GoodsId"];
    [reqData setObject:@(self.userId) forKey:@"UserId"];
    [reqData setObject:@(self.companyId) forKey:@"CompanyId"];
    [reqData setObject:@([UserManager SharedInstance].userLogined.id) forKey:@"CreatedBy"];

    NSMutableArray *uploadPictures = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSString *pictureURL in self.uploadedPictures) {
        if ([pictureURL isEqualToString:@""]) {
            continue;
        }

        [uploadPictures addObject:pictureURL];
    }

    [reqData setObject:uploadPictures forKey:@"PictureUrl"];

    NSString *reqURL = nil;
    if (self.goodsId > 0) {
        reqURL = [NSString stringWithFormat:API_GOODS_COMMENT_CREATE, self.goodsId];
    }
    if (self.userId > 0) {
        reqURL = [NSString stringWithFormat:API_STAFFS_COMMENT_CREATE, self.userId];
    }
    if (self.companyId > 0) {
        reqURL = [NSString stringWithFormat:API_COMPANIES_COMMENT_CREATE, self.companyId];
    }
    if (self.workId > 0) {
        reqURL = [NSString stringWithFormat:API_WORKS_COMMENT_CREATE, self.workId];
    }

    if (reqURL == nil) {
        [SVProgressHUD showSuccessWithStatus:@"出错了，请返回重试。" duration:1];
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:reqURL]
                                                                andData:reqData];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createCommentFinish:)];
    [request setDidFailSelector:@selector(createCommentFail:)];
    [request startAsynchronous];
}

- (void)createCommentFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([responseMessage objectForKey:@"comment"] == nil) {
                [SVProgressHUD showErrorWithStatus:[responseMessage objectForKey:@"message"]];
                return;
            }

            [SVProgressHUD dismiss];

            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }

    [SVProgressHUD showErrorWithStatus:@"添加评论失败，请重试！"];
}

- (void)createCommentFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"添加评论失败，请重试！"];
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

        self.uploadedPictures[self.uploadRemoveIndex] = @"";
        self.uploadRemoveIndex = -1;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    pickedImg = [pickedImg createThumbnailWithWidth:pickedImg.size.width];

    if (self.uploadIndex == 0) {
        self.uploadLogo.image  = pickedImg;
        [self.uploadLogoActivityIndicator startAnimating];
    }

    if (self.uploadIndex == 1) {
        self.uploadPic1.image  = pickedImg;
        [self.uploadPictureActivityIndicator1 startAnimating];
    }
    if (self.uploadIndex == 2) {
        self.uploadPic2.image  = pickedImg;
        [self.uploadPictureActivityIndicator2 startAnimating];
    }
    if (self.uploadIndex == 3) {
        self.uploadPic3.image  = pickedImg;
        [self.uploadPictureActivityIndicator3 startAnimating];
    }
    if (self.uploadIndex == 4) {
        self.uploadPic4.image  = pickedImg;
        [self.uploadPictureActivityIndicator4 startAnimating];
    }

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:API_UPLOAD_PICTURE]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setUserInfo:@{@"UploadPictureIndex": @(self.uploadIndex)}];
    [request addData:UIImageJPEGRepresentation(pickedImg, 1) withFileName:@"uploadfile.jpg" andContentType:@"mage/JPEG" forKey:@"uploadfile"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadPictureFinish:)];
    [request setDidFailSelector:@selector(uploadPictureFail:)];
    [request startAsynchronous];
}

- (void)uploadPictureFinish:(ASIHTTPRequest *)request
{
    self.uploadIndex = [[request.userInfo objectForKey:@"UploadPictureIndex"] intValue];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if ([responseMessage objectForKey:@"Thumb480Url"] && [responseMessage objectForKey:@"Thumb480Url"] != [NSNull null]) {
            NSString *picUrl = [responseMessage objectForKey:@"Thumb480Url"];
            self.uploadedPictures[self.uploadIndex] = picUrl;
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];
    }

    [self stopUploadActivityIndicator];
}

- (void)uploadPictureFail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试！"];

    self.uploadIndex = [[request.userInfo objectForKey:@"UploadPictureIndex"] intValue];
    [self stopUploadActivityIndicator];
}

- (void)stopUploadActivityIndicator
{
    if (self.uploadIndex == 0) {
        [self.uploadLogoActivityIndicator stopAnimating];
    }
    if (self.uploadIndex == 1) {
        [self.uploadPictureActivityIndicator1 stopAnimating];
    }
    if (self.uploadIndex == 2) {
        [self.uploadPictureActivityIndicator2 stopAnimating];
    }
    if (self.uploadIndex == 3) {
        [self.uploadPictureActivityIndicator3 stopAnimating];
    }
    if (self.uploadIndex == 4) {
        [self.uploadPictureActivityIndicator4 stopAnimating];
    }
    
    self.uploadIndex = -1;
}

- (void)resignInputResponder
{
    [self.commentBodyView resignFirstResponder];
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

- (void)bgTapped
{
    [self resignInputResponder];
}

@end
