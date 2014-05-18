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

#import "OrderUnpaidTableView.h"
#import "OrderCell.h"
#import "Order.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
@interface OrderUnpaidTableView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger currentPage;

- (void)getUnpaidOrders;
@end


@implementation OrderUnpaidTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = self.bounds;
        [self addSubview:self.tableView];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView addPullToRefreshActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        
        [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
        [self.tableView.pullToRefreshView setBorderWidth:2];
        [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
        [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
        self.datasource = nil;//[NSMutableArray arrayWithArray:[FakeDataHelper getFakeOrderList:NO]];
    }
    return self;
}
- (void)insertRowAtTop
{
    int64_t delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView stopRefreshAnimation];
    });
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"OrderCellIdentifier";
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setup:[self.datasource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_UNPAIDORDER_PREVIEW_VIEW object:[self.datasource objectAtIndex:indexPath.row]];
}


- (void)getUnpaidOrders{
    
}


@end
