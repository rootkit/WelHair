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

#import "UserViewController.h"
#import <FontAwesomeKit.h>
#import "WelQRReaderViewController.h"
#import "LoginViewController.h"
#import "CircleImageView.h"
#import <UIImageView+WebCache.h>
#import "AppointmentsViewControl.h"
#import "FavoritesViewController.h"
#import "OrdersViewController.h"
#import "SettingViewController.h"
#import "Work.h"
#import "WorkDetailViewController.h"
#import "DoubleCoverCell.h"

@interface UserViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@end
static const   float profileViewHeight = 80;
@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"UserViewController.Title", nil);
        
        FAKIcon *rightIcon = [FAKIonIcons ios7GearOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void) rightNavItemClick
{
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}
- (void)loadView
{
    [super loadView];


    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH
                                                                              (self.view), profileViewHeight)];
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg@2x"];
    [self.view addSubview:self.headerBackgroundView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), profileViewHeight + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    
    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 15, avatorSize, avatorSize)];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg"]];
    [profileIconView_ addSubview:self.avatorImgView];
    
    UIButton *overlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayBtn.frame = self.avatorImgView.frame;
    [overlayBtn addTarget:self action:@selector(avatorClicked) forControlEvents:UIControlEventTouchUpInside];
    [profileIconView_ addSubview:overlayBtn];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 20, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.text = @"美女";
    self.nameLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.nameLbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 40, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor whiteColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.text = @"济南高新区";
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [profileIconView_ addSubview:self.addressLbl];
    
    UIView *tabView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(profileIconView_), WIDTH(profileIconView_), tabButtonViewHeight)];
    UIImageView *tabBg = [[UIImageView alloc] initWithFrame:tabView_.bounds];
    tabBg.image = [UIImage imageNamed:@"UserViewControl_TabBg"];
    [tabView_ addSubview:tabBg];
    
    int tabCount = 4;
    float tabWidth = WIDTH(tabView_)/tabCount;
    for (int i = 0; i < tabCount; i++) {

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, tabButtonViewHeight)];
        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i;
        [tabView_ addSubview:btn];
    }
    [headerView_ addSubview:tabView_];
    self.tableView.tableHeaderView = headerView_;
    self.datasource = [FakeDataHelper getFakeWorkList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset   = self.tableView.contentOffset.y;
    
    if (yOffset < 0) {
        CGFloat factor = ((ABS(yOffset) + 320) * 320) / profileViewHeight;
        CGRect f = CGRectMake(-(factor - 320) / 2, self.topBarOffset, factor, profileViewHeight + ABS(yOffset));
        self.headerBackgroundView.frame = f;
    } else {
        CGRect f = self.headerBackgroundView.frame;
        f.origin.y = -yOffset + self.topBarOffset;
        self.headerBackgroundView.frame = f;
    }
}

- (void)avatorClicked
{
        
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
    self.avatorImgView.image  = pickedImg;
}

- (void) tabClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:{
            AppointmentsViewControl *vc = [AppointmentsViewControl new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            OrdersViewController *vc = [OrdersViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            FavoritesViewController *vc = [FavoritesViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            break;
        case 3:{
            FavoritesViewController *vc = [FavoritesViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.datasource.count/2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffTripleCellIdentifier";
    DoubleCoverCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DoubleCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Work *leftdata = [self.datasource objectAtIndex: (2 * indexPath.row)];
    Work *rightData;
    if(self.datasource.count > indexPath.row * 2 + 1){
        rightData = [self.datasource objectAtIndex:indexPath.row * 2 + 1];
    }
       __weak UserViewController *selfDelegate = self;
    [cell setupWithLeftData:leftdata rightData:rightData tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetial:work];}
     ];
    return cell;
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}
@end
