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


#import "CityListViewController.h"
#import "CityManager.h"
#import "City.h"
#import "BMapKit.h"
@interface CityListViewController ()

@property (nonatomic) int cityId;
@property (nonatomic, strong) UITableViewCell *locationCell;
@property (nonatomic, strong) City *locatedCity;
@property (nonatomic, strong) NSDictionary *cities;
@property (nonatomic, strong) NSArray *cityKeys;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"CityListViewController.Title", nil);
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    }
    return self;
}

- (void)leftNavItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cities = [[CityManager SharedInstance] getCityList];
    
    id sortKey = ^(NSString * key1, NSString * key2){
        return [key1 compare:key2];
    };
    self.cityKeys =[self.cities.allKeys sortedArrayUsingComparator:sortKey];
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), [self contentHeightWithNavgationBar:YES withBottomBar:NO])];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if(self.enableLocation){
        self.locatedCity = [[CityManager SharedInstance] getLocatedCity];
        self.locationCell = [self getLocaitonCell:self.locatedCity.name];
        __weak CityListViewController *selfDelegate = self;
        [[BaiduMapHelper SharedInstance] locateCityWithCompletion:^(BDLocation *location){
            if(self.locatedCity.id != location.locatedCity.id){
                [[CityManager SharedInstance] setLocatedCity:location.locatedCity.id];
                self.locatedCity = location.locatedCity;
                self.locationCell = [self getLocaitonCell:self.locatedCity.name];
                [selfDelegate.tableView reloadData];
            }
        }];
    }
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"dadcd7"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    if(self.enableLocation){
        if(section == 0){
            titleLabel.text =  @"定位城市";
        }else{
            titleLabel.text = [self.cityKeys objectAtIndex:section -1];
        }
    }else{
        titleLabel.text = [self.cityKeys objectAtIndex:section];
    }

    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.enableLocation){
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.cityKeys];
        [array insertObject:@"#" atIndex:0];
        return array;
    }else{
        return self.cityKeys;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.enableLocation ? self.cityKeys.count + 1 : self.cityKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.enableLocation && section == 0){
            return 1;
    }
    return [self getSectionDatasource:section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.enableLocation){
        if(indexPath.section == 0){
            cell = self.locationCell;
        }else{
            cell = [self getCityCell:tableView indexPath:indexPath];
        }
    }else{
        cell = [self getCityCell:tableView indexPath:indexPath];
    }
    return cell;
}

- (UITableViewCell *)getLocaitonCell:(NSString *)cityName
{
    self.locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    self.locationCell.contentView.backgroundColor =  self.locationCell.backgroundColor = [UIColor clearColor];
    self.locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.locationCell.accessoryType = UITableViewCellAccessoryNone;
    [self.locationCell.textLabel setTextColor:[UIColor blackColor]];
    if(cityName.length > 0){
        self.locationCell.textLabel.text = cityName;
        [self.locationCell.textLabel setTextColor:[UIColor blackColor]];
        self.locationCell.textLabel.font = [UIFont systemFontOfSize:18];
        
    }else{
        UIActivityIndicatorView *activity = [UIActivityIndicatorView new];
        activity.frame = CGRectMake(10, 10, 20, 20);
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activity startAnimating];
        [self.locationCell.contentView addSubview:activity];
    }
   
    return self.locationCell;
}

- (UITableViewCell *)getCityCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    City *item = [[self getSectionDatasource:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    if(self.selectedCity.id == item.id){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == self.locationCell && self.locatedCity){
        [self.delegate  didPickCity:self.locatedCity];
    }else{
        self.selectedCity = [[self getSectionDatasource:indexPath.section] objectAtIndex:indexPath.row];
        [self.delegate  didPickCity:self.selectedCity];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSArray *)getSectionDatasource:(int)section{
    int keyIndex = self.enableLocation ?  section - 1: section;
    return  [self.cities objectForKey:[self.cityKeys objectAtIndex:keyIndex]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
