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
#import "CircleImageView.h"
#import "Util.h"
#import <Block-KVO/MTKObserving.h>
#import "ToggleButton.h"
@interface ProductDetailViewController ()<UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JOLImageSlider *imgSlider;
@property (nonatomic, strong) UILabel *productNameLbl;
@property (nonatomic, strong) ToggleButton *heartBtn;

@property (nonatomic, strong) UIImageView *groupImgImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *groupAddressLbl;
@property (nonatomic, strong) UILabel *groupDistanceLbl;

@property (nonatomic, strong) NSMutableArray *productImgs;
@property (nonatomic, strong) SelectOpition *selectOpition;
@property (nonatomic, strong) UILabel  *countLbl;
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
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if([viewControllers objectAtIndex:viewControllers.count - 1] == self){
        // navigationController is presenting viewcontrolls
    }else{
        // navigationController is pushing or poping viewcontrolls
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), self.view.bounds.size.height - kBottomBarHeight)];
    [self.view addSubview:self.scrollView];
#pragma bottom bar
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  MaxY(self.scrollView),
                                                                  WIDTH(self.view),
                                                                  kBottomBarHeight)];
    bottomView.backgroundColor =[UIColor clearColor];
    bottomView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bottomView.layer.borderWidth  = 0.5;
    
    UIButton *btnDecrese = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDecrese.frame = CGRectMake(20, 10, 30, 30);
    [btnDecrese addTarget:self action:@selector(countDownClick) forControlEvents:UIControlEventTouchDown];
    [btnDecrese setBackgroundImage:[UIImage imageNamed:@"CountDownBtn"] forState:UIControlStateNormal];
    [bottomView addSubview:btnDecrese];
    
    self.countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnDecrese) + 10,
                                                              Y(btnDecrese),
                                                              50  ,
                                                              HEIGHT(btnDecrese))];
    self.countLbl.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.countLbl.layer.borderWidth = 1;
    self.countLbl.layer.cornerRadius = 2;
    self.countLbl.font = [UIFont systemFontOfSize:14];
    self.countLbl.backgroundColor = [UIColor whiteColor];
    self.countLbl.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.countLbl];
    
    UIButton *btnIncrease = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIncrease.frame = CGRectMake(MaxX(self.countLbl)  + 10,Y(btnDecrese), 30, 30);
    [btnIncrease addTarget:self action:@selector(countUpClick) forControlEvents:UIControlEventTouchDown];
    [btnIncrease setBackgroundImage:[UIImage imageNamed:@"CountUpBtn"] forState:UIControlStateNormal];
    [bottomView addSubview:btnIncrease];
    
    
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
#pragma image slider
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.imgSlider = [[JOLImageSlider alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), WIDTH(self.view))];
    self.imgSlider.delegate = self;
    [self.imgSlider setContentMode: UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:self.imgSlider];
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
#pragma product name & price
    self.productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(self.imgSlider) + 5,220,40)];
    self.productNameLbl.textAlignment = NSTextAlignmentLeft;
    self.productNameLbl.textColor = [UIColor blackColor];
    self.productNameLbl.font = [UIFont systemFontOfSize:18];
    self.productNameLbl.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.productNameLbl];
    self.productNameLbl.text = self.product.name;
    
    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak ProductDetailViewController *weakSelf = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn){
                           [weakSelf favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake(260, Y(self.productNameLbl) + 5,30,30);
    [self.scrollView addSubview:self.heartBtn];
    
    
#pragma groupInfo
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.productNameLbl) + 5, WIDTH(self.view) - 20, 60)];
    groupView.backgroundColor = [UIColor whiteColor];
    groupView.layer.cornerRadius = 5;
    [groupView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupTapped)]];
    [self.scrollView addSubview:groupView];
    self.groupImgImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [groupView addSubview:self.groupImgImgView];
    self.groupImgImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
    self.groupImgImgView.layer.borderWidth = 2;
    
    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupImgImgView) + 5,
                                                                  10,
                                                                  150,
                                                                  HEIGHT(self.groupImgImgView)/2)];
    self.groupNameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.groupNameLbl.numberOfLines = 2;
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor blackColor];
    [groupView addSubview:self.groupNameLbl];
    
    self.groupAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupImgImgView) + 5,
                                                                     MaxY(self.groupNameLbl),
                                                                     WIDTH(self.groupNameLbl),
                                                                     HEIGHT(self.groupImgImgView)/2)];
    self.groupAddressLbl.font = [UIFont systemFontOfSize:12];
    self.groupAddressLbl.numberOfLines = 2;
    self.groupAddressLbl.backgroundColor = [UIColor clearColor];
    self.groupAddressLbl.textColor = [UIColor blackColor];
    [groupView addSubview:self.groupAddressLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(groupView) - 70,Y(self.groupAddressLbl), 15, 15)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:15];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(15, 15)];
    [groupView addSubview:locationImg];
    
    self.groupDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),50, 20)];
    self.groupDistanceLbl.textAlignment = NSTextAlignmentLeft;
    self.groupDistanceLbl.textColor = [UIColor lightGrayColor];
    self.groupDistanceLbl.backgroundColor = [UIColor clearColor];
    self.groupDistanceLbl.font = [UIFont systemFontOfSize:12];
    [groupView addSubview:self.groupDistanceLbl];
    [self.groupImgImgView setImageWithURL:[NSURL URLWithString:self.product.group.logoUrl]];
    self.groupNameLbl.text = self.product.group.name;
    self.groupAddressLbl.text = self.product.group.address;
    self.groupDistanceLbl.text =[NSString stringWithFormat:@"%.0f千米", self.product.group.distance];
