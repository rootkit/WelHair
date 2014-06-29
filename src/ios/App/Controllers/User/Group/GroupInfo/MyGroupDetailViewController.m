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

#import "CreateGroupViewController.h"
#import "MyGroupDetailViewController.h"
#import "MWPhotoBrowser.h"
#import "MapViewController.h"
@interface MyGroupDetailViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *groupAvatorImg;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *rateLbl;
@property (nonatomic, strong) NSMutableArray *groupImages;

@end

@implementation MyGroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙资料";
        FAKIcon *rightIcon = [FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
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

- (void)rightNavItemClick
{
    CreateGroupViewController *vc = [CreateGroupViewController new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,
                                                                     WIDTH(self.view),
                                                                     [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    [self.view addSubview:self.scrollView];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH(self.scrollView), 130)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.headerView];

    UIView *headerFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.headerView), WIDTH(self.headerView), 7)];
    headerFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [self.scrollView addSubview:headerFooterView];
    
    self.groupAvatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100 , 100)];
    [self.headerView addSubview:self.groupAvatorImg];

    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, 10, 200, 30)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor blackColor];
    self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
    self.nameLbl.textAlignment = TextAlignmentLeft;
    [self.headerView addSubview:self.nameLbl];
    

    UIImageView *rateHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, MaxY(self.nameLbl) + 10, 15, 15)];
    [self.headerView addSubview:rateHandImageView];
    rateHandImageView.image = [UIImage imageNamed:@"RateHand"];
    
    self.rateLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(rateHandImageView) + 5,
                                                             Y(rateHandImageView),
                                                             50,
                                                             15)];
    self.rateLbl.font = [UIFont systemFontOfSize:12];
    self.rateLbl.numberOfLines = 2;
    self.rateLbl.text = TextAlignmentLeft;
    self.rateLbl.backgroundColor = [UIColor clearColor];
    self.rateLbl.textColor = [UIColor blackColor];
    [self.headerView addSubview:self.rateLbl];

    UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, MaxY(self.nameLbl) + 35, 20, 20)];
    FAKIcon *phoneIcon = [FAKIonIcons ios7TelephoneIconWithSize:30];
    [phoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    phoneImg.image = [phoneIcon imageWithSize:CGSizeMake(30, 30)];
    phoneImg.userInteractionEnabled = YES;
    [self.headerView addSubview:phoneImg];
    [phoneImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)]];
    phoneImg.userInteractionEnabled = YES;
    
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(phoneImg) + 5, MaxY(self.nameLbl) + 30, 200, 30)];
    self.phoneLbl.backgroundColor = [UIColor clearColor];
    self.phoneLbl.textColor = [UIColor blackColor];
    self.phoneLbl.font = [UIFont systemFontOfSize:14];
    self.phoneLbl.textAlignment = TextAlignmentLeft;
    [self.phoneLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCall)]];
    self.phoneLbl.userInteractionEnabled = YES;
    [self.headerView addSubview:self.phoneLbl];

    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, MaxY(self.phoneLbl) + 5, 20, 20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:30];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(30, 30)];
    locationImg.userInteractionEnabled = YES;
    [locationImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressMap)]];
    [self.headerView addSubview:locationImg];

    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 5, MaxY(self.phoneLbl), 200, 30)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor blackColor];
    self.addressLbl.font = [UIFont systemFontOfSize:14];
    self.addressLbl.textAlignment = TextAlignmentLeft;
    [self.addressLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressMap)]];
    self.addressLbl.userInteractionEnabled = YES;
    [self.headerView addSubview:self.addressLbl];
    

    for (int i = 0; i < self.group.imgUrls.count; i ++) {
        UIImageView *img;
        if (i == 0) {
            img = [[UIImageView alloc] initWithFrame:CGRectMake(15 , MaxY(self.headerView) + 20, 90 , 90)];
        } else if (i == 1) {
            img = [[UIImageView alloc] initWithFrame:CGRectMake(115 , MaxY(self.headerView) + 20, 90 , 90)];
        } else if (i == 2) {
            img = [[UIImageView alloc] initWithFrame:CGRectMake(225 , MaxY(self.headerView) + 20, 90 , 90)];
        } else if (i == 3) {
            img = [[UIImageView alloc] initWithFrame:CGRectMake(15 , MaxY(self.headerView) + 120, 90 , 90)];
        }
        [self.scrollView addSubview:img];

        img.userInteractionEnabled = YES;
        img.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        img.layer.borderWidth = 1;
        [img setImageWithURL:[NSURL URLWithString:self.group.imgUrls[i]]];
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapp)]];
        [img drawBottomShadowOffset:1 opacity:1];
    }

    [self fillGroupInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshGroupInfo:)
                                                 name:NOTIFICATION_USER_REFRESH_GROUP_INFO
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)phoneCall
{
    [Util phoneCall:self.phoneLbl.text];
}

- (void)addressMap
{
    MapViewController *vc = [MapViewController new];
    vc.modelInfo = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imgTapp
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nc animated:YES completion:Nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.groupImages.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.groupImages.count) {
        return [self.groupImages objectAtIndex:index];
    }
    
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.groupImages objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}

- (void)refreshGroupInfo:(NSNotification *)notification
{
    self.group = notification.object;
    [self fillGroupInfo];
}

- (void)fillGroupInfo
{
    self.nameLbl.text = self.group.name;
    self.phoneLbl.text =  self.group.tel.length > 0 ? self.group.tel : self.group.mobile;
    [self.groupAvatorImg setImageWithURL:[NSURL URLWithString:self.group.logoUrl]];
    self.addressLbl.text = self.group.address;
    self.rateLbl.text = [NSString stringWithFormat:@"%d", self.group.ratingCount];

    self.groupImages = [NSMutableArray array];
    for (NSString *item in self.group.imgUrls) {
        [self.groupImages addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }
}

@end
