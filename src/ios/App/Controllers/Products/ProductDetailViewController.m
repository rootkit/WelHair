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
#import "ProductDetailViewController.h"
#import "CommentsViewController.h"
#import "StaffDetailViewController.h"
#import "MapViewController.h"
#import "UIImageView+WebCache.h"
#import "Work.h"
#import "UMSocial.h"
#import "CircleImageView.h"
#import "JOLImageSlider.h"
#import "CommentsViewController.h"
#import "MWPhotoBrowser.h"
#import "GroupDetailViewController.h"
#import "ProductDetailWebViewController.h"
#import "ProductOpitionPanel.h"
#import "UIViewController+KNSemiModal.h"
#import "OrderPreviewViewController.h"

@interface ProductDetailViewController ()<UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) UIImageView *staffImgView;
@property (nonatomic, strong) UILabel *staffNameLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) NSMutableArray *productImgs;
@property (nonatomic, strong) SelectOpition *selectOpition;
@end

@implementation ProductDetailViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"商品";
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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:NO withBottomBar:YES])];
    [self.view addSubview:self.scrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  MaxY(self.scrollView),
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    bottomView.backgroundColor =[UIColor whiteColor];
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"下单" forState:UIControlStateNormal];
    submitBtn.tag = 0;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
    
#pragma topbar
    float topViewHeight = isIOS7 ? kStatusBarHeight + kTopBarHeight : kTopBarHeight;
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), topViewHeight)];
    topNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topNavView];
    
    UIView *topNavbgView = [[UIView alloc] initWithFrame:topNavView.bounds];
    topNavbgView.backgroundColor = [UIColor lightGrayColor];
    topNavbgView.alpha = 0.4;
    [topNavView addSubview:topNavbgView];
    // top left button
    FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [topNavView addSubview:leftBtn];
    // top right button
    
    UIImage *rightImg = [UIImage imageNamed:@"ShareIcon"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(WIDTH(topNavView) - 40 , topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [topNavView addSubview:rightBtn];
    
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f6fbfe"];
    
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setAutoSlide: YES];
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:self.imgSlider];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.imgSlider), WIDTH(self.scrollView), 264)];
    [self.scrollView addSubview:tempView];
    UIImageView *tempBgImg = [[UIImageView alloc] initWithFrame:tempView.bounds];
    tempBgImg.image = [UIImage imageNamed:@"ProductDetailViewControl_TempBg"];
    [tempView addSubview:tempBgImg];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    groupBtn.frame = CGRectMake(0, 30, 320, 50);
    [groupBtn addTarget:self action:@selector(groupClick) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:groupBtn];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(110, 90, 100, 25);
    [detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:detailBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(210, 90, 100, 25);
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:commentBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:Nil
    //               forBarMetrics:UIBarMetricsDefault & UIBarMetricsLandscapePhone];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"e1e3e2"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.staffImgView setImageWithURL:[NSURL URLWithString:self.product.creator.avatorUrl]];
//    self.staffNameLbl.text = self.work.creator.name;
    self.distanceLbl.text = @"1千米";
    NSMutableArray *sliderArray = [NSMutableArray array];
    for (NSString *item in self.product.imgUrlList) {
        JOLImageSlide * slideImg= [[JOLImageSlide alloc] init];
        slideImg.image = item;
        [sliderArray addObject:slideImg];
    }
    [self.imgSlider setSlides:sliderArray];
    
    self.productImgs = [NSMutableArray array];
    for (NSString *item in self.product.imgUrlList) {
        [self.productImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    [self OpenImageGallery];
}

- (void)rightBtnClick
{
    NSString *shareText = @"我的分享";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToSina,
                                                 UMShareToRenren,
                                                 UMShareToSms,nil]
                                       delegate:self];
}

- (void)groupClick
{
    [self.navigationController pushViewController:[GroupDetailViewController new] animated:YES];
}

- (void)detailClick
{
    [self.navigationController pushViewController:[ProductDetailWebViewController new] animated:YES];
}

- (void)commentClick
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}

- (void) OpenImageGallery
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
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.productImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.productImgs.count)
        return [self.productImgs objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [self.productImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    NSLog(@"ACTION!");
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}


- (void)submitClick
{
    ProductOpitionPanel *panel =
    [[ProductOpitionPanel alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH(self.view),
                                                         HEIGHT(self.view) - self.topBarOffset - 100)];
    
    
    [panel setupTitle:@"产品"
             opitions:[self buildSelectionOpition]
               cancel:^(){[self.tabBarController dismissSemiModalView];}
               submit:^(SelectOpition *opitions){
                   self.selectOpition =opitions;
                   [self.tabBarController dismissSemiModalView];
                   [self.navigationController pushViewController:[OrderPreviewViewController new] animated:YES];
               }];
    [self.tabBarController presentSemiView:panel withOptions:nil];
}

- (void)getSelectedOpitions:(NSArray *)array
{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"已选择"];
    for (OpitionItem *item in array) {
        [str appendFormat:@",%d", item.id];
    }
}

- (SelectOpition *)buildSelectionOpition
{
    self.selectOpition = [SelectOpition new];
    OpitionCategory *category = [OpitionCategory new];
    category.id = 1;
    category.title = @"容量";
    
    NSMutableArray *items = [NSMutableArray array];
    OpitionItem *item = [OpitionItem new];
    item.id = 0;
    item.categoryId = category.id;
    item.title =  @"1000ml";
    [items addObject:item];
    
    OpitionItem *item2 = [OpitionItem new];
    item2.id = 1;
    item2.categoryId = category.id;
    item2.title =  @"2000ml";
    [items addObject:item2];
    
    OpitionItem *item3 = [OpitionItem new];
    item3.id = 2;
    item3.categoryId = category.id;
    item3.title =  @"3000ml";
    [items addObject:item3];
    category.opitionItems = items;
    
    OpitionCategory *category_2 = [OpitionCategory new];
    category_2.id = 2;
    category_2.title = @"性质";
    
    NSMutableArray *items2 = [NSMutableArray array];
    OpitionItem *item_1 = [OpitionItem new];
    item_1.id = 0;
    item_1.categoryId = category_2.id;
    item_1.title =  @"润发";
    [items2 addObject:item_1];
    
    OpitionItem *item_2 = [OpitionItem new];
    item_2.id = 1;
    item_2.categoryId = category_2.id;
    item_2.title =  @"防脱发";
    [items2 addObject:item_2];
    
    OpitionItem *item_3 = [OpitionItem new];
    item_3.id = 2;
    item_3.categoryId = category_2.id;
    item_3.title =  @"亮发";
    [items2 addObject:item_3];
    category_2.opitionItems = items2;
    
    self.selectOpition.opitionCateogries = @[category, category_2];
    self.selectOpition.selectedValues = [NSArray array];
    
    return self.selectOpition;
}
@end
