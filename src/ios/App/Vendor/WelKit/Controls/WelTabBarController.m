//
//  WelTabBarController.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "WelTabBarController.h"

@interface WelTabBarController ()
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) NSArray *normalTabImages;
@property (nonatomic, strong) NSArray *selectedTabImages;
@property (nonatomic, strong) NSMutableArray *tabButtons;

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
    [self hideTabBar];
    self.tabButtons = [NSMutableArray array];
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
}

- (void)setupTabs:(float)tabHeight
{
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            HEIGHT(self.view) - tabHeight,
                                                            WIDTH(self.view),
                                                            tabHeight)];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tabView];

    int tabNum= MAX(self.normalTabImages.count, self.selectedTabImages.count);
    float tabWidth = WIDTH(self.view)/tabNum;
    for (int i=0; i < tabNum; i++) {
        UIImage *tabNormalImg = [self.normalTabImages objectAtIndex:i];
        UIImage *tabSelectedImg = [self.selectedTabImages objectAtIndex:i];
        
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(i * tabWidth, 0, tabWidth, tabHeight);
        tabButton.backgroundColor = [UIColor clearColor];
        tabButton.tag = i;
        [tabButton addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
        [tabButton setBackgroundImage:tabNormalImg forState:UIControlStateNormal];
        [tabButton setBackgroundImage:tabSelectedImg forState:UIControlStateSelected];
        [self.tabButtons addObject:tabButton];
        [self.tabView addSubview:tabButton];
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

- (void)hideTabBar
{
    self.view.backgroundColor = [UIColor whiteColor];
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
            view.hidden = YES;
			break;
		}
	}
}

- (void)hideTabBarAnimation:(BOOL)animation
{
    float duration = animation? 0.5 : 0;
    [UIView transitionWithView:self.tabView
                      duration:duration
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:
     ^{
         self.tabView.transform = CGAffineTransformMakeTranslation(0,HEIGHT(self.tabView));
     }
                    completion:NULL];

}

- (void)showTabBarAnimation:(BOOL)animation
{
    float duration = animation? 0.5 : 0;
    [UIView transitionWithView:self.tabView
                      duration:duration
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:
     ^{
         self.tabView.transform = CGAffineTransformMakeTranslation(0,0);
     }
                    completion:NULL];
    
}


@end