#pragma tab view
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(groupView) + 10, 300, 30)];
    UIColor *tabViewColor =[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] ;
    [self.scrollView addSubview:tabView];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.layer.borderColor = [tabViewColor CGColor];
    tabView.layer.borderWidth = 1;
    tabView.layer.cornerRadius = 5;
    float tabButtonWidth = 300 / 2;
    
    UIButton *imageDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageDetailBtn.frame = CGRectMake(0,0,tabButtonWidth,30);
    imageDetailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [imageDetailBtn setTitle:@"图文详情" forState:UIControlStateNormal];
    [imageDetailBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    imageDetailBtn.tag = 0;
    [imageDetailBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [tabView addSubview:imageDetailBtn];
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(MaxX(imageDetailBtn),0, 1, HEIGHT(tabView))];
    separatorView1.backgroundColor = tabViewColor;
    [tabView addSubview:separatorView1];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(MaxX(imageDetailBtn)+1,0,tabButtonWidth,30);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentBtn setTitleColor:tabViewColor forState:UIControlStateNormal];
    commentBtn.titleLabel.textColor = tabViewColor;
    commentBtn.tag = 1;
    [commentBtn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchDown];
    [tabView addSubview:commentBtn];
    
    UIScrollView *paramScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, MaxY(tabView)+10, 300, 0)];
    NSArray *paramNameArry = @[@"商品名",@"价格",@"分类"];
    NSArray *paramValueArry = @[@"洗发水洗发水洗发水洗发水洗发水洗发水洗发水洗发水洗发水洗发水洗发水洗发水发水洗发水洗发水洗发水洗发水洗发水发水洗发水洗发水洗发水11111",@"￥20",@"亮发防干枯"];
    
    float paramOffsetY = 0;
    float paramLblHeight = 40;
    float paramLblPadding = 5;
    for (int i = 0; i < paramNameArry.count; i++) {
        
        NSString *titleStr = [paramNameArry objectAtIndex:i];
        NSString *valueStr = [paramValueArry objectAtIndex:i];
        float titleLblHeight = [Util heightFortext:titleStr
                                           minumHeight:paramLblHeight
                                            fixedWidth:60];
        float valueLblHeight =[Util heightFortext:valueStr
                                          minumHeight:paramLblHeight
                                           fixedWidth:240];
        float fixedHeight = MAX(titleLblHeight, valueLblHeight);
        
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, paramOffsetY, WIDTH(paramScrollView), fixedHeight + 2 *paramLblPadding )];
        cellView.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
        cellView.layer.borderWidth = 1;
        cellView.backgroundColor = [UIColor whiteColor];
        [paramScrollView addSubview:cellView];
        
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(paramLblPadding,
                                                                      paramLblPadding,
                                                                      60,
                                                                      fixedHeight)];
        titleLbl.font = [UIFont systemFontOfSize:12];
        titleLbl.numberOfLines = 0;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.text = titleStr;
        [cellView addSubview:titleLbl];
        
        UIView *cellSeparaterView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(titleLbl)+1,
                                                                             0,
                                                                             1,
                                                                             cellView.height)];
        cellSeparaterView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [cellView addSubview:cellSeparaterView];
        
        UILabel *valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(titleLbl) + paramLblPadding,
                                                                      paramLblPadding,
                                                                      225,
                                                                      fixedHeight)];
        valueLbl.font = [UIFont systemFontOfSize:12];
        valueLbl.numberOfLines = 0;
        valueLbl.textAlignment = NSTextAlignmentLeft;
        valueLbl.textColor = [UIColor blackColor];
        valueLbl.text = [paramValueArry objectAtIndex:i];
        [cellView addSubview:valueLbl];
        
        paramOffsetY += cellView.height;
    }
    CGRect newFrame = paramScrollView.frame;
    newFrame.size.height = paramOffsetY;
    paramScrollView.frame = newFrame;
    [self.scrollView addSubview:paramScrollView];
    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), MaxY(paramScrollView));
    
    // add kvo for product count
    [self observeProperty:@keypath(self.product.count) withBlock:
     ^(__weak typeof(self) selfDelegate, NSNumber *oldCount, NSNumber *newCount) {
         selfDelegate.countLbl.text =[NSString stringWithFormat:@"%d",[newCount intValue]];
     }];
    if(self.product.count <= 0){
        self.product.count = 1;
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

- (void)countDownClick
{
    if(self.product.count > 1){
        self.product.count--;
    }
}

- (void)countUpClick
{
    self.product.count++;
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index {
    [self OpenImageGallery];
}

- (void)rightBtnClick
{
    NSString *shareText = self.product.name;
    UIImageView *v = [[UIImageView alloc] init];
    [v setImageWithURL:self.product.imgUrlList[0]];
    UIImage *img = v.image;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:CONFIG_UMSOCIAL_APPKEY
                                      shareText:shareText
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToSina,
                                                 UMShareToTencent,
                                                 UMShareToQQ,
                                                 UMShareToWechatSession,nil]
                                       delegate:self];
}


- (void)favClick:(BOOL)markFav
{
    debugLog(@"mark as fav %c", markFav);
}


- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 0){
        [self.navigationController pushViewController:[ProductDetailWebViewController new] animated:YES];
    }else{
        [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
    }
}


- (void)groupTapped
{
    [self.navigationController pushViewController:[GroupDetailViewController new] animated:YES];
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
                                                          HEIGHT(self.view) - self.topBarOffset - 80)];
    
    __weak typeof(self) selfDelegate = self;
    [panel setupTitle:@"产品"
             opitions:[self buildSelectionOpition]
              product:self.product
               cancel:^(){[self.tabBarController dismissSemiModalView];}
               submit:^(SelectOpition *opitions){
                   selfDelegate.selectOpition =opitions;
                   [selfDelegate.tabBarController dismissSemiModalView];
                   [selfDelegate.navigationController pushViewController:[OrderPreviewViewController new] animated:YES];
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
- (void)dealloc
{
    [self removeAllObservations];
}

@end
