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

#import "Order.h"
#import "OrderCell.h"
#import "OrderUnpaidTableView.h"
#import "UserManager.h"

@interface OrderUnpaidTableView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) NSInteger currentPage;

@end


@implementation OrderUnpaidTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = self.bounds;
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];

        __weak typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshActionHandler:^{
            weakSelf.currentPage = 1;
            [weakSelf getOrders];
        }];

        [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
        [self.tableView.pullToRefreshView setBorderWidth:2];
        [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
        [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

        [self.tableView addInfiniteScrollingWithActionHandler:^{
            weakSelf.currentPage += 1;
            [weakSelf getOrders];
        }];
        self.tableView.showsInfiniteScrolling = NO;

        [self.tableView triggerPullToRefresh];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerTablePullToRefresh) name:NOTIFICATION_REFRESH_ORDERLIST object:nil];
    }

    return self;
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"OrderCellIdentifier";
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.baseController = self.baseController;
    [cell setup:[self.datasource objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_UNPAIDORDER_PREVIEW_VIEW object:[self.datasource objectAtIndex:indexPath.row]];
}

#pragma mark Order Search API

- (void)getOrders
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];
    [reqData setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"status"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_ORDER_LIST_BY_USER, [UserManager SharedInstance].userLogined.id]]
                                                          andParam:reqData];

    if (self.baseController) {
        [self.baseController.requests addObject:request];
    }

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetOrders:)];
    [request setDidFailSelector:@selector(failGetOrders:)];
    [request startAsynchronous];
}

- (void)finishGetOrders:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"orders"];

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
        [arr addObject:dicData];
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

- (void)failGetOrders:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

- (void)triggerTablePullToRefresh
{
    [self.tableView triggerPullToRefresh];
}

@end
