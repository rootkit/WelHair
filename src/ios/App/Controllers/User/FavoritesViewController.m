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

#import "FavoritesViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "FavoriteWorkTableView.h"
#import "FavoriteGroupTableView.h"
#import "FavoriteStaffTableView.h"
#import "FavoriteProductTableView.h"
#import "WorkDetailViewController.h"
#import "StaffDetailViewController.h"
#import "GroupDetailViewController.h"
#import "ProductDetailViewController.h"

@interface FavoritesViewController ()
@property (nonatomic, strong) PPiFlatSegmentedControl *segment;
@property (nonatomic, strong) FavoriteWorkTableView *workTableView;
@property (nonatomic, strong) FavoriteGroupTableView *groupTableView;
@property (nonatomic, strong) FavoriteStaffTableView *staffTableView;
@property (nonatomic, strong) FavoriteProductTableView *productTableView;

@property (nonatomic, strong) UIView *segmentContentView;
@property (nonatomic) int activeIndex;

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"收藏";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToWorkDetail:)
                                                 name:NOTIFICATION_PUSH_TO_WORK_DETAIL_VIEW
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToGroupDetail:)
                                                 name:NOTIFICATION_PUSH_TO_GROUP_DETAIL_VIEW
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToStaffDetail:)
                                                 name:NOTIFICATION_PUSH_TO_STAFF_DETAIL_VIEW
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToProductDetail:)
                                                 name:NOTIFICATION_PUSH_TO_PRODUCT_DETAIL_VIEW
                                               object:nil];
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 40)];
    segmentView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [self.view addSubview:segmentView];
    __weak typeof(self) selfDelegate = self;
    self.segment=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, 5, 300, 30) items:@[               @{@"text":@"作品"},                                                          @{@"text":@"沙龙"},
                                                                                                                                          @{@"text":@"设计师"},
                                                                                                                                          @{@"text":@"商品"}
                                                                                                                                          ]
                                                                          iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                              [selfDelegate segmentButtonSelected:segmentIndex];
                                                                          } iconSeparation:5];
    self.segment.color=[UIColor whiteColor];
    self.segment.borderWidth=0.5;
    self.segment.borderColor=[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    self.segment.selectedColor=[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    self.segment.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]};
    self.segment.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                        NSForegroundColorAttributeName:[UIColor whiteColor]};
    [segmentView addSubview:self.segment];
    
    self.segmentContentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         MaxY(segmentView),
                                                                         WIDTH(self.view) ,
                                                                         [self contentHeightWithNavgationBar:YES withBottomBar:NO] - HEIGHT(segmentView))];
    self.segmentContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.segmentContentView];

    FavoriteWorkTableView *tblV = [[FavoriteWorkTableView alloc] initWithFrame:self.segmentContentView.bounds];
    tblV.baseControler = self;
    self.workTableView = tblV;
    [self.segmentContentView addSubview:self.workTableView];
    
    [self segmentButtonSelected:0];
    [self.view bringSubviewToFront:segmentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)segmentButtonSelected:(int)index{
    if(self.activeIndex == index){
        return;
    }
    self.activeIndex = index;
    self.workTableView.hidden = YES;
    self.groupTableView.hidden = YES;
    self.staffTableView.hidden = YES;
    self.productTableView.hidden = YES;
    switch (self.activeIndex) {
        case 0:
        {
            self.workTableView.hidden = NO;
        }
            break;
        case 1:
        {
            if(!self.groupTableView){
                FavoriteGroupTableView *tblV = [[FavoriteGroupTableView alloc] initWithFrame:self.segmentContentView.bounds];
                tblV.baseControler = self;
                self.groupTableView = tblV;
                [self.segmentContentView addSubview:self.groupTableView];
            }
            self.groupTableView.hidden = NO;
        }
            break;
        case 2:
        {
            if(!self.staffTableView){
                FavoriteStaffTableView *tblV = [[FavoriteStaffTableView alloc] initWithFrame:self.segmentContentView.bounds];
                tblV.baseControler = self;
                self.staffTableView = tblV;
                [self.segmentContentView addSubview:self.staffTableView];
            }
            self.staffTableView.hidden = NO;
        }
            break;
        case 3:
        {
            if(!self.productTableView){
                FavoriteProductTableView *tblV = [[FavoriteProductTableView alloc] initWithFrame:self.segmentContentView.bounds];
                tblV.baseControler = self;
                self.productTableView = tblV;
                [self.segmentContentView addSubview:self.productTableView];
            }
            self.productTableView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}


- (void)pushToWorkDetail:(NSNotification *)noti
{
    Work *w = (Work *)noti.object;
    WorkDetailViewController *vc = [WorkDetailViewController new];
    vc.work = w;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToGroupDetail:(NSNotification *)noti
{
    Group *g = (Group *)noti.object;
    GroupDetailViewController *vc = [GroupDetailViewController new];
    vc.group = g;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToStaffDetail:(NSNotification *)noti
{
    Staff *s = (Staff *)noti.object;
    StaffDetailViewController *vc = [StaffDetailViewController new];
    vc.staff = s;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToProductDetail:(NSNotification *)noti
{
    Product *p = (Product *)noti.object;
    ProductDetailViewController *vc = [ProductDetailViewController new];
    vc.product = p;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
