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


@interface BaiduMapHelper ()<BMKSearchDelegate,BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKSearch* _search;
    LocateCompleteHandler _locateComplete;
}
@end
@implementation BaiduMapHelper

- (id)init{
    self = [super init];
    if(self){
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
        _search = [[BMKSearch alloc]init];
        _search.delegate = self;
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
    _locateComplete = completion;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        if([_search reverseGeocode:userLocation.coordinate]){
            debugLog(@"reverse geo code success");
        }else{
            debugLog(@"reverse geo code fail");
        }
        _mapView.showsUserLocation = NO;
	}
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        NSString *cityName = result.addressComponent.city;
        City *locatedCity =  [[CityManager SharedInstance] getCityByName:cityName];
        _locateComplete(locatedCity);
        _mapView.delegate = nil;
        _search.delegate = nil;
	}
}


@end
