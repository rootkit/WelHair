//
//  FavoritesViewController.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FavoritesViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "FavoriteWorkTableView.h"
#import "FavoriteGroupTableView.h"

#import "WorkDetailViewController.h"
#import "StaffDetailViewController.h"
#import "GroupDetailViewController.h"
#import "ProductDetailViewController.h"

@interface FavoritesViewController ()
@property (nonatomic, strong) PPiFlatSegmentedControl *segment;
@property (nonatomic, strong) FavoriteWorkTableView *workTableView;
@property (nonatomic, strong) FavoriteGroupTableView *groupTableView;
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
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), 40)];
    segmentView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
    [self.view addSubview:segmentView];
    __weak typeof(self) selfDelegate = self;
    self.segment=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 300, 30) items:@[               @{@"text":@"作品"},                                                          @{@"text":@"沙龙"},
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
    
    self.workTableView = [[FavoriteWorkTableView alloc] initWithFrame:self.segmentContentView.bounds];
    [self.segmentContentView addSubview:self.workTableView];
    
    [self segmentButtonSelected:0];
    [self.view bringSubviewToFront:segmentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)segmentButtonSelected:(int)index{
    if(self.activeIndex == index){
        return;
    }
    self.activeIndex = index;
    switch (self.activeIndex) {
        case 0:
        {
            self.workTableView.hidden = NO;
            self.groupTableView.hidden = YES;
        }
            break;
        case 1:
        {
            if(!self.groupTableView){
                self.groupTableView = [[FavoriteGroupTableView alloc] initWithFrame:self.segmentContentView.bounds];
                [self.segmentContentView addSubview:self.groupTableView];
            }
            self.workTableView.hidden = YES;
            self.groupTableView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}



@end
