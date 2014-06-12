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

#import "OrderListViewController.h"
#import "OrderPreviewViewController.h"
#import "OrderPaidTableView.h"
#import "OrderUnpaidTableView.h"
#import "PPiFlatSegmentedControl.h"


@interface OrderListViewController ()

@property (nonatomic, strong) PPiFlatSegmentedControl *segment;

@property (nonatomic, strong) UIView *segmentContentView;
@property (nonatomic) int activeIndex;

@property (nonatomic, strong) OrderPaidTableView *paidTableView;
@property (nonatomic, strong) OrderUnpaidTableView *unpaidTableView;

@end

@implementation OrderListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订单列表";

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 40)];
    segmentView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [self.view addSubview:segmentView];
    __weak typeof(self) selfDelegate = self;
    self.segment=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, 5, 300, 30) items:@[@{@"text":@"未付款"},@{@"text":@"已付款"}]
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

    OrderUnpaidTableView *tblV = [[OrderUnpaidTableView alloc] initWithFrame:self.segmentContentView.bounds];
    tblV.baseController = self;
    self.unpaidTableView = tblV;
    [self.segmentContentView addSubview:self.unpaidTableView];
    
    [self segmentButtonSelected:0];
    [self.view bringSubviewToFront:segmentView];

}

- (void)segmentButtonSelected:(int)index
{
    if (self.activeIndex == index) {
        return;
    }

    self.activeIndex = index;
    self.unpaidTableView.hidden = YES;
    self.paidTableView.hidden = YES;
    switch (self.activeIndex) {
        case 0:
        {
            self.unpaidTableView.hidden = NO;
        }
            break;
        case 1:
        {
            if(!self.paidTableView){
                OrderPaidTableView *tblV = [[OrderPaidTableView alloc] initWithFrame:self.segmentContentView.bounds];
                tblV.baseController = self;
                self.paidTableView = tblV;
                [self.segmentContentView addSubview:self.paidTableView];
            }
            self.paidTableView.hidden = NO;
        }
            break;
    
        default:
            break;
    }
}


@end
