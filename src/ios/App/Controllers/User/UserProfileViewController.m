//
//  UserProfileViewController.m
//  WelHair
//
//  Created by lu larry on 3/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "UserProfileViewController.h"
#import <UIImageView+WebCache.h>
#import "CircleImageView.h"
@interface UserProfileViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) CircleImageView *avatorImgView;;

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
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.scrollView.delegate  =self;
    [self.view addSubview:self.scrollView];

    float margin = 15;
    float viewHeight = 50;
    CGColorRef borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    UIColor *bgColor = [UIColor whiteColor];
    
    
    NSArray *titleArray = @[@"用户名",@"头像",@"手机号",@"邀请人",@"好友"];
   
    float offsetY = 0;
    for (int i = 0 ; i < 5; i++) {
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(margin,
                                                                     offsetY + margin,
                                                                    WIDTH(self.view) - 2 * margin,
                                                                    viewHeight)];
        [nameView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
        nameView.tag = i;
        [self.scrollView addSubview:nameView];
        nameView.backgroundColor =bgColor;
        nameView.layer.borderColor = borderColor;
        nameView.layer.borderWidth =1;
        nameView.layer.cornerRadius = 3;
        UILabel *nameInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(margin,0, 100, HEIGHT(nameView))];
        nameInfoLbl.backgroundColor = [UIColor clearColor];
        nameInfoLbl.textColor = [UIColor grayColor];
        nameInfoLbl.font = [UIFont boldSystemFontOfSize:14];
        nameInfoLbl.text = [titleArray objectAtIndex:i];
        nameInfoLbl.textAlignment = NSTextAlignmentLeft;;
        [nameView addSubview:nameInfoLbl];
        if(i == 1){
            self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(MaxX(nameInfoLbl) + 100,10,30, 30)];
            [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
            [nameView addSubview:self.avatorImgView];
        }else{
            self.nameLbl  = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(nameInfoLbl) + 10,0,130, HEIGHT(nameView))];
            self.nameLbl.backgroundColor = [UIColor clearColor];
            self.nameLbl.textColor = [UIColor blueColor];
            self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
            self.nameLbl.text = i == 0 ? @"1111111111" : @"";
            self.nameLbl.textAlignment = NSTextAlignmentRight;;
            [nameView addSubview:self.nameLbl];
        }
        FAKIcon *infoIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:NAV_BAR_ICON_SIZE];
        [infoIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
        UIImageView *infoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl), 13, 25, 25)];
        infoImgView.image = [infoIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        [nameView addSubview:infoImgView];
        offsetY = MaxY(nameView);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 1){
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
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
