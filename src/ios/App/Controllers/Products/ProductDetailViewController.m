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

#import <Block-KVO/MTKObserving.h>
#import "CircleImageView.h"
#import "CommentsViewController.h"
#import "GroupDetailViewController.h"
#import "JOLImageSlider.h"
#import "MapViewController.h"
#import "MWPhotoBrowser.h"
#import "OrderPreviewViewController.h"
#import "ProductDetailViewController.h"
#import "ProductOpitionPanel.h"
#import "StaffDetailViewController.h"
#import "SVWebViewController.h"
#import "ToggleButton.h"
#import "UMSocial.h"
#import "UIViewController+KNSemiModal.h"
#import "UserManager.h"
#import "Util.h"
#import "Order.h"

@interface ProductDetailViewController () <UMSocialUIDelegate,JOLImageSliderDelegate,MWPhotoBrowserDelegate>

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
@property (nonatomic, strong) UILabel  *priceLbl;

@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) ProductOpitionPanel *productOpitionPanel;
@end

@implementation ProductDetailViewController

- (void)dealloc
{
    [self removeAllObservations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.order = [Order new];
        self.title = @"商品";
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:YES])];
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
    btnDecrese.frame = CGRectMake(10, 10, 30, 30);
    [btnDecrese addTarget:self action:@selector(countDownClick) forControlEvents:UIControlEventTouchUpInside];
    [btnDecrese setBackgroundImage:[UIImage imageNamed:@"CountDownBtn"] forState:UIControlStateNormal];
    [bottomView addSubview:btnDecrese];
    
    self.countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnDecrese) + 10,
                                                              Y(btnDecrese),
                                                              40  ,
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
    [btnIncrease addTarget:self action:@selector(countUpClick) forControlEvents:UIControlEventTouchUpInside];
    [btnIncrease setBackgroundImage:[UIImage imageNamed:@"CountUpBtn"] forState:UIControlStateNormal];
    [bottomView addSubview:btnIncrease];
    
    self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnIncrease)+5,
                                                               Y(btnDecrese),
                                                               60,
                                                               HEIGHT(btnDecrese))];;
    self.priceLbl.font = [UIFont systemFontOfSize:12];
    self.priceLbl.textAlignment = NSTextAlignmentCenter;
    self.priceLbl.textColor = [UIColor redColor];
    [bottomView addSubview:self.priceLbl];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 25)];
    [submitBtn setTitle:@"下单" forState:UIControlStateNormal];
    submitBtn.tag = 0;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];

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

#pragma action section
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.imgSlider), 300, 35)];
    actionView.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1"] CGColor];
    actionView.layer.borderWidth = 1;
    actionView.layer.cornerRadius = 5;
    actionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:actionView];
    
    FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
    [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
    [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
    self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
    __weak ProductDetailViewController *weakSelf = self;
    [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                   offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                       toggleEventHandler:^(BOOL isOn){
                           return [weakSelf favClick:isOn];
                       }];
    self.heartBtn.frame = CGRectMake((150 - 25)/2, 5, 25, 25);
    [actionView addSubview:self.heartBtn];
    
    UIView *actionLinerView = [[UIView alloc] initWithFrame:CGRectMake(150, 5, 1, 25)];
    actionLinerView.backgroundColor = [UIColor lightGrayColor];
    [actionView addSubview:actionLinerView];
    
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FAKIcon *shareIcon = [FAKIonIcons androidShareIconWithSize:25];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    [shareBtn setImage:[shareIcon imageWithSize:CGSizeMake(25, 25)] forState:UIControlStateNormal ];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchDown];
    shareBtn.frame = CGRectMake(150 + (150 -25)/2, 7, 20, 20);
    [actionView addSubview:shareBtn];
    
#pragma product name & price
    self.productNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(actionView) + 5,220,40)];
    self.productNameLbl.textAlignment = NSTextAlignmentLeft;
    self.productNameLbl.textColor = [UIColor blackColor];
    self.productNameLbl.font = [UIFont systemFontOfSize:18];
    self.productNameLbl.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.productNameLbl];
    
    // add kvo for product count
    [self observeProperty:@keypath(self.order.count) withBlock:
     ^(__weak typeof(self) selfDelegate, NSNumber *oldCount, NSNumber *newCount) {
         selfDelegate.countLbl.text = [NSString stringWithFormat:@"%d",[newCount intValue]];
     }];
    [self observeProperty:@keypath(self.order.price) withBlock:
     ^(__weak typeof(self) selfDelegate, NSNumber *oldPrice, NSNumber *newPrice) {
         if(newPrice > 0){
             selfDelegate.priceLbl.text =[NSString stringWithFormat:@"￥%.2f",[newPrice floatValue]];
         }else{
             selfDelegate.priceLbl.text = nil;
         }
     }];

    [self getProductDetail];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)countDownClick
{
    if (self.order.count > 1) {
        self.order.count--;
        self.order.price -= self.order.singleProductPrice;
    }
}

