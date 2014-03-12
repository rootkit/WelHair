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

#import "StaffDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "GroupDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+KNSemiModal.h"
#import "CalendarViewController.h"
#import "CircleImageView.h"
#import "TripleCoverCell.h"
#import "WorkDetailViewController.h"
#import "CommentsViewController.h"
#import "AppointmentPreviewViewController.h"

@interface StaffDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

static const   float profileViewHeight = 80;

@implementation StaffDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设计师Danny";
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
- (void)loadView
{
    [super loadView];
    
    float infoViewHeight  = 200;
    float avatorSize = 50;
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH
                                                                              (self.view), profileViewHeight)];
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg"];
    [self.view addSubview:self.headerBackgroundView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), profileViewHeight + infoViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    
    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake((WIDTH(profileIconView_) - avatorSize)/2, 5, avatorSize, avatorSize)];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
    [profileIconView_ addSubview:self.avatorImgView];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, MaxY(self.avatorImgView)+5, WIDTH(profileIconView_), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.textAlignment = NSTextAlignmentCenter;
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.text = @"美女";
    [profileIconView_ addSubview:self.nameLbl];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(profileIconView_), WIDTH(profileIconView_), infoViewHeight)];
    infoView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [headerView_ addSubview:infoView];
    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(profileIconView_), 55)];
    
    [infoView addSubview:addressView];
    UIImageView *addressBg = [[UIImageView alloc] initWithFrame:addressView.bounds];
    addressBg.image = [UIImage imageNamed:@"Profile_Bottom_Bg"];
    [addressView addSubview:addressBg];
    
    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 5,180 ,20)];
    self.groupNameLbl.font = [UIFont systemFontOfSize:12];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor grayColor];
    self.groupNameLbl.text = @"上海永琪";
    [addressView addSubview:self.groupNameLbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.groupNameLbl) + 3, WIDTH(self.groupNameLbl) ,15)];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.text = @"济南高新区会展国际";
    [addressView addSubview:self.addressLbl];
    
    float locationIconSize = 15;
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(headerView_) - 100, Y(self.addressLbl),locationIconSize, locationIconSize)];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(locationIconSize,locationIconSize)];
    [addressView addSubview:locationImg];
    
    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg), Y(locationImg), 30,20)];
    self.distanceLbl.font = [UIFont systemFontOfSize:10];
    self.distanceLbl.textAlignment = NSTextAlignmentRight;
    self.distanceLbl.text = @"1千米";
    self.distanceLbl.backgroundColor = [UIColor clearColor];
    self.distanceLbl.textColor = [UIColor colorWithHexString:@"206aa7"];
    [addressView addSubview:self.distanceLbl];
    
    UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl) + 20, 70, 100, 30)];
    [appointmentBtn setBackgroundImage:[UIImage imageNamed:@"AppointmentBtn"] forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(appointmentClick) forControlEvents:UIControlEventTouchDown];
    [headerView_ addSubview:appointmentBtn];
    
    UIView *detailCellView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(addressView) + 10, WIDTH(headerView_), 40)];
    detailCellView.backgroundColor = [UIColor whiteColor];
    UILabel *detailLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    detailLbl.font = [UIFont systemFontOfSize:14];
    detailLbl.textAlignment = NSTextAlignmentLeft;
    detailLbl.backgroundColor = [UIColor clearColor];
    detailLbl.textColor = [UIColor grayColor];
    detailLbl.text = @"基本信息";
    [detailCellView addSubview:detailLbl];
    FAKIcon *detailArrow = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [detailArrow addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *detailArrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(detailCellView) - 40, 10, 20, 20)];
    detailArrowImgView.image = [detailArrow imageWithSize:CGSizeMake(20, 20)];
    [detailCellView addSubview:detailArrowImgView];
    [infoView addSubview:detailCellView];
    
    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(detailCellView) + 10, WIDTH(headerView_), 40)];
    [commentCellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsTapped)]];
    commentCellView.backgroundColor = [UIColor whiteColor];
    UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    commentLbl.font = [UIFont systemFontOfSize:14];
    commentLbl.textAlignment = NSTextAlignmentLeft;
    commentLbl.backgroundColor = [UIColor clearColor];
    commentLbl.textColor = [UIColor grayColor];
    commentLbl.text = @"评论信息";
    [commentCellView addSubview:commentLbl];
    FAKIcon *commentIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(commentCellView) - 40, 10, 20, 20)];
    commentImgView.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [commentCellView addSubview:commentImgView];
    [infoView addSubview:commentCellView];
    UIImageView *workImgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, MaxY(commentCellView) + 5, 100, 30)];
    workImgView.image = [UIImage imageNamed:@"StaffDetailViewControl_WorkBanner"];
    [infoView addSubview:workImgView];
    
    self.tableView.tableHeaderView = headerView_;
    self.datasource = [FakeDataHelper getFakeWorkList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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


- (void)appointmentClick
{
    [self.navigationController pushViewController:[AppointmentPreviewViewController new] animated:YES];
}

- (void)commentsTapped
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.datasource.count/3.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffTripleCellIdentifier";
    TripleCoverCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TripleCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Work *leftdata = [self.datasource objectAtIndex: (3 * indexPath.row)];
    Work *middleData;
    if(self.datasource.count > indexPath.row * 3 + 1){
        middleData = [self.datasource objectAtIndex:indexPath.row * 3 + 1];
    }
    Work *rightData;
    if(self.datasource.count > indexPath.row * 3 + 2){
        rightData = [self.datasource objectAtIndex:indexPath.row * 3 + 2];
    }
    __weak StaffDetailViewController *selfDelegate = self;
    [cell setupWithLeftData:leftdata middleData:middleData  rightData:rightData tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetial:work];}
     ];
    return cell;
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    [self.navigationController pushViewController:workVc animated:YES];
}

@end
