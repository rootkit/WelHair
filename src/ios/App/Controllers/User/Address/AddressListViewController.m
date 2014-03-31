//
//  AddressListViewController.m
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "Address.h"
#import "AddressCell.h"
@interface AddressListViewController ()<UITableViewDataSource, UITableViewDelegate, AddressCellDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AddressListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"新建";
        
    }
    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavItemClick
{
    [self.navigationController pushViewController:[AddAddressViewController new] animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0,
                                      self.topBarOffset,
                                      WIDTH(self.view) ,
                                      [self contentHeightWithNavgationBar:YES withBottomBar:NO] );
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];
    [self.view addSubview:self.tableView];
    
    self.datasource = [NSMutableArray arrayWithArray:[FakeDataHelper getFakeAddressLit]];
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
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"AddressCellIdentifier";
    AddressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if(!self.pickedAddress){
        self.pickedAddress = [FakeDataHelper getFakeDefaultAddress];
    }
    Address *item= [self.datasource objectAtIndex:indexPath.row];
    [cell setup:item];
    if(item == self.pickedAddress){
        [cell setPicked:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didselectAddress:[self.datasource objectAtIndex:indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert.layer setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"editedIndex"];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSNumber *editIndex = (NSNumber *)[alertView.layer valueForKey:@"editedIndex"];
    if(buttonIndex == 1)
    {
        Address *s = [self.datasource objectAtIndex:[editIndex integerValue]];
        [self.datasource removeObject:s];
        [self.tableView reloadData];
    }
}

- (void)addressCell:(AddressCell *)addressCell didClickEdit:(Address *)address
{
    AddAddressViewController *vc = [AddAddressViewController new];
    vc.address = address;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addressCell:(AddressCell *)addressCell didSelected:(Address *)address
{
    [self didselectAddress:address];
}

- (void)didselectAddress:(Address *)address
{
    if(self.pickedAddress){
        [self.delegate didPickAddress:address];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        debugLog(@"sa;ving default address to server");
    }
}

@end
