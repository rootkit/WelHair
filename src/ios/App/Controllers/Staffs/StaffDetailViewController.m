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
#import "StaffWorksViewController.h"
#import "Service.h"
#import "SelectOpition.h"
#import "OpitionSelectPanel.h"

@interface StaffDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *headerBackgroundView;
@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *distanceLbl;
@property (nonatomic, strong) UIImage *foImg;
@property (nonatomic, strong) ToggleButton *foBtn;
@property (nonatomic, strong) UIButton *detailTabBtn;
@property (nonatomic, strong) UIButton *commentTabBtn;
@property (nonatomic, strong) SelectOpition *selectOpition;
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

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float addressViewHeight = 50;
    float tabButtonViewHeight = 50;
    float avatorSize = 50;
    
    self.headerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH
                                                                              (self.view), profileViewHeight)];
    
    self.headerBackgroundView.image = [UIImage imageNamed:@"Profile_Banner_Bg"];
    [self.view addSubview:self.headerBackgroundView];
    
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
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:submitBtn];
    [self.view addSubview:bottomView];
    
    
    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), profileViewHeight + addressViewHeight+ tabButtonViewHeight)];
    headerView_.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView_];
    
    FAKIcon *foIconOn = [FAKIonIcons personIconWithSize:NAV_BAR_ICON_SIZE];
    [foIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
    UIImage *foImgOn =[foIconOn imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    
    FAKIcon *foIconOff = [FAKIonIcons personAddIconWithSize:NAV_BAR_ICON_SIZE];
    [foIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *foImgOff =[foIconOff imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    self.foBtn = [[ToggleButton alloc] initWithFrame:CGRectMake(260, 50 , 25, 25)];
    __weak StaffDetailViewController *selfDelegate = self;
    [self.foBtn setToggleButtonOnImage:foImgOn offImg:foImgOff toggleEventHandler:^(BOOL isOn){
        [selfDelegate foClick:isOn];
    }];
    [self.scrollView addSubview:self.foBtn];
    
#pragma topbar
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, profileViewHeight, WIDTH(headerView_), addressViewHeight)];
    UIImageView *addressViewBg = [[UIImageView alloc] initWithFrame:addressView.bounds];
    addressViewBg.image = [UIImage imageNamed:@"Profile_Bottom_Bg"];
    [addressView addSubview:addressViewBg];
    [headerView_ addSubview:addressView];
    
    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, profileViewHeight - avatorSize/2, avatorSize, avatorSize)];
    self.avatorImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatorImgView.layer.borderWidth = 1;
    [self.avatorImgView setImageWithURL:[NSURL URLWithString:@"http://images-fast.digu365.com/sp/width/736/2fed77ea4898439f94729cd9df5ee5ca0001.jpg"]];
    [headerView_ addSubview:self.avatorImgView];
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70 + 5, 0, WIDTH(addressView) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.textColor = [UIColor blackColor];
    self.nameLbl.font = [UIFont boldSystemFontOfSize:14];
    self.nameLbl.text = @"Danny";
    self.nameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.nameLbl];
    self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(self.nameLbl),MaxY(self.nameLbl), WIDTH(addressView) - 10 - MaxX(self.avatorImgView) - 100, 20)];
    self.groupNameLbl.backgroundColor = [UIColor clearColor];
    self.groupNameLbl.textColor = [UIColor grayColor];
    self.groupNameLbl.font = [UIFont systemFontOfSize:12];
    self.groupNameLbl.text = self.staff.group.name;
    self.groupNameLbl.textAlignment = NSTextAlignmentLeft;;
    [addressView addSubview:self.groupNameLbl];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl), Y(self.self.groupNameLbl),20,20)];
    FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:20];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"000"]];
    locationImg.image = [locationIcon imageWithSize:CGSizeMake(20, 20)];
    [addressView addSubview:locationImg];
    
    
    self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg) + 2, Y(locationImg),70,20)];
    self.distanceLbl.textAlignment = NSTextAlignmentLeft;
    self.distanceLbl.textColor = [UIColor grayColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:12];
    self.distanceLbl.backgroundColor = [UIColor clearColor];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.2f 千米", self.staff.distance];
    [addressView addSubview:self.distanceLbl];
    float contentPadding = 10;
    float scrollViewOffsetY = MaxY(addressView);
    if(self.staff.services.count > 0){
        NSMutableArray *services =[NSMutableArray arrayWithArray:self.staff.services];
        [services insertObject:[Service new] atIndex:0]; // this is for title cell
        UIScrollView *serviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(addressView)+contentPadding, 300, 0)];
        float serviceOffsetY = 0;
        float serviceCellHeight = 30;
        float serviceItemWidth = 300/3;
        for (int i = 0; i < services.count; i++) {
            Service *service = services[i];
            
            float serviceItemHeight = [Util heightFortext:service.name
                                               minumHeight:serviceCellHeight
                                                fixedWidth:serviceItemWidth];
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceOffsetY, WIDTH(serviceScrollView), serviceItemHeight )];
            cellView.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
            cellView.layer.borderWidth = 1;
            cellView.backgroundColor = i == 0? [UIColor lightGrayColor] : [UIColor whiteColor];
            [serviceScrollView addSubview:cellView];
            
            
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          serviceItemWidth,
                                                                          serviceItemHeight)];
            titleLbl.font = [UIFont systemFontOfSize:12];
            titleLbl.numberOfLines = 0;
            titleLbl.textAlignment = NSTextAlignmentCenter;
            titleLbl.textColor = [UIColor blackColor];
            [cellView addSubview:titleLbl];
            
            
            UILabel *originalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(titleLbl)+1,
                                                                          0,
                                                                          serviceItemWidth,
                                                                          serviceItemHeight)];
            originalPriceLbl.font = [UIFont systemFontOfSize:12];
            originalPriceLbl.numberOfLines = 0;
            originalPriceLbl.textAlignment = NSTextAlignmentCenter;
            originalPriceLbl.textColor = [UIColor blackColor];

            [cellView addSubview:originalPriceLbl];
            
            UILabel *salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(originalPriceLbl)+1,
                                                                                  0,
                                                                                  serviceItemWidth,
                                                                                  serviceItemHeight)];
            salePriceLbl.font = [UIFont systemFontOfSize:12];
            salePriceLbl.numberOfLines = 0;
            salePriceLbl.textAlignment = NSTextAlignmentCenter;
            salePriceLbl.textColor = [UIColor blackColor];

            [cellView addSubview:salePriceLbl];
            serviceOffsetY += serviceItemHeight;
            
            if(i == 0){
                titleLbl.text = @"项目";
                originalPriceLbl.text = @"原价";
                salePriceLbl.text = @"折扣价";
            }else{
                titleLbl.text = service.name;
                originalPriceLbl.text = [NSString stringWithFormat:@"%.2f", service.originalPrice];
                salePriceLbl.text = [NSString stringWithFormat:@"%.2f", service.salePrice];
                
                UIView *deleteLine = [[UIView alloc] initWithFrame:CGRectMake(20, HEIGHT(originalPriceLbl)/2, WIDTH(originalPriceLbl) - 40, 1)];
                deleteLine.backgroundColor = [UIColor lightGrayColor];
                [originalPriceLbl addSubview:deleteLine];
            }
        }
        
        UIView *cellSeparaterView = [[UIView alloc] initWithFrame:CGRectMake(101,
                                                                             serviceCellHeight,
                                                                             1,
                                                                             serviceOffsetY - serviceCellHeight )];
        cellSeparaterView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [serviceScrollView addSubview:cellSeparaterView];
        
        UIView *cellSeparaterView2 = [[UIView alloc] initWithFrame:CGRectMake(201,
                                                                             serviceCellHeight,
                                                                             1,
                                                                             serviceOffsetY - serviceCellHeight )];
        cellSeparaterView2.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [serviceScrollView addSubview:cellSeparaterView2];
        
        CGRect newFrame = serviceScrollView.frame;
        newFrame.size.height = serviceOffsetY;
        serviceScrollView.frame = newFrame;
        [self.scrollView addSubview:serviceScrollView];
        scrollViewOffsetY = MaxY(serviceScrollView);
    }
    
    if(self.staff.works.count > 0){
        
        UIImageView *workTitleImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, scrollViewOffsetY + contentPadding, 20, 20)];
        workTitleImg.image = [UIImage imageNamed:@"StaffCellI_WorkIcon"];
        [self.scrollView addSubview:workTitleImg];
        
        UILabel *workTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(workTitleImg)+5,
                                                                          Y(workTitleImg),
                                                                          scrollViewOffsetY,
                                                                          20)];
        workTitleLbl.font = [UIFont systemFontOfSize:16];
        workTitleLbl.numberOfLines = 1;
        workTitleLbl.textAlignment = NSTextAlignmentLeft;
        workTitleLbl.textColor = [UIColor blackColor];
        workTitleLbl.text = @"作品";
        [self.scrollView addSubview:workTitleLbl];
        
        UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(contentPadding, MaxY(workTitleLbl) + 5, 300, 60 )];
        workView.layer.cornerRadius = 5;
        workView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:workView];
        float imgHorizontalPadding = 5;
        float imgVeritalPadding = 3;
        float imgSize = 54;
        int count = MIN(self.staff.works.count, 5);
        for (int i=0; i<count; i++) {
            if(i < 4){
                Work *work  =self.staff.works[i];
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
                img.userInteractionEnabled = YES;
                img.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
                img.layer.borderWidth = 1;
                img.tag = i;
                [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
                [workView addSubview:img];
                [img setImageWithURL:[NSURL URLWithString:work.imgUrlList[0]]];

            }else{
                UILabel *moreLbl = [[UILabel alloc] initWithFrame:CGRectMake(imgHorizontalPadding + i *(imgHorizontalPadding + imgSize), imgVeritalPadding, imgSize, imgSize)];
                moreLbl.font = [UIFont systemFontOfSize:16];
                moreLbl.numberOfLines = 1;
                moreLbl.textAlignment = NSTextAlignmentCenter;
                moreLbl.textColor = [UIColor blackColor];
                moreLbl.text = @"更多";
                moreLbl.tag =  i;
                moreLbl.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
                moreLbl.layer.borderWidth = 1;
                [workView addSubview:moreLbl];
                moreLbl.userInteractionEnabled = YES;
                [moreLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workImgTapped:)]];
            }
        }
        scrollViewOffsetY = MaxY(workView);
    }
    
    if(self.staff.bio.length > 0){
        UIImageView *bioImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentPadding, scrollViewOffsetY + contentPadding, 20, 20)];
        bioImg.image = [UIImage imageNamed:@"StaffDetailViewControl_Memo"];
        [self.scrollView addSubview:bioImg];
        
        UILabel *bioTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(bioImg)+5,
                                                                          Y(bioImg),
                                                                          scrollViewOffsetY,
                                                                          20)];
        bioTitleLbl.font = [UIFont systemFontOfSize:16];
        bioTitleLbl.numberOfLines = 1;
        bioTitleLbl.textAlignment = NSTextAlignmentLeft;
        bioTitleLbl.textColor = [UIColor blackColor];
        bioTitleLbl.text = @"备注";
        [self.scrollView addSubview:bioTitleLbl];
        

        float bioHeight = [Util heightFortext:self.staff.bio minumHeight:40 fixedWidth:WIDTH(self.view) -  4 *contentPadding];
        UIView *bioView = [[UIView alloc] initWithFrame:CGRectMake( contentPadding,
                                                                 MaxY(bioTitleLbl) + 5,
                                                                 WIDTH(self.view) -  2*contentPadding,
                                                                 bioHeight + 10)];
        bioView.backgroundColor = [UIColor whiteColor];
        bioView.layer.cornerRadius = 5;
        [self.scrollView addSubview:bioView];
        UILabel *bioLbl = [[UILabel alloc] initWithFrame:CGRectMake(contentPadding,
                                                                        5,
                                                                         WIDTH(bioView) - 2 *contentPadding,
                                                                         bioHeight)];
        [bioView addSubview:bioLbl];
        bioLbl.font = [UIFont systemFontOfSize:14];
        bioLbl.numberOfLines = 0;
        bioLbl.textAlignment = NSTextAlignmentLeft;
        bioLbl.textColor = [UIColor blackColor];
        bioLbl.text = self.staff.bio;

        scrollViewOffsetY = MaxY(bioView);
    }
    
    UIView *commentCellView = [[UIView alloc] initWithFrame:CGRectMake(10, scrollViewOffsetY + 20, 300, 40)];
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MaxY(commentCellView) + 10);
    self.scrollView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset   = self.scrollView.contentOffset.y;
    
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

