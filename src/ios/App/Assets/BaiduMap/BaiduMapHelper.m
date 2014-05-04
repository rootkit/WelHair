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

#import "BaiduMapHelper.h"
#import "BMapKit.h"
#import "CityManager.h"
@implementation BDLocation

@end

@interface BaiduMapHelper ()<BMKSearchDelegate,BMKUserLocationDelegate>
{
    BMKUserLocation *_locate;
    BMKSearch* _search;
    BDLocation *_currentLocation;
    LocateCompleteHandler _locateCityComplete;
    LocateCompleteHandler _locateCoordinateComplete;
    BOOL _isNeedLocateCity;
}
@end
@implementation BaiduMapHelper

- (id)init{
    self = [super init];
    if(self){
        _locate = [[BMKUserLocation alloc] init];
        _locate.delegate = self;
        _search = [[BMKSearch alloc]init];
        _search.delegate = self;
        _currentLocation = [BDLocation new];
    }
    return self;
}

+(id)SharedInstance
{
    static BaiduMapHelper *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BaiduMapHelper alloc] init];
    });
    return sharedInstance;
}

- (void)locateCityWithCompletion:(LocateCompleteHandler)completion
{
    _isNeedLocateCity = YES;
    _locateCityComplete = completion;
    [_locate startUserLocationService];
}

- (void)locateCoordinateWithCompletion:(LocateCompleteHandler)completion
{
    _locateCoordinateComplete = completion;
    if(![_locate isUpdating]){
        [_locate startUserLocationService];
    }
}

- (void)viewDidGetLocatingUser:(CLLocationCoordinate2D)userLoc
{
    _currentLocation.coordinate = userLoc;
    if(_locateCoordinateComplete){
        _locateCoordinateComplete(_currentLocation);
    }

    if(_isNeedLocateCity){
        if([_search reverseGeocode:userLoc]){
            debugLog(@"reverse geo code success");
        }else{
            debugLog(@"reverse geo code fail");
        }
    }
    [_locate stopUserLocationService];
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    _isNeedLocateCity = NO;
	if (error == 0) {
        NSString *cityName = result.addressComponent.city;
        City *locatedCity =  [[CityManager SharedInstance] getCityByName:cityName];
        _currentLocation.locatedCity = locatedCity;
        _locateCityComplete(_currentLocation);
	}
}


- (void)dealloc
{
    _locate.delegate = nil;
    _locate = nil;
    _search.delegate = nil;
    _search = nil;
    _locateCoordinateComplete = nil;
    _locateCityComplete = nil;
    _currentLocation = nil;
}

@end
