//
//  CityListViewController.m
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import "CityListViewController.h"
#import "CityManager.h"
#import "City.h"
#import "BMapKit.h"
@interface CityListViewController ()<BMKSearchDelegate,BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKSearch* _search;
}
@property (nonatomic) int cityId;

@property (nonatomic, strong) UITableViewCell *locationCell;
@property (nonatomic, strong) City *locatedCity;
@property (nonatomic, strong) NSArray *cities;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _search.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cities = [[CityManager SharedInstance] getCityList];
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if(self.enableLocation){
        self.locatedCity = [[CityManager SharedInstance] getLocatedCity];
        self.locationCell = [self getLocaitonCell:self.locatedCity.name];
        _search = [[BMKSearch alloc]init];
        _mapView = [[BMKMapView alloc] init];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
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
        titleLabel.text = section == 0 ? @"定位城市" : @"所有城市";
    }else{
        titleLabel.text = @"所有城市";
    }

    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.enableLocation ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.enableLocation){
        return section == 0 ? 1 : self.cities.count;
    }else{
        return self.cities.count;
    }
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.contentView.backgroundColor =  cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    City *item = (City *)[self.cities objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    if(self.selectedCity.id == item.id){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == self.locationCell && self.locatedCity){
        [self.delegate  didPickCity:self.locatedCity];
    }else{
        self.selectedCity = [self.cities objectAtIndex:indexPath.row];
        [self.delegate  didPickCity:self.selectedCity];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma location delegate

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        _mapView.showsUserLocation = NO;
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        if([_search reverseGeocode:userLocation.coordinate]){
            debugLog(@"reverse geo code success");
        }else{
            debugLog(@"reverse geo code fail");
        }
	}
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        NSString *cityName = result.addressComponent.city;
        cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        City *locatedCity =  [[CityManager SharedInstance] getCityByName:cityName];
        if(locatedCity.id != self.locatedCity.id){
            self.locatedCity = locatedCity;
            [[CityManager SharedInstance] setLocatedCity:self.locatedCity.id];
            self.locationCell = [self getLocaitonCell:self.locatedCity.name];
            [self.tableView reloadData];
        }
	}
}

@end
