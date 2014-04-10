//
//  FavoriteGroupTableView.m
//  WelHair
//
//  Created by lu larry on 4/9/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FavoriteStaffTableView.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "StaffCell.h"
#import "Staff.h"
@interface FavoriteStaffTableView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger currentPage;

- (void)getStaffs;
@end


@implementation FavoriteStaffTableView

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
        self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeStaffList]];
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


#pragma tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"StaffCellIdentifier";
    StaffCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StaffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor =  cell.backgroundColor = indexPath.row % 2 == 0?
    [UIColor whiteColor] : [UIColor colorWithHexString:@"f5f6f8"];
    
    Staff *data = [self.datasource objectAtIndex:indexPath.row];
    [cell setup:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_STAFF_DETAIL_VIEW  object:[self.datasource objectAtIndex:indexPath.row]];
}



- (void)getStaffs
{
    
}

@end
