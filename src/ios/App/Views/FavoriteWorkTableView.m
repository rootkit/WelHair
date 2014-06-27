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

#import "BrickView.h"
#import "FavoriteWorkTableView.h"
#import "Work.h"
#import "WorkCell.h"

@interface FavoriteWorkTableView() <BrickViewDataSource, BrickViewDelegate>

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) BrickView *tableView;
@property (nonatomic) NSInteger currentPage;

- (void)getWorks;

@end

@implementation FavoriteWorkTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentPage = 1;

        self.tableView = [[BrickView alloc] init];
        self.tableView.padding = 10;
        self.tableView.frame = self.bounds;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:self.tableView];

        __weak typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshActionHandler:^{
            weakSelf.currentPage = 1;
            [weakSelf getWorks];
        }];
        
        [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
        [self.tableView.pullToRefreshView setBorderWidth:2];
        [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
        [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            weakSelf.currentPage += 1;
            [weakSelf getWorks];
        }];
        self.tableView.showsInfiniteScrolling = NO;
    }

    [self.tableView triggerPullToRefresh];

    return self;
}

#pragma mark UITableView delegate

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 215;
}

- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 2;
}

- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return  self.datasource.count;
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    static NSString * cellIdentifier = @"WorkCellIdentifier";
    WorkCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WorkCell alloc] initWithReuseIdentifier:cellIdentifier];
    }
    
    [cell setupWithData:[self.datasource objectAtIndex:index] tapHandler:^(id model){
        Work *work = (Work *)model;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_WORK_DETAIL_VIEW  object:work];
    }];
    
    return cell;
}


#pragma get data

- (void)getWorks
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_WORKS_LIKED] andParam:reqData];
    if (self.baseControler) {
        [self.baseControler.requests addObject:request];
    }

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetWorks:)];
    [request setDidFailSelector:@selector(failGetWorks:)];
    [request startAsynchronous];
}

- (void)finishGetWorks:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"works"];
    
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
        [arr addObject:[[Work alloc] initWithDic:dicData]];
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

- (void)failGetWorks:(ASIHTTPRequest *)request
{
    [self.tableView stopRefreshAnimation];
}

- (void)checkEmpty
{
    
}

@end
