//
//  AddressListViewController.m
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"

@interface AddressListViewController ()

@end

@implementation AddressListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"新建";
        
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[AddAddressViewController new] animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.topBarOffset, 320,320)];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"AddressListViewControl_TempBg"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:selectBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectClick
{
    [self.delegate didPickAddress];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
