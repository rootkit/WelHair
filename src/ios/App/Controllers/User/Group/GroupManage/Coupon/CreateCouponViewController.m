//
//  CreateCouponViewController.m
//  WelHair
//
//  Created by lu larry on 3/16/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "CreateCouponViewController.h"

@interface CreateCouponViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * nameTxt;
@property (nonatomic, strong) UITextField * saleOffTxt;
@property (nonatomic, strong) UILabel * typeLbl;
@property (nonatomic, strong) UILabel * startDateLbl;
@property (nonatomic, strong) UILabel * endDateLbl;

@end
static const float KOffsetY = 40;
@implementation CreateCouponViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  @"添加优惠券";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle  =@"保存";
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [SVProgressHUD showSuccessWithStatus:@"添加成功" duration:1];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignInputResponder)]];
    
    float margin = 10;
    self.nameTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                           self.topBarOffset +  margin,
                                                           WIDTH(self.view) - 2 * margin,
                                                           40)
                                    leftPadding:margin];
    self.nameTxt.font = [UIFont systemFontOfSize:14];
    self.nameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTxt.backgroundColor = [UIColor whiteColor];
    self.nameTxt.placeholder = @"优惠券名称";
    [self.view addSubview:self.nameTxt];
    
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(self.nameTxt)+ margin, WIDTH(self.nameTxt), 40)];
    [typeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickType)]];
    typeView.backgroundColor = [UIColor whiteColor];
    self.typeLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    self.typeLbl.font = [UIFont systemFontOfSize:14];
    self.typeLbl.textAlignment = NSTextAlignmentLeft;
    self.typeLbl.backgroundColor = [UIColor clearColor];
    self.typeLbl.textColor = [UIColor lightGrayColor];
    self.typeLbl.text = @"优惠券类型";
    [typeView addSubview:self.typeLbl];
    FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(typeView) - 40, 10, 20, 20)];
    arrowImg.image = [arrowIcon imageWithSize:CGSizeMake(20, 20)];
    [typeView addSubview:arrowImg];
    [self.view addSubview:typeView];
    
    self.saleOffTxt =  [UITextField plainTextField:CGRectMake(margin ,
                                                           MaxY(typeView) +  margin,
                                                           WIDTH(self.view) - 2 * margin,
                                                           40)
                                    leftPadding:margin];
    self.saleOffTxt.font = [UIFont systemFontOfSize:14];
    self.saleOffTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.saleOffTxt.backgroundColor = [UIColor whiteColor];
    self.saleOffTxt.placeholder = @"折扣";
    [self.view addSubview:self.saleOffTxt];
    
    
    UIView *startDateView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(self.saleOffTxt)+ margin, WIDTH(self.nameTxt), 40)];
    [startDateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickStartDate)]];
    startDateView.backgroundColor = [UIColor whiteColor];
    self.startDateLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    self.startDateLbl.font = [UIFont systemFontOfSize:14];
    self.startDateLbl.textAlignment = NSTextAlignmentLeft;
    self.startDateLbl.backgroundColor = [UIColor clearColor];
    self.startDateLbl.textColor = [UIColor lightGrayColor];
    self.startDateLbl.text = @"起始时间";
    [startDateView addSubview:self.startDateLbl];
    UIImageView *startArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(startDateView) - 40, 10, 20, 20)];
    startArrowImg.image = [arrowIcon imageWithSize:CGSizeMake(20, 20)];
    [startDateView addSubview:startArrowImg];
    [self.view addSubview:startDateView];
    
    UIView *endDateView = [[UIView alloc] initWithFrame:CGRectMake(margin, MaxY(startDateView)+ margin, WIDTH(self.nameTxt), 40)];
    [endDateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickEndDate)]];
    endDateView.backgroundColor = [UIColor whiteColor];
    self.endDateLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    self.endDateLbl.font = [UIFont systemFontOfSize:14];
    self.endDateLbl.textAlignment = NSTextAlignmentLeft;
    self.endDateLbl.backgroundColor = [UIColor clearColor];
    self.endDateLbl.textColor = [UIColor lightGrayColor];
    self.endDateLbl.text = @"结束时间";
    [endDateView addSubview:self.endDateLbl];
    UIImageView *endArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(endDateView) - 40, 10, 20, 20)];
    endArrowImg.image = [arrowIcon imageWithSize:CGSizeMake(20, 20)];
    [endDateView addSubview:endArrowImg];
    [self.view addSubview:endDateView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    void (^animations)() = ^() {
        self.view.frame = CGRectMake(0,self.view.frame.origin.y-KOffsetY , WIDTH(self.view), HEIGHT(self.view));
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
        self.view.frame = CGRectMake(0,self.view.frame.origin.y+KOffsetY, WIDTH(self.view), HEIGHT(self.view));
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:nil];
}


- (void)resignInputResponder
{
    [self.nameTxt resignFirstResponder];
    [self.saleOffTxt resignFirstResponder];
}

- (void)pickType
{
    
}

- (void)pickStartDate
{
    
}

- (void)pickEndDate
{
    
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
