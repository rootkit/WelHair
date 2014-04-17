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

#import "MyGroupAddStaffViewController.h"

#import "MapPickerViewController.h"
#import "City.h"
#import "CityListViewController.h"

@interface MyGroupAddStaffViewController ()<UITextFieldDelegate, MapPickViewDelegate, CityPickViewDelegate>
@property (nonatomic, strong) UILabel * cityLbl;
@property (nonatomic, strong) City * selectedCity;
@property (nonatomic, strong) UITextField * staffNameTxt;
@property (nonatomic, strong) UITextField * groupAddressTxt;
@property (nonatomic, strong) UILabel * coordinateLbl;
@property (nonatomic, strong) UITextField * phoneNumTxt;
@property (nonatomic, strong) CLLocation *location;

@end
static const float KOffsetY = 40;

@implementation MyGroupAddStaffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加设计师";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"确认添加";
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    bool valid = (self.staffNameTxt.text.length > 0 &&
                  self.groupAddressTxt.text.length >0 &&
                  self.selectedCity.id > 0 &&
                  self.location != nil &&
                  [Util validPhoneNum:self.phoneNumTxt.text]);
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignInputResponder)]];
    float margin = 20;
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(margin, self.topBarOffset+ margin, 280, 40)];
    [cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickCity)]];
    cityView.backgroundColor = [UIColor whiteColor];
    self.cityLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
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
    [self.view addSubview:cityView];
    
    
    self.staffNameTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                                MaxY(cityView) + margin,
                                                                WIDTH(cityView),
                                                                40)
                                         leftPadding:margin];
    self.staffNameTxt.font = [UIFont systemFontOfSize:14];
    self.staffNameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.staffNameTxt.backgroundColor = [UIColor whiteColor];
    self.staffNameTxt.placeholder = @"  沙龙名称";
    self.staffNameTxt.delegate = self;
    [self.view addSubview:self.staffNameTxt];
    
    self.phoneNumTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                               MaxY(self.staffNameTxt) + margin,
                                                               WIDTH(self.staffNameTxt),
                                                               40)
                                        leftPadding:margin];
    self.phoneNumTxt.backgroundColor = [UIColor whiteColor];
    self.phoneNumTxt.font = [UIFont systemFontOfSize:14];
    self.phoneNumTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.phoneNumTxt.placeholder = @"  电话号码";
    self.phoneNumTxt.secureTextEntry = YES;
    self.phoneNumTxt.delegate = self;
    [self.view addSubview:self.phoneNumTxt];
    
    self.groupAddressTxt =  [UITextField plainTextField:CGRectMake(margin,
                                                                   MaxY(self.phoneNumTxt) + margin,
                                                                   WIDTH(self.phoneNumTxt),
                                                                   40)
                                            leftPadding:margin];
    self.groupAddressTxt.backgroundColor = [UIColor whiteColor];
    self.groupAddressTxt.font = [UIFont systemFontOfSize:14];
    self.groupAddressTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.groupAddressTxt.placeholder = @"  沙龙地址";
    self.groupAddressTxt.secureTextEntry = YES;
    self.groupAddressTxt.delegate = self;
    [self.view addSubview:self.groupAddressTxt];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(margin,
                                                                    MaxY(self.groupAddressTxt) + margin,
                                                                    WIDTH(self.groupAddressTxt),
                                                                    40)];
    [locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locateTapped)]];
    locationView.backgroundColor = [UIColor whiteColor];
    self.coordinateLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200,20)];
    self.coordinateLbl.font = [UIFont systemFontOfSize:14];
    self.coordinateLbl.textAlignment = NSTextAlignmentLeft;
    self.coordinateLbl.backgroundColor = [UIColor clearColor];
    self.coordinateLbl.textColor = [UIColor lightGrayColor];
    self.coordinateLbl.text = @"  获取地理坐标";
    [locationView addSubview:self.coordinateLbl];
    FAKIcon *arrowLocateIcon = [FAKIonIcons ios7LocationIconWithSize:20];
    [arrowLocateIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImageView *arrowLocateImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(locationView) - 40, 10, 20, 20)];
    arrowLocateImg.image = [arrowLocateIcon imageWithSize:CGSizeMake(20, 20)];
    [locationView addSubview:arrowLocateImg];
    [self.view addSubview:locationView];
    
    
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
    [self.staffNameTxt resignFirstResponder];
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
        self.coordinateLbl.text = @"  获取地理坐标";
    }else{
        self.coordinateLbl.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.longitude, location.coordinate.latitude];
    }
    
}

- (void)didPickCity:(City *)city
{
    self.selectedCity = city;
    self.cityLbl.text = city.name;
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