- (void)countUpClick
{
    self.order.count++;
    self.order.price += self.order.singleProductPrice;
}


- (void)imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    [self OpenImageGallery];
}

- (void)shareClick
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


- (BOOL)favClick:(BOOL)markFav
{
    if(![self checkLogin]){
        return NO;
    }
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[UserManager SharedInstance] userLogined].id] forKey:@"CreatedBy"];
    [reqData setObject:[NSString stringWithFormat:@"%d", markFav ? 1 : 0] forKey:@"IsLike"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_GOODS_LIKE, self.product.id]]
                                                                andData:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addLikeFinish:)];
    [request setDidFailSelector:@selector(addLikeFail:)];
    [request startAsynchronous];
    return YES;
}

- (void)addLikeFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功" duration:1];
                return;
            }
        }
    }
}

- (void)addLikeFail:(ASIHTTPRequest *)request
{
}

- (void)tabClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        NSLog(@"%@", [NSString stringWithFormat:SITE_GOODS_CONTENT, self.product.id]);

        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:SITE_GOODS_CONTENT, self.product.id]];
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
        webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:webViewController animated:YES completion:NULL];
    } else {
        CommentsViewController *commentVC = [CommentsViewController new];
        commentVC.goodsId = self.product.id;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

- (void)groupTapped
{
    GroupDetailViewController *groupDetailVC = [GroupDetailViewController new];
    groupDetailVC.group = self.product.group;
    [self.navigationController pushViewController:groupDetailVC animated:YES];
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
    return self.productImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.productImgs.count)
        return [self.productImgs objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.productImgs objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}

- (void)submitClick
{
    if(self.order.product.specList.count == 0){
        OrderPreviewViewController *vc = [OrderPreviewViewController new];
        vc.order = self.order;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.productOpitionPanel =
        [[ProductOpitionPanel alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              WIDTH(self.view),
                                                              HEIGHT(self.view) - self.topBarOffset - 80)];
        
        __weak typeof(self) selfDelegate = self;
        [self.productOpitionPanel setupTitle:@"产品"
                 opitions:[self buildSelectionOpition]
                    order:self.order 
                   cancel:^() {
                       [self.tabBarController dismissSemiModalView];
                   }
                   submit:^(SelectOpition *opitions) {
                       [selfDelegate.tabBarController dismissSemiModalView];
                       OrderPreviewViewController *vc = [OrderPreviewViewController new];
                       vc.order = selfDelegate.order;
                       [selfDelegate.navigationController pushViewController:vc animated:YES];
                   }];
        [self.tabBarController presentSemiView:self.productOpitionPanel withOptions:nil];
    }
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

    NSMutableArray *optCategories = [NSMutableArray array];

    for (NSDictionary *specDic in self.product.specList) {
        OpitionCategory *category = [OpitionCategory new];
        category.id = [[specDic objectForKey:@"SpecId"] intValue];
        category.title = [specDic objectForKey:@"Title"];

        NSMutableArray *items = [NSMutableArray array];

        NSArray *optArr = [specDic objectForKey:@"Options"];
        for (NSDictionary *optDic in optArr) {
            OpitionItem *item = [OpitionItem new];
            item.categoryId = category.id;
            item.id = [[optDic objectForKey:@"OptionId"] intValue];
            item.id = item.id == 0 ? item.id+1 : item.id;
            item.title = [optDic objectForKey:@"Label"];
            item.price = [[optDic objectForKey:@"Price"] floatValue];
            [items addObject:item];
        }

        category.opitionItems = items;

        [optCategories addObject:category];
    }
    
    self.selectOpition.opitionCateogries = optCategories;
    self.selectOpition.selectedValues = [NSArray array];
    
    return self.selectOpition;
}

- (void)getProductDetail
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];


    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.product.group ? self.product.group.id : 0] forKey:@"companyId"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_GOODS_DETAIL, self.product.id]]
                                                          andParam:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetProductDetail:)];
    [request setDidFailSelector:@selector(failGetProductDetail:)];
    [request startAsynchronous];
}

