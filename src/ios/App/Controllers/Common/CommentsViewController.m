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
#import "MWPhotoBrowser.h"
#import "UserManager.h"

@interface CommentsViewController ()<UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *requestString;

@property (nonatomic, strong) NSMutableArray *workImgs;

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
    if([self checkLogin]){
        CommentComposorViewController *commentComposorVc = [[CommentComposorViewController alloc] init];;
        commentComposorVc.hidesBottomBarWhenPushed = YES;
        commentComposorVc.userId = self.userId;
        commentComposorVc.companyId = self.companyId;
        commentComposorVc.workId = self.workId;
        commentComposorVc.goodsId = self.goodsId;

        [self.navigationController pushViewController:commentComposorVc animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerTablePullToRefresh) name:NOTIFICATION_REFRESH_COMMENTLIST object:nil];
    
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

    [self triggerTablePullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.goodsId > 0) {
        self.rightNavItemImg = nil;
    }
    [super viewWillAppear:animated];
}

- (void)triggerTablePullToRefresh
{
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comm = [self.datasource objectAtIndex:indexPath.row];
    CGSize textSize = [Util textSizeForText:comm.description withFont:[UIFont systemFontOfSize:12] andLineHeight:20];

    CGFloat containerHeight = textSize.height + 44;
    if (containerHeight < 60) {
        containerHeight = 60;
    }

    if (comm.imgUrlList.count > 0) {
        containerHeight += 46;
    }

    return containerHeight;
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
    }

    Comment *data = [self.datasource objectAtIndex: indexPath.row];
    [cell setup:data tapHandler:^(NSArray *imgArr, int currentIndex) {
        self.workImgs = [NSMutableArray array];
        for (UIImageView *item in imgArr) {
            if (!item.image) {
                continue;
            }
            [self.workImgs addObject:[MWPhoto photoWithImage:item.image]];
        }

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = YES;
        browser.wantsFullScreenLayout = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        [browser setCurrentPhotoIndex:currentIndex];

        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:nc animated:YES completion:Nil];
    }];

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
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.workImgs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.workImgs.count) {
        return [self.workImgs objectAtIndex:index];
    }

    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.workImgs objectAtIndex:index];
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
