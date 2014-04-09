//
//  FavoritesViewController.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FavoritesViewController.h"
#import "PPiFlatSegmentedControl.h"
@interface FavoritesViewController ()
@property (nonatomic) int activeIndex;
@property (nonatomic, strong) i
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
    PPiFlatSegmentedControl *segment=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, self.topBarOffset + 10, 300, 30) items:@[               @{@"text":@"作品"},                                                          @{@"text":@"沙龙"},
                                                                                                                                          @{@"text":@"设计师"},
                                                                                                                                          @{@"text":@"商品"}
                                                                                                                                          ]
                                                                          iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                              
                                                                          } iconSeparation:5];
    segment.color=[UIColor whiteColor];
    segment.borderWidth=0.5;
    segment.borderColor=[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    segment.selectedColor=[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
    segment.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR]};
    segment.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                        NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:segment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