- (void)finishGetProductDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    NSDictionary *rst = [Util objectFromJson:request.responseString];
    if ([[rst objectForKey:@"GoodsId"] intValue] <= 0) {
        return;
    }

    self.product = [[Product alloc] initWithDic:rst];

    self.order.product = self.product;
    self.order.singleProductPrice = self.order.product.specList.count == 0 ? self.product.price: 0;

    [self setupUIPerData];
}

- (void)failGetProductDetail:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"获得商品资料失败。"];
}

- (void)setupUIPerData
{
    self.productImgs = [NSMutableArray array];
    for (NSString *item in self.product.imgUrlList) {
        [self.productImgs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }

    self.productNameLbl.text = self.product.name;
    self.heartBtn.on = self.product.isLiked;

    CGRect tabFrame = CGRectMake(10, MaxY(self.productNameLbl) + 5, 300, 30);

    if (self.product.group) {
#pragma groupInfo
        UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(10, MaxY(self.productNameLbl) + 5, WIDTH(self.view) - 20, 60)];
        groupView.backgroundColor = [UIColor whiteColor];
        groupView.layer.cornerRadius = 5;
        [groupView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupTapped)]];
        [self.scrollView addSubview:groupView];

        self.groupImgImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.groupImgImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.groupImgImgView.layer.borderWidth = 2;
        [groupView addSubview:self.groupImgImgView];

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

        tabFrame = CGRectMake(10, MaxY(groupView) + 10, 300, 30);

        [self.groupImgImgView setImageWithURL:[NSURL URLWithString:self.product.group.logoUrl]];
        self.groupNameLbl.text = self.product.group.name;
        self.groupAddressLbl.text = self.product.group.address;
        self.groupDistanceLbl.text =[NSString stringWithFormat:@"%.0f千米", self.product.group.distance / 1000];
    }

#pragma tab view
    UIView *tabView = [[UIView alloc] initWithFrame:tabFrame];
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

    UIScrollView *paramScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, MaxY(tabView) + 10, 300, 0)];

    float paramOffsetY = 0;
    float paramLblHeight = 40;
    float paramLblPadding = 5;
    for (int i = 0; i < self.product.attrList.count; i++) {
        NSDictionary *attrDic = [self.product.attrList objectAtIndex:i];
        NSString *titleStr = [attrDic objectForKey:@"Title"];
        NSString *valueStr = [attrDic objectForKey:@"Value"];
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
        valueLbl.text = valueStr;
        [cellView addSubview:valueLbl];

        paramOffsetY += cellView.height;
    }

    if(self.product.specList.count == 0){
        self.order.price = self.product.price;
    }
    CGRect newFrame = paramScrollView.frame;
    newFrame.size.height = paramOffsetY;
    paramScrollView.frame = newFrame;
    [self.scrollView addSubview:paramScrollView];

    self.scrollView.contentSize = CGSizeMake(WIDTH(self.view), MaxY(paramScrollView) + 20);
}

@end
