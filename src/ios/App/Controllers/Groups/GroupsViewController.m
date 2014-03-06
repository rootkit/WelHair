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

#import "GroupsViewController.h"
#import "GroupDetailViewController.h"
#import "WorkCell.h"

@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"GroupsViewController.Title", nil);
    }
    return self;
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeHairWorkImgs]];
//    __weak GroupsViewController *weakSelf = self;
    // setup pull-to-refresh
//    [self.tableView addPullToRefreshActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
//    
//    // setup infinite scrolling
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf insertRowAtBottom];
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(CGRectEqualToRect(self.tableView.frame, CGRectZero)){
        self.tableView.frame = CGRectMake(0,
                                          self.topBarOffset,
                                          WIDTH(self.view),
                                          HEIGHT(self.view)- self.topBarOffset - self.bottomBarOffset);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertRowAtTop {
//    __weak GroupsViewController *weakSelf = self;
//    
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [weakSelf.tableView.pullToRefreshView stopIndicatorAnimation];
//    });
//}
//
//
//- (void)insertRowAtBottom {
//    __weak GroupsViewController *weakSelf = self;
//    
//    int64_t delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.datasource addObjectsFromArray:[FakeDataHelper getFakeHairWorkImgs]];
//        [self.tableView reloadData];
//        [weakSelf.tableView.infiniteScrollingView stopAnimating];
//    });
//}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (WIDTH(self.view) - 20)/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ceil(self.datasource.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"WorkCellIdentifier";
    WorkCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CardTapHandler tapHandler = ^(Work *work){
        [self pushToWorkDetail];
    };
    if((indexPath.row + 1) * 2 <= self.datasource.count){
        [cell setupWithLeftData:[self.datasource objectAtIndex:indexPath.row]
                      rightData:[self.datasource objectAtIndex:indexPath.row + 1]
                     tapHandler:tapHandler];
    }else{
        [cell setupWithLeftData:[self.datasource objectAtIndex:indexPath.row]
                      rightData:nil
                     tapHandler:tapHandler];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)pushToWorkDetail
{
    GroupDetailViewController *groupVc = [[GroupDetailViewController alloc] init];;
    groupVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVc animated:YES];
}


@end
