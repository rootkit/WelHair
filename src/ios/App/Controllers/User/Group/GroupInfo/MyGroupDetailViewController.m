//
//  MyGroupStaffDetailViewController.m
//  WelHair
//
//  Created by lu larry on 4/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "MyGroupDetailViewController.h"
#import <AMRatingControl.h>
#import "CreateGroupViewController.h"
#import "MWPhotoBrowser.h"
@interface MyGroupDetailViewController ()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *groupAvatorImg;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) AMRatingControl *rateCtrl;

@property (nonatomic, strong) NSMutableArray *groupImages;
@end

@implementation MyGroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"沙龙资料";
        FAKIcon *rightIcon = [FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
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

- (void)rightNavItemClick
{
    CreateGroupViewController *vc = [CreateGroupViewController new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.group = [FakeDataHelper getFakeGroupList][0];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBarOffset,
                                                                     WIDTH(self.view),
                                                                     [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    [self.view addSubview:self.scrollView];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH(self.scrollView), 130)];
    [self.scrollView addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    UIView *headerFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.headerView), WIDTH(self.headerView), 7)];
    headerFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [self.scrollView addSubview:headerFooterView];
    
    self.groupAvatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100 , 100)];
    [self.groupAvatorImg setImageWithURL:[NSURL URLWithString:self.group.logoUrl]];
    [self.headerView addSubview:self.groupAvatorImg];
    
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, 10, 200, 30)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor blackColor];
    self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
    self.nameLbl.textAlignment = TextAlignmentLeft;
    self.nameLbl.text = self.group.name;
    [self.headerView addSubview:self.nameLbl];
    
    
    self.rateCtrl = [[AMRatingControl alloc] initWithLocation:CGPointMake(X(self.nameLbl), MaxY(self.nameLbl) )
                                                   emptyColor:[UIColor colorWithHexString:@"ffc62a"]
                                                   solidColor:[UIColor colorWithHexString:@"ffc62a"]
                                                 andMaxRating:5];
    [self.headerView addSubview:self.rateCtrl];
    self.rateCtrl.enabled = NO;
    [self.rateCtrl setRating:4];
    
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, MaxY(self.nameLbl)+30, 200, 30)];
    self.phoneLbl.backgroundColor = [UIColor clearColor];
    self.phoneLbl.textColor = [UIColor blackColor];
    self.phoneLbl.font = [UIFont systemFontOfSize:14];
    self.phoneLbl.textAlignment = TextAlignmentLeft;
    self.phoneLbl.text =  @"13333333";
    [self.headerView addSubview:self.phoneLbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupAvatorImg) + 10, MaxY(self.phoneLbl), 200, 30)];
    self.addressLbl.backgroundColor = [UIColor clearColor];
    self.addressLbl.textColor = [UIColor blackColor];
    self.addressLbl.font = [UIFont systemFontOfSize:14];
    self.addressLbl.textAlignment = TextAlignmentLeft;
    self.addressLbl.text = self.group.address;
    [self.headerView addSubview:self.addressLbl];
    
    
    for (int i =0 ; i < self.group.imgUrls.count; i ++) {
        UIImageView *img;
        if(i == 0){
            img = [[UIImageView alloc] initWithFrame:CGRectMake(15 , MaxY(self.headerView) + 20, 90 , 90)];
        }else if(i == 1 ){
            img = [[UIImageView alloc] initWithFrame:CGRectMake(115 , MaxY(self.headerView) + 20, 90 , 90)];
        }else if(i == 2 ){
            img = [[UIImageView alloc] initWithFrame:CGRectMake(225 , MaxY(self.headerView) + 20, 90 , 90)];
        }else if(i == 3 ){
            img = [[UIImageView alloc] initWithFrame:CGRectMake(15 , MaxY(self.headerView) + 120, 90 , 90)];
        }
        [self.scrollView addSubview:img];
        [img setImageWithURL:[NSURL URLWithString:self.group.imgUrls[i]]];
        img.userInteractionEnabled = YES;
        img.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        img.layer.borderWidth = 1;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapp)]];
        [img drawBottomShadowOffset:1 opacity:1];
    }
    self.groupImages = [NSMutableArray array];
    for (NSString *item in self.group.imgUrls) {
        [self.groupImages addObject:[MWPhoto photoWithURL:[NSURL URLWithString:item]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imgTapp
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
    return self.groupImages.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.groupImages.count) {
        return [self.groupImages objectAtIndex:index];
    }
    
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.groupImages objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    
    return captionView ;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
}


@end