- (void)foClick:(BOOL)isFo
{
    if(isFo){
       [SVProgressHUD showSuccessWithStatus:@"关注成功" duration:1];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"取消关注" duration:1];
    }
}


- (void)workImgTapped:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if(view.tag <4){
        Work *work = self.staff.works[view.tag];
        WorkDetailViewController *detail = [WorkDetailViewController new];
        detail.work = work;
        [self.navigationController pushViewController:detail animated:YES];
    }else if(view.tag == 4){
        [self.navigationController pushViewController:[StaffWorksViewController new] animated:YES];
    }
}


- (void)submitClick
{
    OpitionSelectPanel *panel =
    [[OpitionSelectPanel alloc] initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH(self.view),
                                                         HEIGHT(self.view) - self.topBarOffset )];
    
    
    [panel setupTitle:@"产品"
             opitions:[self buildSelectionOpition]
               cancel:^(){[self.tabBarController dismissSemiModalView];}
               submit:^(SelectOpition *opitions){
                   self.selectOpition =opitions;
                   [self.tabBarController dismissSemiModalView];
                   [self.navigationController pushViewController:[AppointmentPreviewViewController new] animated:YES];
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
    category.title = @"服务项目";
    
    NSMutableArray *items = [NSMutableArray array];
    OpitionItem *item = [OpitionItem new];
    item.id = 0;
    item.categoryId = category.id;
    item.title =  @"精剪";
    [items addObject:item];
    
    OpitionItem *item2 = [OpitionItem new];
    item2.id = 1;
    item2.categoryId = category.id;
    item2.title =  @"烫染";
    [items addObject:item2];
    
    OpitionItem *item3 = [OpitionItem new];
    item3.id = 2;
    item3.categoryId = category.id;
    item3.title =  @"保养";
    [items addObject:item3];
    category.opitionItems = items;
    
    self.selectOpition.opitionCateogries = @[category];
    self.selectOpition.selectedValues = [NSArray array];
    
    return self.selectOpition;
}

- (void)commentsTapped
{
    [self.navigationController pushViewController:[CommentsViewController new] animated:YES];
}

@end
