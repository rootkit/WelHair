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
#import "CircleImageView.h"

@interface StaffDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) UIButton *detailTabBtn;
@property (nonatomic, strong) UIButton *commentTabBtn;
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

    float addressViewHeight = 50;
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:YES])];
    self.scrollView.delegate  =self;
    [self.view addSubview:self.scrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  MaxY(self.scrollView),
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"预约" forState:UIControlStateNormal];
    submitBtn.tag = 0;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
    
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH
                                                                              (self.view), profileViewHeight)];

    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg@2x"];
    [self.scrollView addSubview:self.headerBackgroundView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight + addressViewHeight+ tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView_];
    
#pragma topbar
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, profileViewHeight, WIDTH(headerView_), addressViewHeight)];
    UIImageView *addressViewBg = [[UIImageView alloc] initWithFrame:addressView.bounds];
    addressViewBg.image = [UIImage imageNamed:@"Profile_Bottom_Bg"];
    [addressView addSubview:addressViewBg];
    [headerView_ addSubview:addressView];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, MaxY(self.headerBackgroundView) - avatorSize/2, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
    [headerView_ addSubview:self.avatorImgView];
    
    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, WIDTH(addressView) - 10 - MaxX(self.avatorImgView), 20)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor blackColor];
    self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.groupNameLbl.text = @"沙宣";
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.groupNameLbl];
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.groupNameLbl),MaxY(self.groupNameLbl), WIDTH(addressView) - 10 - MaxX(self.avatorImgView) - 100, 20)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor grayColor];
    self.addressLbl.font = [UIFont systemFontOfSize:12];
    self.addressLbl.text = @"济南高新区";
    self.addressLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.addressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.addressLbl), Y(self.self.addressLbl),20,20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"000"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
    [addressView addSubview:locationImg];
    
    
    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),70,20)];
    self.distanceLbl.textAlignment = NSTextAlignmentLeft;
    self.distanceLbl.textColor = [UIColor grayColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:12];
    self.distanceLbl.backgroundColor = [UIColor clearColor];
    self.distanceLbl.text = @"1.45千米";
    [addressView addSubview:self.distanceLbl];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MaxY(addressView) + 10, WIDTH(self.view), 240)];
    [self.scrollView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"StaffDetailViewControl_TempBg"];
    
    UIButton *btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnImg.frame = CGRectMake(15,Y(imgView) + 110,220,50);
    [btnImg addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btnImg];
    
    UIButton *btnMoreImg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMoreImg.frame = CGRectMake(MaxX(btnImg),Y(btnImg),50,50);
    [btnMoreImg addTarget:self action:@selector(moreImgClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btnMoreImg];
    
    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(imgView) + 20, 290, 40)];
    commentCellView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    commentCellView.layer.borderWidth = 1.0;
    commentCellView.layer.cornerRadius = 5;
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
    [self.scrollView addSubview:commentCellView];
    
    self.scrollView.scrollEnabled = YES;
//    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), MaxY(commentCellView) + 10);
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


- (void)imgClick
{
    Work *work = [FakeDataHelper getFakeWorkList][0];
    WorkDetailViewController *detail = [WorkDetailViewController new];
    detail.work = work;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)moreImgClick
{
    
}

- (void)submitClick
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
