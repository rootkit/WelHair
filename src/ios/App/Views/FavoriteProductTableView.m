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


#import "FavoriteProductTableView.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "ProductCell.h"
#import "Product.h"
@interface FavoriteProductTableView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger currentPage;

- (void)getProducts;
@end


@implementation FavoriteProductTableView

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
        self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeProductList]];
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
    return 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ceil(self.datasource.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * cellIdentifier = @"ProductCellIdentifier";
//    ProductCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
//    }
//    CardTapHandler tapHandler = ^(id model){
//        Product *product = (Product *)model;
//        [self pushToDetial:product];
//    };
//    
//    Product *left = [self.datasource objectAtIndex: (2 * indexPath.row)];
//    Product *right = nil;
//    if(2 * (indexPath.row + 1) <= self.datasource.count){
//        right = [self.datasource objectAtIndex: (2 * indexPath.row)];
//    }
//    [cell setupWithLeftData:left rightData:right tapHandler:tapHandler];
//    return cell;

    return nil;
}

- (void)pushToDetial:(Product *)product
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_TO_PRODUCT_DETAIL_VIEW  object:product];
}

- (void)getProducts
{
    
}

@end
