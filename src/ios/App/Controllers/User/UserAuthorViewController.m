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

#import "CreateGroupViewController.h"
#import "JoinGroupViewController.h"
#import "User.h"
#import "UserAuthorViewController.h"
#import "UserManager.h"

@interface UserAuthorViewController ()

@property (nonatomic, strong) UILabel *infoLbl;
@property (nonatomic, strong) UIView *addToSalonView;
@property (nonatomic, strong) UIView *createSalonView;

@end

@implementation UserAuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"请选择";

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
    
    self.infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 150)];
    self.infoLbl.font = [UIFont systemFontOfSize:14];
    self.infoLbl.numberOfLines = 10;
    self.infoLbl.textAlignment = NSTextAlignmentLeft;
    self.infoLbl.backgroundColor = [UIColor clearColor];
    self.infoLbl.textColor = [UIColor grayColor];
    self.infoLbl.text = @"尊敬的用户\n您暂时还没有沙龙角色\n请选择添加沙龙(沙龙管理员）\n或作为发型师加入沙龙";
    [self.view addSubview:self.infoLbl];
    
    self.addToSalonView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    self.addToSalonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addToSalonView];
    [self.addToSalonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToSalonTapped)]];

    UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    commentLbl.font = [UIFont systemFontOfSize:14];
    commentLbl.textAlignment = NSTextAlignmentLeft;
    commentLbl.backgroundColor = [UIColor clearColor];
    commentLbl.textColor = [UIColor grayColor];
    commentLbl.text = @"加入沙龙";
    [self.addToSalonView addSubview:commentLbl];

    FAKIcon *commentIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.addToSalonView) - 40, 10, 20, 20)];
    commentImgView.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [self.addToSalonView addSubview:commentImgView];
    
    self.createSalonView = [[UIView alloc] initWithFrame:CGRectMake(20, MaxY(self.addToSalonView) + 10, 280, 40)];
    self.createSalonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.createSalonView];
    [self.createSalonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createSalonTapped)]];

    UILabel *createSalonLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    createSalonLbl.font = [UIFont systemFontOfSize:14];
    createSalonLbl.textAlignment = NSTextAlignmentLeft;
    createSalonLbl.backgroundColor = [UIColor clearColor];
    createSalonLbl.textColor = [UIColor grayColor];
    createSalonLbl.text = @"创建沙龙";
    [self.createSalonView addSubview:createSalonLbl];

    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.addToSalonView) - 40, 10, 20, 20)];
    arrowImg.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [self.createSalonView addSubview:arrowImg];
}

- (void)addToSalonTapped
{
    [self.navigationController pushViewController:[JoinGroupViewController new] animated:YES];
}

- (void)createSalonTapped
{
    [self.navigationController pushViewController:[CreateGroupViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
