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

#import "GroupDetailViewController.h"
#import "StaffDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "MapPickerViewController.h"
#import "GroupDetailInfoTableViewDelegate.h"
#import "GroupDetailStaffTableViewDelegate.h"
#import "UMSocial.h"


@interface GroupDetailViewController()<MapPickViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) UITableView *staffTableView;

@end
static const   float profileViewHeight = 80;
@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙详情";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemImg  = [UIImage imageNamed:@"ShareIcon"];
    
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    NSString *shareText = @"我的分享";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToWechatSession,
                                                 UMShareToWechatTimeline,
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToQzone,
                                                 UMShareToSina,
                                                 UMShareToRenren,
                                                 UMShareToSms,nil]
                                       delegate:self];
}

- (void)loadView
{
    [super loadView];

    float tabButtonViewHeight = 50;
    float infoViewHeight  = 60;
    float avatorSize = 50;
    float segmentHeight = 40;
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH
                                                                              (self.view), profileViewHeight)];
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg@2x"];
    [self.view addSubview:self.headerBackgroundView];
    
    float tableHeight = isIOS7 ?
    HEIGHT(self.view) - self.topBarOffset:HEIGHT(self.view) - kTopBarHeight;
    self.infoTableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      tableHeight);
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), tableHeight)];
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.staffTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), tableHeight)];
    self.staffTableView.backgroundColor = [UIColor clearColor];
    self.staffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.staffTableView];
    [self.view addSubview:self.infoTableView];
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), profileViewHeight + tabButtonViewHeight + segmentHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    
    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];
    
    
    self.avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH(profileIconView_) - avatorSize)/2, 5, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://www.sssik.com/uploads/allimg/130609/20130125033623270.jpg"]];
    [profileIconView_ addSubview:self.avatorImgView];
    

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
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(infoView), WIDTH(headerView_), 40)];
    [headerView_ addSubview:segmentView];
    UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 140, 25)];
    infoBtn.tag = 0;
    [infoBtn setTitle:@"基本信息" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchDown];
    [segmentView addSubview:infoBtn];
    UIButton *staffBtn = [[UIButton alloc] initWithFrame:CGRectMake(MaxX(infoBtn), 15, 140, 25)];
    [staffBtn setTitle:@"发型师(110)" forState:UIControlStateNormal];
    [staffBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [staffBtn addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchDown];
    staffBtn.tag = 1;
    [segmentView addSubview:staffBtn];
    
    self.infoTableView.tableHeaderView = headerView_;
    self.staffTableView.tableHeaderView = headerView_;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.staffTableView.delegate = self;
    self.staffTableView.dataSource = self;
//    self.datasource = [FakeDataHelper getFakeWorkList];

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

- (void)segmentClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 0){
        [self.view bringSubviewToFront:self.infoTableView];
    }else{
        [self.view bringSubviewToFront:self.staffTableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat yOffset   = scrollView.contentOffset.y;
    
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

- (void)staffClick
{
    [self.navigationController pushViewController:[StaffDetailViewController new] animated:YES];
}

- (void)mapClick
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
}

- (void)pickPointClick
{
    
    MapPickViewController *picker = [MapPickViewController new];
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
}


#pragma pick map delegate
- (void)didPickLocation:(CLLocation *)location
{
    self.addressLbl.text = [NSString stringWithFormat:@"la:%f, lo:%f",location.coordinate.latitude, location.coordinate.longitude];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    if(tableView == self.infoTableView){
        return 50;
    }else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    if(tableView == self.infoTableView){
        return 2;
    }else{
        return self.datasource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(tableView == self.infoTableView){
        UITableViewCell * cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if(indexPath.row == 0){
            cell.textLabel.text = @"地址：高新区舜华北路舜泰广场2号楼";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            float locationIconSize = 20;
            FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
            [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1f6ba7"]];
            UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,locationIconSize,locationIconSize)];
            cell.accessoryView = locationImgView;
            return cell;
        }else{
            cell.textLabel.text = @"电话：15666666666";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            float locationIconSize = 20;
            FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
            [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1f6ba7"]];
            UIImageView *locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,15,locationIconSize,locationIconSize)];
            cell.accessoryView = locationImgView;
            return cell;
        }

    }else{
        static NSString * cellIdentifier = @"StaffCellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.infoTableView){
        if(indexPath.row == 0){
            [self.navigationController pushViewController:[MapViewController new] animated:YES];
        }
    }
}
@end
