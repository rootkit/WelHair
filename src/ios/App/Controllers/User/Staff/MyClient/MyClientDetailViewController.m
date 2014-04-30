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

#import "AppointmentsViewController.h"
#import "ChatViewController.h"
#import "CircleImageView.h"
#import "MyClientDetailViewController.h"
#import "JOLImageSlider.h"
#import "UserManager.h"

#define  DefaultAvatorImage @"AvatarDefault.jpg"
static const float profileViewHeight = 90;
static const float tabButtonViewHeight = 56;
static const float avatorSize = 50;

@interface MyClientDetailViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, strong) UIImageView *profileBackground;
@property (nonatomic, strong) JOLImageSlider *imgSlider;

@property (nonatomic, strong) NSArray *tabIconDatasource;
@property (nonatomic, strong) NSArray *tabTextDatasource;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MyClientDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg = [leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];


        FAKIcon *chatIcon = [FAKIonIcons ios7ChatboxesOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [chatIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"303030"]];

        self.tabIconDatasource = @[[UIImage imageNamed:@"MeTab1"], [chatIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
        self.tabTextDatasource = @[@"预约", @"私信"];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES
                                                                                                                                            withBottomBar:NO])];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view) + 160);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view) + tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;
    [self.scrollView addSubview:headerView_];

    self.profileBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.profileBackground.image = [UIImage imageNamed:@"ProfileBackgroundDefault"];
    [headerView_ addSubview:self.profileBackground];

    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:self.profileBackground.frame];
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [headerView_ addSubview:self.imgSlider];

    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 320 - profileViewHeight, WIDTH(self.view), profileViewHeight)];
    profileIconView_.backgroundColor = [UIColor clearColor];
    [headerView_ addSubview:profileIconView_];

    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 20, avatorSize, avatorSize)];
    self.avatorImgView.image = [UIImage imageNamed:DefaultAvatorImage];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 1;
    [self.avatorImgView setImageWithURL:self.client.user.avatarUrl];
    [profileIconView_ addSubview:self.avatorImgView];

    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 5, 25, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor whiteColor];
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.textAlignment = NSTextAlignmentLeft;
    self.nameLbl.text = self.client.user.nickname;
    [profileIconView_ addSubview:self.nameLbl];

    UIView *tabView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(profileIconView_), WIDTH(profileIconView_), tabButtonViewHeight)];
    UIView *tabContentView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(profileIconView_), tabButtonViewHeight - 7)];
    tabContentView_.backgroundColor = [UIColor whiteColor];
    [tabView_ addSubview:tabContentView_];

    UIView *tabFooterBgView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(profileIconView_), 7)];
    tabFooterBgView_.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [tabView_ addSubview:tabFooterBgView_];
    UIView *tabFooterView_ = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(tabContentView_), WIDTH(profileIconView_), 7)];
    tabFooterView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [tabView_ addSubview:tabFooterView_];

    int tabCount = 2;
    float tabWidth = WIDTH(tabView_) / tabCount;
    for (int i = 0; i < tabCount; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, tabButtonViewHeight)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = TextAlignmentCenter;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, tabWidth / 2 - 53, tabButtonViewHeight - 32 , 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(20, -18, 0, 0);

        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[self.tabTextDatasource objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateHighlighted];
        [btn setImage:[self.tabIconDatasource objectAtIndex:i] forState:UIControlStateNormal];
        [tabView_ addSubview:btn];
    }
    [headerView_ addSubview:tabView_];

    if (self.client.user.imgUrls.count > 0) {
        NSMutableArray *sliderArray = [NSMutableArray array];
        for (NSString *item in self.client.user.imgUrls) {
            JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
            slideImg.image = item;
            [sliderArray addObject:slideImg];
        }

        [self.imgSlider setSlides:sliderArray];
        [self.imgSlider initialize];
        self.imgSlider.hidden = NO;
    } else {
        self.imgSlider.hidden = YES;
    }

    self.scrollView.contentInset = UIEdgeInsetsMake(-160, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) tabClick:(id)sender
{
    if(![self checkLogin]){
        return;
    }

    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0: {
            AppointmentsViewController *vc = [AppointmentsViewController new];
            vc.userId = self.client.user.id;
            vc.staffId = [[UserManager SharedInstance] userLogined].id;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 1: {
            ChatViewController *vc = [ChatViewController new];
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 160 && scrollView.contentInset.top < 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    if (scrollView.contentOffset.y > 0) {
        self.imgSlider.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y * 0.5f, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    } else {
        self.imgSlider.frame = CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view));
        self.profileBackground.frame = self.imgSlider.frame;
    }
}

@end
