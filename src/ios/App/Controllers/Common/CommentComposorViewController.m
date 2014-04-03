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

@interface CommentComposorViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *pickedImages;

@property (nonatomic, strong) AMRatingControl *ratingControl;
@property (nonatomic, strong) UIButton *selectedUploadBtn;
@property (nonatomic, strong) UITextView *commentBodyView;

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


        self.rightNavItemTitle = @"发布";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(bgTapped)]];

    float margin = 10;

    UIView *viewRatingContainer = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, 300, 40)];
    viewRatingContainer.backgroundColor = [UIColor whiteColor];
    viewRatingContainer.layer.cornerRadius = 5;
    [self.view addSubview:viewRatingContainer];

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
    commentBodyLabel.font = [UIFont systemFontOfSize:14];
    commentBodyLabel.text = @"评论内容：";
    commentBodyLabel.textAlignment = NSTextAlignmentLeft;;
    [self.view addSubview:commentBodyLabel];

    self.commentBodyView = [[UITextView alloc] initWithFrame: CGRectMake(margin, MaxY(commentBodyLabel), 300, 80)];
    self.commentBodyView.layer.cornerRadius = 5;
    [self.view addSubview:self.commentBodyView];

    UILabel *uploadPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(self.commentBodyView) + margin, 100, 20)];
    uploadPictureLabel.backgroundColor = [UIColor clearColor];
    uploadPictureLabel.textColor = [UIColor blackColor];
    uploadPictureLabel.font = [UIFont systemFontOfSize:14];
    uploadPictureLabel.text = @"图片添加：";
    uploadPictureLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:uploadPictureLabel];

    UIView *uploadView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(uploadPictureLabel), 300, 80)];
    [self.view addSubview:uploadView];

    UIImageView *uploadViewbg = [[UIImageView alloc] initWithFrame:uploadView.bounds];
    uploadViewbg.image = [UIImage imageNamed:@"UploadWorkViewControl_UploadBg"];
    [uploadView addSubview:uploadViewbg];

    float uploadBtnSize = 62;
    for (int i = 0; i < 4; i++) {
        UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(14 + (uploadBtnSize + 6) * i,
                                                                         8,
                                                                         62,
                                                                         62)];
        uploadBtn.tag = i;
        [uploadBtn addTarget:self action:@selector(uploadImgButtonClick:) forControlEvents:UIControlEventTouchDown];
        [uploadView addSubview:uploadBtn];
    }


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
    NSLog(@"%d", self.ratingControl.rating);
}

- (void)uploadImgButtonClick:(UIButton *)sender
{
    self.selectedUploadBtn = (UIButton *)sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Album", nil), nil];
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
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.pickedImages insertObject:pickedImg  atIndex:self.selectedUploadBtn.tag];
    [self.selectedUploadBtn setBackgroundImage:pickedImg forState:UIControlStateNormal];
}

- (void)bgTapped
{
    [self.commentBodyView resignFirstResponder];
}

@end
