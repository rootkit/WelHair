//
//  MyScoreViewController.m
//  WelHair
//
//  Created by lu larry on 3/20/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "MyScoreViewController.h"
#import "MyScoreCell.h"
@interface MyScoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *linerView;

@property (nonatomic, strong) UILabel *scoreLbl;
@end

@implementation MyScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  @"我的积分";
        
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

- (void)loadView
{
    [super loadView];
    
    float topViewheight = 50;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), topViewheight)];
    [self.view addSubview:topView];
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:topView.bounds];
    topImageView.image = [UIImage imageNamed:@"Profile_Bottom_Bg"];
    [topView addSubview:topImageView];
    UILabel *scoreTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,topViewheight)];
    scoreTitleLbl.backgroundColor = [UIColor clearColor];
    scoreTitleLbl.textColor = [UIColor blackColor];
    scoreTitleLbl.font = [UIFont systemFontOfSize:18];
    scoreTitleLbl.text = @"我的积分:";
    scoreTitleLbl.textAlignment = NSTextAlignmentRight;
    [topView addSubview:scoreTitleLbl];
    
    self.scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(scoreTitleLbl),0,200,topViewheight)];
    self.scoreLbl.backgroundColor = [UIColor clearColor];
    self.scoreLbl.textColor = [UIColor colorWithHexString:APP_BASE_COLOR];
    self.scoreLbl.font = [UIFont systemFontOfSize:18];
    self.scoreLbl.textAlignment = NSTextAlignmentLeft;;
    [topView addSubview:self.scoreLbl];
    
    self.linerView =[[UIView alloc] init];
    self.linerView.backgroundColor = [UIColor colorWithHexString:APP_BASE_COLOR];
    [self.view addSubview:self.linerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   MaxY(topView),
                                                                   WIDTH(self.view),
                                                                   [self contentHeightWithNavgationBar:YES withBottomBar:NO] - topViewheight)];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self loadData];
}
- (void)loadData
{
    self.datasource = [FakeDataHelper getFakeWorkList];
    self.linerView.frame =CGRectMake(37,Y(self.tableView), 6, (self.datasource.count-1) * 100);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scoreLbl.text = @"1234";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"scoreCellIdentifier";
    MyScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MyScoreCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor =  cell.backgroundColor =  [UIColor clearColor];
    [cell setup:nil isTop:indexPath.row == 0];
    return cell;
}

@end
