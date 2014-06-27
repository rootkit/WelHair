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

#import "AppointmentsViewController.h"
#import "AppointmentNotePictureCell.h"
#import "BrickView.h"
#import "ChatViewController.h"
#import "CircleImageView.h"
#import "MWPhotoBrowser.h"
#import "MyClientDetailViewController.h"
#import "UserManager.h"

#define  DefaultAvatorImage @"AvatarDefault.jpg"
static const float avatorSize = 50;

@interface MyClientDetailViewController () <BrickViewDelegate, BrickViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, strong) AppointmentNote *openedNote;

@property (nonatomic, strong) CircleImageView *avatorImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *appointCountLbl;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) BrickView *tableView;

@end

@implementation MyClientDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg = [leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        FAKIcon *rightIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:NAV_BAR_ICON_SIZE];
        [rightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.rightNavItemImg = [rightIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    if(![self checkLogin]){
        return;
    }

    ChatViewController *vc = [ChatViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.client.user.nickname;

    UIView *headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    headerView_.backgroundColor = [UIColor clearColor];
    headerView_.clipsToBounds = YES;

    UIView *profileIconView_ = [[UIView alloc] initWithFrame:CGRectMake(10, 0, WIDTH(headerView_) - 20, HEIGHT(headerView_))];
    profileIconView_.backgroundColor = [UIColor whiteColor];
    profileIconView_.layer.borderWidth = 1;
    profileIconView_.layer.borderColor = [UIColor colorWithHexString:@"ddd"].CGColor;
    [headerView_ addSubview:profileIconView_];

    [profileIconView_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUsersAppointment)]];

    self.avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 10, avatorSize, avatorSize)];
    self.avatorImgView.image = [UIImage imageNamed:DefaultAvatorImage];
    self.avatorImgView.borderColor = [UIColor whiteColor];
    self.avatorImgView.borderWidth = 0;
    [self.avatorImgView setImageWithURL:self.client.user.avatarUrl];
    [profileIconView_ addSubview:self.avatorImgView];

    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatorImgView) + 10, 15, WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.nameLbl.backgroundColor = [UIColor clearColor];
    self.nameLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
    self.nameLbl.font = [UIFont systemFontOfSize:16];
    self.nameLbl.textAlignment = NSTextAlignmentLeft;
    self.nameLbl.text = self.client.user.nickname;
    [profileIconView_ addSubview:self.nameLbl];


    self.appointCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.nameLbl), MaxY(self.nameLbl), WIDTH(self.view) - 10 - MaxX(self.avatorImgView), 20)];
    self.appointCountLbl.backgroundColor = [UIColor clearColor];
    self.appointCountLbl.textColor = [UIColor colorWithHexString:@"777"];
    self.appointCountLbl.font = [UIFont systemFontOfSize:12];
    self.appointCountLbl.textAlignment = NSTextAlignmentLeft;
    self.appointCountLbl.text = [NSString stringWithFormat:@"累计预约%d次", self.client.appointmentCount];
    [profileIconView_ addSubview:self.appointCountLbl];


    FAKIcon *arrowIcon = [FAKIonIcons ios7ArrowForwardIconWithSize:NAV_BAR_ICON_SIZE];
    [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777"]];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[arrowIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)]];
    arrowImg.frame = CGRectMake(WIDTH(profileIconView_) - NAV_BAR_ICON_SIZE - 10, (HEIGHT(profileIconView_) - NAV_BAR_ICON_SIZE) / 2, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [profileIconView_ addSubview:arrowImg];

    self.tableView = [[BrickView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO]);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.padding = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:self.tableView];

    self.tableView.headerView = headerView_;

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage = 1;
        [weakSelf getAppointmentNotes];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getAppointmentNotes];
    }];
    self.tableView.showsInfiniteScrolling = NO;

    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableView delegate

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 145 + 28;
}

- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 2;
}

- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return self.datasource.count;
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    static NSString * cellIdentifier = @"AppointmentNotePictureCellIdentifier";

    AppointmentNotePictureCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AppointmentNotePictureCell alloc] initWithReuseIdentifier:cellIdentifier];
    }

    [cell setup:[self.datasource objectAtIndex:index] withPictureIndex:0];

    return cell;
}

- (void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index;
{
    self.openedNote = [self.datasource objectAtIndex:index];

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:0];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nc animated:YES completion:Nil];
}

- (void)getAppointmentNotes
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", 1000] forKey:@"pageSize"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_APPOINTMENTS_LIST_BY_USER_AND_STAFF, [UserManager SharedInstance].userLogined.id, self.client.user.id]]
                                                                               andParam:reqData];
    [self.requests addObject:request];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetAppointmentNotes:)];
    [request setDidFailSelector:@selector(failGetAppointmentNotes:)];
    [request startAsynchronous];
}

- (void)finishGetAppointmentNotes:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"appointmentNotes"];

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
        [arr addObject:[[AppointmentNote alloc] initWithDic:dicData]];
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

- (void)failGetAppointmentNotes:(ASIHTTPRequest *)request
{
    [self.tableView stopRefreshAnimation];
}

- (void)checkEmpty
{
    
}

- (void)openUsersAppointment
{
    if(![self checkLogin]){
        return;
    }

    AppointmentsViewController *vc = [AppointmentsViewController new];
    vc.userId = self.client.user.id;
    vc.staffId = [[UserManager SharedInstance] userLogined].id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.openedNote.pictureUrl.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [MWPhoto photoWithURL:[NSURL URLWithString:[self.openedNote.pictureUrl objectAtIndex:index]]];
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[self.openedNote.pictureUrl objectAtIndex:index]]];
    photo.caption = self.openedNote.body;
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
