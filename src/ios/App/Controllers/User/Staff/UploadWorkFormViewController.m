//
//  UploadWorkFormViewController.m
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "UploadWorkFormViewController.h"
#import "Work.h"
#import "SVProgressHUD.h"
#define  SelectedViewColor  @"206ba7"
#define  FaceStyleCircleNormal  @"UploadWorkViewControl_FaceStyleCircleNormal"
#define  FaceStyleCircleSelected  @"UploadWorkViewControl_FaceStyleCircleSelected"
#define  FaceStyleGuaZiNormal  @"UploadWorkViewControl_FaceStyleGuaZiNormal"
#define  FaceStyleGuaZiSelected  @"UploadWorkViewControl_FaceStyleGuaZiSelected"
#define  FaceStyleLongNormal  @"UploadWorkViewControl_FaceStyleLongNormal"
#define  FaceStyleLongSelected  @"UploadWorkViewControl_FaceStyleLongSelected"
#define  FaceStyleSquareNormal  @"UploadWorkViewControl_FaceStyleSquareNormal"
#define  FaceStyleSquareSelected  @"UploadWorkViewControl_FaceStyleSquareSelected"

@implementation UploadOpitionButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [[UIColor colorWithHexString:@"c0bfbf"] CGColor];;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        [self unChoosenStyle];
        self.titleLabel.font  =[UIFont systemFontOfSize:14];
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setChoosen:(BOOL)choosen
{
    if(choosen){
        [self choosenStyle];
        for (UIView *view in self.superview.subviews) {
            if([view isKindOfClass:[UploadOpitionButton class]]){
                UploadOpitionButton *btn = (UploadOpitionButton *)view;
                if([btn.groupName isEqualToString:self.groupName] && ![btn isEqual:self]){
                        [btn unChoosenStyle];
                }
            }
        }
    }else{
        [self unChoosenStyle];
    }
}

- (void)choosenStyle
{
    [self setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:SelectedViewColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void)unChoosenStyle
{
    [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"73757d"] forState:UIControlStateNormal];
}

@end



@interface UploadWorkFormViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Work *work;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedUploadBtn;
@property (nonatomic, strong) UITextView *infoTxtView;


@property (nonatomic, strong) NSMutableArray *pickedImages;
@property (nonatomic, strong) UIButton *selectedGenderBtn;
@property (nonatomic, strong) UIButton *selectedHairStylleBtn;
@property (nonatomic, strong) UIButton *selectedHairQualityBtn;


@end

