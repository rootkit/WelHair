//
//  UserAuthorViewController.m
//  WelHair
//
//  Created by lu larry on 3/13/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "UserAuthorViewController.h"

@interface UserAuthorViewController ()

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
    
    UILabel *infoLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280,150)];
    infoLbl.font = [UIFont systemFontOfSize:14];
    infoLbl.numberOfLines = 10;
    infoLbl.textAlignment = NSTextAlignmentLeft;
    infoLbl.backgroundColor = [UIColor clearColor];
    infoLbl.textColor = [UIColor grayColor];
    infoLbl.text = @"尊敬的用户\n您暂时还没有沙龙角色\n请选择添加沙龙(沙龙管理员）\n或作为发型师加入沙龙";
    [self.view addSubview:infoLbl];
    
    UIView *addToSalonView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    [addToSalonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToSalonTapped)]];
    addToSalonView.backgroundColor = [UIColor whiteColor];
    UILabel *commentLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    commentLbl.font = [UIFont systemFontOfSize:14];
    commentLbl.textAlignment = NSTextAlignmentLeft;
    commentLbl.backgroundColor = [UIColor clearColor];
    commentLbl.textColor = [UIColor grayColor];
    commentLbl.text = @"加入沙龙";
    [addToSalonView addSubview:commentLbl];
    FAKIcon *commentIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:20];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(addToSalonView) - 40, 10, 20, 20)];
    commentImgView.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [addToSalonView addSubview:commentImgView];
    [self.view addSubview:addToSalonView];
    
    UIView *createSalonView = [[UIView alloc] initWithFrame:CGRectMake(20, MaxY(addToSalonView) + 10, 280, 40)];
    [createSalonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createSalonTapped)]];
    createSalonView.backgroundColor = [UIColor whiteColor];
    UILabel *createSalonLbl =[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100,20)];
    createSalonLbl.font = [UIFont systemFontOfSize:14];
    createSalonLbl.textAlignment = NSTextAlignmentLeft;
    createSalonLbl.backgroundColor = [UIColor clearColor];
    createSalonLbl.textColor = [UIColor grayColor];
    createSalonLbl.text = @"创建沙龙";
    [createSalonView addSubview:createSalonLbl];
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(addToSalonView) - 40, 10, 20, 20)];
    arrowImg.image = [commentIcon imageWithSize:CGSizeMake(20, 20)];
    [createSalonView addSubview:arrowImg];
    [self.view addSubview:createSalonView];

}

- (void)addToSalonTapped
{
    [FakeDataHelper setUserJoinGroupSuccess];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_CREATE_GROUP_SUCCESS object:nil];
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
