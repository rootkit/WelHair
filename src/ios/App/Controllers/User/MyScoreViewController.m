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

#import "MyScoreCell.h"
#import "MyScoreViewController.h"
#import "UserManager.h"

@interface MyScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
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
    topView.backgroundColor = [UIColor whiteColor];
    
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
    
    UIView *topFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(topView), WIDTH(topView), 7)];
    topFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Juchi"]];
    [self.view addSubview:topFooterView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   MaxY(topFooterView),
                                                                   WIDTH(self.view),
                                                                   [self contentHeightWithNavgationBar:YES withBottomBar:NO] - topViewheight - 7)];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf getPoints];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
}

- (void)getPoints
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_USERS_POINTS, [UserManager SharedInstance].userLogined.id]] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetPoints:)];
    [request setDidFailSelector:@selector(failGetPoints:)];
    [request startAsynchronous];
}

- (void)finishGetPoints:(ASIHTTPRequest *)request
{
    self.datasource = [Util objectFromJson:request.responseString];

    [self.tableView stopRefreshAnimation];
    [self checkEmpty];

    [self.tableView reloadData];

    int totalPoints = 0;
    for (NSDictionary *dic in self.datasource) {
        totalPoints += [[dic objectForKey:@"Value"] intValue];
    }

    self.scoreLbl.text = [NSString stringWithFormat:@"%d", totalPoints];
}

- (void)failGetPoints:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getPoints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?  [UIColor colorWithHexString:APP_CONTENT_BG_COLOR] : [UIColor whiteColor];
    [cell setup:[self.datasource objectAtIndex:indexPath.row]
          isTop:indexPath.row == 0
       isBottom:indexPath.row == self.datasource.count -1
       isSingle:self.datasource.count ==1];

    return cell;
}

@end