@implementation UploadWorkFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"发送";
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [SVProgressHUD showSuccessWithStatus:@"正在发送" duration:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.work = [Work new];
    self.pickedImages = [NSMutableArray array];
    float margin =  15;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    [self.view addSubview:self.scrollView];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(bgTapped)]];
    
    UILabel *info1lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin,margin, 100, 20)];
    info1lbl.backgroundColor = [UIColor clearColor];
    info1lbl.textColor = [UIColor blackColor];
    info1lbl.font = [UIFont boldSystemFontOfSize:14];
    info1lbl.text = @"多角度展示作品";
    info1lbl.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:info1lbl];
    
    UIView *uploadView = [[UIView alloc] initWithFrame:CGRectMake(margin,
                                                                  MaxY(info1lbl) + 5,
                                                                  WIDTH(self.scrollView)  - 30,
                                                                  80)];
    UIImageView *uploadViewbg = [[UIImageView alloc] initWithFrame:uploadView.bounds];
    uploadViewbg.image = [UIImage imageNamed:@"UploadWorkViewControl_UploadBg"];
    [uploadView addSubview:uploadViewbg];
    [self.scrollView addSubview:uploadView];
    
    float uploadBtnSize = 62;
    for (int i = 0; i < 4; i++) {
        UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(12 + (uploadBtnSize + 6) * i,
                                                                         8,
                                                                         62,
                                                                         62)];
        uploadBtn.tag = i;
        [uploadBtn addTarget:self action:@selector(uploadImgButtonClick:) forControlEvents:UIControlEventTouchDown];
        [uploadView addSubview:uploadBtn];
    }
    
    
    UILabel *info2lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(uploadView) + margin, 100, 20)];
    info2lbl.backgroundColor = [UIColor clearColor];
    info2lbl.textColor = [UIColor blackColor];
    info2lbl.font = [UIFont boldSystemFontOfSize:14];
    info2lbl.text = @"作品备注";
    info2lbl.textAlignment = NSTextAlignmentLeft;;
    [self.scrollView addSubview:info2lbl];
    self.infoTxtView = [[UITextView alloc] initWithFrame: CGRectMake(X(uploadView), MaxY(uploadView) + 10, WIDTH(uploadView), HEIGHT(uploadView))];
    self.infoTxtView.layer.cornerRadius = 5;
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
    UIButton *faceStyleCircleBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleLbl) + 10, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleCircleBtn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleNormal] forState:UIControlStateNormal];
    faceStyleCircleBtn.tag = 0;
    [faceStyleCircleBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleCircleBtn];
    
    UIButton *faceStyleGuaZiBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleCircleBtn) + 10, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleGuaZiBtn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
    faceStyleGuaZiBtn.tag = 1;
    [faceStyleGuaZiBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleGuaZiBtn];
    
    UIButton *faceStyleSquareBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleGuaZiBtn) + 10, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleSquareBtn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
    faceStyleSquareBtn.tag = 2;
    [faceStyleSquareBtn addTarget:self action:@selector(faceStyleBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:faceStyleSquareBtn];
    
    UIButton *faceStyleLongBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(faceStyleSquareBtn) + 10, Y(faceStyleLbl), faceStyleBtnWidth, faceStyleBtnheight)];
    [faceStyleLongBtn setBackgroundImage:[UIImage imageNamed:FaceStyleLongNormal] forState:UIControlStateNormal];
    faceStyleLongBtn.tag = 3;
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
    
    UploadOpitionButton *femaleBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(genderLbl) + 10, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
    femaleBtn.tag = 1;
    femaleBtn.Choosen = NO;
    [femaleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchDown];
    femaleBtn.groupName = genderGroupName;
    [self.scrollView addSubview:femaleBtn];
    
    UploadOpitionButton *maleBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(femaleBtn) + 10, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [maleBtn setTitle:@"男" forState:UIControlStateNormal];
    maleBtn.tag = 2;
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
    
    UploadOpitionButton *hairStyleLongBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleLongBtn.tag = 1;
    [hairStyleLongBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [hairStyleLongBtn setTitle:@"长发" forState:UIControlStateNormal];
    hairStyleLongBtn.groupName = hairStyleGroupName;
    [self.scrollView addSubview:hairStyleLongBtn];
    
    UploadOpitionButton *hairStyleMiddelBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLongBtn) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleMiddelBtn.tag = 2;
    hairStyleMiddelBtn.groupName = hairStyleGroupName;
    [hairStyleMiddelBtn setTitle:@"中发" forState:UIControlStateNormal];
    [hairStyleMiddelBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleMiddelBtn];
    
    UploadOpitionButton *hairStyleShortBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleMiddelBtn) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleShortBtn.tag = 3;
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
    
    UploadOpitionButton *hairQualityheavyBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityheavyBtn.tag = 1;
    hairQualityheavyBtn.groupName = hairQualityGroupName;
    [hairQualityheavyBtn setTitle:@"多密" forState:UIControlStateNormal];
    [hairQualityheavyBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityheavyBtn];
    
    UploadOpitionButton *hairQualityMiddleBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityheavyBtn) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityMiddleBtn.tag = 2;
    hairQualityMiddleBtn.groupName = hairQualityGroupName;
    [hairQualityMiddleBtn setTitle:@"中等" forState:UIControlStateNormal];
    [hairQualityMiddleBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityMiddleBtn];
    
    UploadOpitionButton *hairQualityLittleBtn = [[UploadOpitionButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityMiddleBtn) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
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

- (void)bgTapped
{
    [self.infoTxtView resignFirstResponder];
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

- (void)avatorClicked
{
    
    
    
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


- (void)faceStyleBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            self.work.faceStyleCircle = !self.work.faceStyleCircle;
            if(self.work.faceStyleCircle){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 1:
        {
            self.work.faceStyleGuaZi = !self.work.faceStyleGuaZi;
            if(self.work.faceStyleGuaZi){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 2:
        {
            self.work.faceStyleSquare = !self.work.faceStyleSquare;
            if(self.work.faceStyleSquare){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
            }
        }
            break;
        case 3:
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
    UploadOpitionButton *btn = (UploadOpitionButton *)sender;
    self.work.gender = btn.tag == 1? GenderEnumFemale : GenderEnumMale;
    btn.choosen = YES;
}

- (void)hairStyleClick:(id)sender
{
    UploadOpitionButton *btn = (UploadOpitionButton *)sender;
    switch (btn.tag) {
        case 1:
            self.work.hairStyle =  HairStyleEnumLong;
            break;
        case 2:
            self.work.hairStyle =  HairStyleEnumMiddle;
            break;
        case 3:
            self.work.hairStyle =  HairStyleEnumShort;
            break;
            
        default:
            break;
    }
    btn.choosen = YES;
}

- (void)hairQualityClick:(id)sender
{
    UploadOpitionButton *btn = (UploadOpitionButton *)sender;
    switch (btn.tag) {
        case 1:
            self.work.hairQuality =  HairQualityHeavy;
            break;
        case 2:
            self.work.hairStyle =  HairQualityMiddle;
            break;
        case 3:
            self.work.hairStyle =  HairQualityLittle;
            break;
            
        default:
            break;
    }
    btn.choosen = YES;
}




@end
