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

#import "WelTabBarController.h"
#import "JSBadgeView.h"
@interface WelTabBarController ()
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) NSArray *normalTabImages;
@property (nonatomic, strong) NSArray *selectedTabImages;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) NSMutableArray *badgeViews;

@end

@implementation WelTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabButtons = [NSMutableArray array];
    self.badgeViews = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViewControls:(NSArray *)viewControls
               tabHeight:(float)tabHeight
        tabNormalImages:(NSArray *)tabNormalImages
       tabSelectedImages:(NSArray *)tabSelectedImages


{
    self.viewControllers = viewControls;
    self.normalTabImages = tabNormalImages;
    self.selectedTabImages = tabSelectedImages;
    [self setupTabs:tabHeight];
    [self setTabSelected:0];
    self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setupTabs:(float)tabHeight
{
    
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            HEIGHT(self.view) - tabHeight,
                                                            WIDTH(self.view),
                                                            tabHeight)];
    if(isIOS7){
        [self.tabBar setBarTintColor:[UIColor colorWithHexString:APP_CONTENT_BG_COLOR]];
    }else{
        [self.tabBar setTintColor:[UIColor colorWithHexString:APP_CONTENT_BG_COLOR]];
    }
//    UIView *tabBgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(self.view) - 49, WIDTH(self.tabView), 49)];
//    tabBgView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
//    [self.view addSubview:tabBgView];
    [self.view addSubview:self.tabView];
    self.tabView.backgroundColor = [UIColor clearColor];
    int tabNum= MAX(self.normalTabImages.count, self.selectedTabImages.count);
    float tabWidth = WIDTH(self.view)/tabNum;
    for (int i=0; i < tabNum; i++) {
        UIImage *tabNormalImg = [self.normalTabImages objectAtIndex:i];
        UIImage *tabSelectedImg = [self.selectedTabImages objectAtIndex:i];
        
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(i * tabWidth, 0, tabWidth, tabHeight);
        tabButton.backgroundColor = [UIColor clearColor];
        tabButton.tag = i;
        tabButton.adjustsImageWhenHighlighted = NO;
        [tabButton addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
        [tabButton setBackgroundImage:tabNormalImg forState:UIControlStateNormal];
        [tabButton setBackgroundImage:tabSelectedImg forState:UIControlStateSelected | UIControlStateHighlighted];
        [tabButton setBackgroundImage:tabSelectedImg forState:UIControlStateSelected];
        [self.tabButtons addObject:tabButton];
        [self.tabView addSubview:tabButton];
        
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(tabButton.frame.origin.x + 44,
                                                                    tabButton.frame.origin.y + 10,
                                                                    1, 1)];
        badgeView.backgroundColor = [UIColor clearColor];
        [self.tabView addSubview:badgeView];
        [self.badgeViews addObject:badgeView];
    }
}

- (void)tabClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self setTabSelected:btn.tag];
}

- (void)setTabSelected:(int)idx
{
    UIButton *previousTab = [self.tabButtons objectAtIndex:self.selectedIndex];
    [previousTab setSelected:NO];
    
    self.selectedIndex = idx;
    UIButton *selectingTab = [self.tabButtons objectAtIndex:self.selectedIndex];
    [selectingTab setSelected:YES];
}

- (void)hideTabBarAnimation:(BOOL)animation
{
    if(Y(self.tabView) >=HEIGHT(self.view)){
        return;
    }
    float duration = animation? 0.3 : 0;
    [UIView transitionWithView:self.tabView
                      duration:duration
                       options:UIViewAnimationOptionCurveLinear
                    animations:
     ^{
         self.tabView.transform = CGAffineTransformMakeTranslation(0,HEIGHT(self.tabView));
     }
                    completion:NULL];

}

- (void)showTabBarAnimation:(BOOL)animation
{
    if(Y(self.tabView) <HEIGHT(self.view)){
        return;
    }
    float duration = animation? 0.3 : 0;
    [UIView transitionWithView:self.tabView
                      duration:duration
                       options:UIViewAnimationOptionCurveLinear
                    animations:
     ^{
         self.tabView.transform = CGAffineTransformMakeTranslation(0,0);
     }
                    completion:NULL];
    
}

- (void)setBadge:(int)number
         atIndex:(int)index
{
    if(number > 0){
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:[self.badgeViews objectAtIndex:index] alignment:JSBadgeViewAlignmentCenterRight];
        badgeView.badgeText = [NSString stringWithFormat:@"%d", number];
        [badgeView setNeedsDisplay];
    }else{
        for (UIView *view  in ((UIView *)[self.badgeViews objectAtIndex:index]).subviews) {
            if([view isKindOfClass:[JSBadgeView class]]){
                [view removeFromSuperview];
            }
        }
    }
}

@end
