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

#import "Comment.h"
#import "CommentCell.h"
#import "CommentComposorViewController.h"
#import "CommentsViewController.h"
#import "LoginViewController.h"
#import "UserManager.h"

@interface CommentsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *requestString;

@end

@implementation CommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"评论";

        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        FAKIcon *rightIcon = [FAKIonIcons ios7ComposeOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg =[rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.currentPage = 1;
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavItemClick
{
    if (![UserManager SharedInstance].userLogined) {
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]]
                                                animated:YES
                                              completion:nil];
        return;
    }

    CommentComposorViewController *commentComposorVc = [[CommentComposorViewController alloc] init];;
    commentComposorVc.hidesBottomBarWhenPushed = YES;
    commentComposorVc.userId = self.userId;
    commentComposorVc.companyId = self.companyId;
    commentComposorVc.workId = self.workId;
    commentComposorVc.goodsId = self.goodsId;
    [self.navigationController pushViewController:commentComposorVc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.goodsId > 0) {
        self.requestString = [NSString stringWithFormat:API_GOODS_COMMENT_CREATE, self.goodsId];
    }
    if (self.userId > 0) {
        self.requestString = [NSString stringWithFormat:API_STAFFS_COMMENT_CREATE, self.userId];
    }
    if (self.companyId > 0) {
        self.requestString = [NSString stringWithFormat:API_COMPANIES_COMMENT_CREATE, self.companyId];
    }
    if (self.workId > 0) {
        self.requestString = [NSString stringWithFormat:API_WORKS_COMMENT_CREATE, self.workId];
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getComments];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getComments];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CommentCellIdentifier";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
    }

    Comment *data = [self.datasource objectAtIndex: indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark Group Search API

- (void)getComments
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:self.requestString] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetComments:)];
    [request setDidFailSelector:@selector(failGetComments:)];
    [request startAsynchronous];
}

- (void)finishGetComments:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"comments"];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datasource];

    if (self.currentPage == 1) {
        [arr removeAllObjects];
    } else {
        if (self.currentPage % TABLEVIEW_PAGESIZE_DEFAULT > 0) {
            int i;

            for (i = 0; i < arr.count; i++) {
                if (i >= (self.currentPage - 1) * TABLEVIEW_PAGESIZE_DEFAULT) {
                    [arr removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }

    for (NSDictionary *dicData in dataList) {
        [arr addObject:[[Comment alloc] initWithDic:dicData]];
    }

    self.datasource = arr;

    BOOL enableInfinite = total > self.datasource.count;
    if (self.tableView.showsInfiniteScrolling != enableInfinite) {
        self.tableView.showsInfiniteScrolling = enableInfinite;
    }

    if (self.currentPage == 1) {
        [self.tableView stopRefreshAnimation];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }

    [self checkEmpty];

    [self.tableView reloadData];
}

- (void)failGetComments:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

@end
