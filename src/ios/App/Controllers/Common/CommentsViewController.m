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
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      HEIGHT(self.view) - self.topBarOffset);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
            [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    [self.view addSubview:self.tableView];
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeCommentList]];
    
}

- (void)insertRowAtTop
{
    int64_t delayInSeconds = 1.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView stopRefreshAnimation];
    });
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


@end
