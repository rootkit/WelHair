//
//  StaffWorksViewController.m
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "StaffWorksViewController.h"
#import "DoubleCoverCell.h"
#import "WorkDetailViewController.h"
#import "UploadWorkFormViewController.h"

@interface StaffWorksViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation StaffWorksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"作品集";
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        FAKIcon *rightIcon = [FAKIonIcons ios7PlusIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void) leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[UploadWorkFormViewController new] animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.editable){
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   self.topBarOffset,
                                                                   WIDTH(self.view),
                                                                   [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.datasource = [FakeDataHelper getFakeWorkList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.datasource.count/2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffTripleCellIdentifier";
    DoubleCoverCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DoubleCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Work *leftdata = [self.datasource objectAtIndex: (2 * indexPath.row)];
    Work *rightData;
    if(self.datasource.count > indexPath.row * 2 + 1){
        rightData = [self.datasource objectAtIndex:indexPath.row * 2 + 1];
    }
    __weak StaffWorksViewController *selfDelegate = self;
    [cell setupWithLeftData:leftdata rightData:rightData tapHandler:^(id model){
        Work *work = (Work *)model;
        [selfDelegate pushToDetial:work];}
     ];
    return cell;
}

- (void)pushToDetial:(Work *)work
{
    WorkDetailViewController *workVc = [[WorkDetailViewController alloc] init];;
    workVc.work = work;
    workVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workVc animated:YES];
}

@end
