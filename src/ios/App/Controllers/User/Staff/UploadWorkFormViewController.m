//
//  UploadWorkFormViewController.m
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "UploadWorkFormViewController.h"
#import "Work.h"



@implementation UploadButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [[UIColor colorWithHexString:@"c0bfbf"] CGColor];;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (void)setChoosen:(BOOL)choosen
{
    if(choosen){
        self.backgroundColor = [UIColor colorWithHexString:@"206ba7"];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor colorWithHexString:@"73757d"] forState:UIControlStateNormal];
    }
}

@end

#define  SelectedViewColor  @"206ba7"
#define  FaceStyleCircleNormal  @"UploadWorkViewControl_FaceStyleCircleNormal"
#define  FaceStyleCircleSelected  @"UploadWorkViewControl_FaceStyleCircleSelected"
#define  FaceStyleGuaZiNormal  @"UploadWorkViewControl_FaceStyleGuaZiNormal"
#define  FaceStyleGuaZiSelected  @"UploadWorkViewControl_FaceStyleGuaZiSelected"
#define  FaceStyleLongNormal  @"UploadWorkViewControl_FaceStyleLongNormal"
#define  FaceStyleLongSelected  @"UploadWorkViewControl_FaceStyleLongSelected"
#define  FaceStyleSquareNormal  @"UploadWorkViewControl_FaceStyleSquareNormal"
#define  FaceStyleSquareSelected  @"UploadWorkViewControl_FaceStyleSquareSelected"

@interface UploadWorkFormViewController ()
@property (nonatomic, strong) Work *work;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedUploadBtn;
@property (nonatomic, strong) UITextView *infoTxtView;

@property (nonatomic, strong) NSMutableArray *pickedImages;


@end

@implementation UploadWorkFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.work = [Work new];
    float margin =  15;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    [self.view addSubview:self.scrollView];
    
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
#pragma face style view
    UILabel *genderLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(faceStyleCircleBtn) + margin,35,20)];
    genderLbl.font = [UIFont systemFontOfSize:14];
    genderLbl.textAlignment = NSTextAlignmentRight;
    genderLbl.backgroundColor = [UIColor clearColor];
    genderLbl.textColor = [UIColor grayColor];
    genderLbl.text = @"性别:";
    [self.scrollView addSubview:genderLbl];
    
    UploadButton *femaleBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(genderLbl) + 10, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [femaleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    femaleBtn.tag = 0;
    femaleBtn.Choosen = YES;
    [femaleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:femaleBtn];
    
    UploadButton *maleBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(femaleBtn) + 10, Y(genderLbl),selectBtnWidth, selectBtnHeight)];
    [maleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    maleBtn.tag = 1;
    maleBtn.Choosen = NO;
    [maleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:maleBtn];
    

    
#pragma hair style view
    UILabel *hairStyleLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(maleBtn) + margin,30,20)];
    hairStyleLbl.font = [UIFont systemFontOfSize:14];
    hairStyleLbl.textAlignment = NSTextAlignmentRight;
    hairStyleLbl.backgroundColor = [UIColor clearColor];
    hairStyleLbl.textColor = [UIColor grayColor];
    hairStyleLbl.text = @"发型:";
    [self.scrollView addSubview:hairStyleLbl];
    
    UploadButton *hairStyleLongBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleLongBtn.tag = 0;
    [hairStyleLongBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleLongBtn];
    
    UploadButton *hairStyleMiddelBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLongBtn) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleMiddelBtn.tag = 1;
    [hairStyleMiddelBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleMiddelBtn];
    
    UploadButton *hairStyleShortBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleMiddelBtn) + 10, Y(hairStyleLbl),selectBtnWidth, selectBtnHeight)];
    hairStyleShortBtn.tag = 2;
    [hairStyleShortBtn addTarget:self action:@selector(hairStyleClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairStyleShortBtn];
    

#pragma hair quality view
    UILabel *hairQualityLbl =[[UILabel alloc] initWithFrame:CGRectMake(margin,MaxY(hairStyleShortBtn) + margin,30,20)];
    hairQualityLbl.font = [UIFont systemFontOfSize:14];
    hairQualityLbl.textAlignment = NSTextAlignmentRight;
    hairQualityLbl.backgroundColor = [UIColor clearColor];
    hairQualityLbl.textColor = [UIColor grayColor];
    hairQualityLbl.text = @"发量:";
    [self.scrollView addSubview:hairQualityLbl];
    
    UploadButton *hairQualityheavyBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairStyleLbl) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityheavyBtn.tag = 0;
    [hairQualityheavyBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityheavyBtn];
    
    UploadButton *hairQualityMiddleBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityheavyBtn) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityMiddleBtn.tag = 1;
    [hairQualityMiddleBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityMiddleBtn];
    
    UploadButton *hairQualityLittleBtn = [[UploadButton alloc] initWithFrame:CGRectMake(MaxX(hairQualityMiddleBtn) + 10, Y(hairQualityLbl),selectBtnWidth, selectBtnHeight)];
    hairQualityLittleBtn.tag = 2;
    [hairQualityLittleBtn addTarget:self action:@selector(hairQualityClick:) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:hairQualityLittleBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)faceStyleBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if(self.work.faceStyleCircle){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleCircleNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleCircle = !self.work.faceStyleCircle;
        }
            break;
        case 1:
        {
            if(self.work.faceStyleGuaZi){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleGuaZi = !self.work.faceStyleGuaZi;
        }
            break;
        case 2:
        {
            if(self.work.faceStyleSquare){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleSquare = !self.work.faceStyleSquare;
        }
            break;
        case 3:
        {
            if(self.work.faceStyleLong){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleLong = !self.work.faceStyleLong;
        }
            break;
        default:
            break;
    }
}


- (void)genderClick:(id)sender
{
    UploadButton *btn = (UploadButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            btn.Choosen = self.work.forMale;
            if(self.work.forMale){

            }else{
                [btn setBackgroundColor:[UIColor colorWithHexString:SelectedViewColor]];
            }
            self.work.faceStyleCircle = !self.work.faceStyleCircle;
        }
            break;
        case 1:
        {
            if(self.work.faceStyleGuaZi){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleGuaZiNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleGuaZi = !self.work.faceStyleGuaZi;
        }
            break;
        case 2:
        {
            if(self.work.faceStyleSquare){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleSquareNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleSquare = !self.work.faceStyleSquare;
        }
            break;
        case 3:
        {
            if(self.work.faceStyleLong){
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongSelected] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:FaceStyleLongNormal] forState:UIControlStateNormal];
            }
            self.work.faceStyleLong = !self.work.faceStyleLong;
        }
            break;
        default:
            break;
    }
}

- (void)hairStyleClick:(id)sender
{
    UploadButton *btn = (UploadButton *)sender;
}

- (void)hairQualityClick:(id)sender
{
    UploadButton *btn = (UploadButton *)sender;
}




@end
