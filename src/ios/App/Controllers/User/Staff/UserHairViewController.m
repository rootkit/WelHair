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

#import "JOLImageSlider.h"
#import "MWPhotoBrowser.h"
#import "UserManager.h"
#import "UserHairViewController.h"
#import "UserHairRecordViewController.h"

@interface UserHairViewController () <JOLImageSliderDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *workImgs;
@property (nonatomic, strong) JOLImageSlider *imgSlider;

@end

@implementation UserHairViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"秀美发";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg  =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        FAKIcon *rightIcon = [FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg  =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    UserHairRecordViewController *vc = [UserHairRecordViewController new];
    vc.appointment = self.appointment;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillControl];
}

- (void)loadView
{
    [super loadView];
    
}

- (void)fillControl
{
    [self.headerView removeFromSuperview];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.topBarOffset,
                                                               WIDTH(self.view) ,
                                                               [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.headerView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [self.view addSubview:self.headerView];
    if(self.appointment.imgUrlList.count == 0){
        UILabel *noDataLbl =[[UILabel alloc] initWithFrame:self.headerView.bounds];
        noDataLbl.font = [UIFont systemFontOfSize:16];
        noDataLbl.numberOfLines = 1;
        noDataLbl.textAlignment = NSTextAlignmentCenter;
        noDataLbl.backgroundColor = [UIColor clearColor];
        noDataLbl.textColor = [UIColor grayColor];
        noDataLbl.text = @"暂无图片,添加几张作品图吧";
        [self.view addSubview:noDataLbl];
        return;
    }
#pragma topbar
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.headerView addSubview:self.imgSlider];
    
#pragma works list
    UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.imgSlider), 300, 70)];
    workView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    workView.layer.borderWidth = 1;
    workView.layer.cornerRadius = 5;
    workView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:workView];
    
    float imgHorizontalPadding = 8;
    float imgVeritalPadding = 5;
    float imgSize = 60;
    
    int count = MIN(self.appointment.imgUrlList.count, 4);
    for (int i = 0; i < count; i++) {
        NSString *imageUrl  =self.appointment.imgUrlList[i];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
        img.layer.cornerRadius = 3;
        img.userInteractionEnabled = YES;
        img.tag = i;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
        [img setImageWithURL:[NSURL URLWithString:imageUrl]];
        [workView addSubview:img];
    }
}

- (void)workImgTapped:(UITapGestureRecognizer *)tapped
{
    [self.imgSlider scrollToIndex:tapped.view.tag animationed:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *sliderArray = [NSMutableArray array];
    for (NSString *item in self.appointment.imgUrlList) {
        JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
        slideImg.image = item;
        [sliderArray addObject:slideImg];
    }
    [self.imgSlider setSlides:sliderArray];
    self.workImgs = [NSMutableArray array];
    for (NSString *item in self.appointment.imgUrlList) {
        [self.workImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    [self OpenImageGallery];
}

- (void)OpenImageGallery
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
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
    return self.workImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.workImgs.count) {
        return [self.workImgs objectAtIndex:index];
    }
    
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.workImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}




@end
