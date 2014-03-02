//
//  ProductViewController.m
//  WelHair
//
//  Created by lu larry on 2/25/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <FontAwesomeKit.h>
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "CommentsViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "OpitionSelectPanel.h"

@interface ProductDetailViewController ()<UMSocialUIDelegate>
@property (nonatomic, strong) SelectOpition *selectOpition;

@property (nonatomic, strong) UILabel *optionsLbl;
@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *searchIcon = [FAKIonIcons ios7RedoOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
        self.rightNavItemIcon = [searchIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    float margin = 10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(margin,
                                                                         margin + self.topBarOffset,
                                                                         WIDTH(self.view) - 2 *margin,
                                                                         WIDTH(self.view) - 2 *margin)];
    [imgView setImageWithURL:[NSURL URLWithString:[[FakeDataHelper getFakeHairWorkImgs] objectAtIndex:0]]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    
    //    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
    //    lbl.text = @"作品详情";
    //    lbl.textColor = [UIColor blackColor];
    //    [self.view addSubview:lbl];
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    categoryBtn.frame = CGRectMake(margin,MaxY(imgView) + margin, 100, 50);
    [categoryBtn setTitle:@"选择商品参数" forState:UIControlStateNormal];
    [categoryBtn addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:categoryBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentBtn.frame = CGRectMake(MaxX(categoryBtn) + margin,Y(categoryBtn), 100, 50);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:commentBtn];
    
    self.optionsLbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, MaxY(commentBtn), WIDTH(self.view)- 2 *margin, 100)];
    self.optionsLbl.textColor = [UIColor blackColor];
    [self.view addSubview:self.optionsLbl];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)categoryClick
{
    OpitionSelectPanel *panel =
    [[OpitionSelectPanel alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH(self.view),
                                                         HEIGHT(self.view) - self.topBarOffset - 100)];
    
    
    [panel setupTitle:@"产品"
             opitions:[self buildSelectionOpition]
                  cancel:^(){[self.tabBarController dismissSemiModalView];}
               submit:^(SelectOpition *opitions){
                   self.selectOpition =opitions;
                   [self.tabBarController dismissSemiModalView];
                   [self getSelectedOpitions:opitions.selectedValues];
               }];
    [self.tabBarController presentSemiView:panel withOptions:nil];
}

- (SelectOpition *)buildSelectionOpition
{
    int number = 3;
    if(!self.selectOpition){
        self.selectOpition = [SelectOpition new];
        self.selectOpition.count = 1;
        NSMutableArray *categoryArrays = [NSMutableArray array];
        for (int i = 0; i < number; i++) {
            OpitionCategory *category = [OpitionCategory new];
            category.id = i;
            category.title = [NSString stringWithFormat:@"Category %d",i];
            NSMutableArray *items = [NSMutableArray array];
            for (int j =0; j < number; j++) {
                OpitionItem *item = [OpitionItem new];
                item.id = i*10 + j;
                item.categoryId = category.id;
                item.title = [NSString stringWithFormat:@"category%d Item%d",i,j];
                [items addObject:item];
            }
            category.opitionItems = items;
            [categoryArrays addObject:category];
        }
        self.selectOpition.opitionCateogries = categoryArrays;
        self.selectOpition.selectedValues = [NSArray array];
    }

    return self.selectOpition;
}

- (void)getSelectedOpitions:(NSArray *)array
{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"已选择"];
    for (OpitionItem *item in array) {
        [str appendFormat:@",%d", item.id];
    }
    self.optionsLbl.text = str;
}
- (void)serviceOpitionData
{
    
}

- (void)commentClick
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}


@end
