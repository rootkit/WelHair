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
#import "MapPickerViewController.h"
#import "BMapKit.h"


@interface MapPickViewController ()<BMKMapViewDelegate,BMKSearchDelegate>
{
    BMKMapView *_mapView;
    
}
@end

@implementation MapPickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"长按取坐标点";
        self.leftNavItemTitle = @"确定";
        
        self.rightNavItemTitle = @"取消";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    if(self.location.coordinate.latitude >0){
        [_mapView setCenterCoordinate:self.location.coordinate animated:YES];
        [self addAnnotation:self.location.coordinate setCenter:YES];
    }else{
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(36.670266,117.149292) animated:YES];
        [self locateClick];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _mapView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    _mapView.zoomLevel = 16;
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) leftNavItemClick
{
    [self didPickCoordinate];
}

- (void)didPickCoordinate
{
    NSArray *pickedPoint = _mapView.annotations;
    CLLocation *pickedLocation;
    if(pickedPoint.count == 1){
        BMKPointAnnotation *item = (BMKPointAnnotation *)pickedPoint[0];
        pickedLocation = [[CLLocation alloc] initWithLatitude:item.coordinate.latitude longitude:item.coordinate.longitude];
    }
    if(pickedLocation.coordinate.latitude == 0){
        pickedLocation = nil;
    }
    [self.delegate didPickLocation:pickedLocation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locateClick
{
    //普通态
    debugLog(@"进入普通定位态");
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"mapview did update loation %f, %f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
}


- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"PickPoint";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        annotationView.draggable = YES;
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
//    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    __weak typeof(self) selfDelegate = self;
    [mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BMKPointAnnotation *item = (BMKPointAnnotation *)obj;
        item.title = [NSString stringWithFormat:@"%f,%f",
                      item.coordinate.longitude,
                      item.coordinate.latitude];
        selfDelegate.title = item.title;

    }];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    [self didPickCoordinate];
}
/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray *annotationMArray = [[NSArray arrayWithArray:mapView.annotations] mutableCopy];
    
    [mapView removeAnnotations:annotationMArray];
    [self addAnnotation:coordinate setCenter:NO];
}



- (void)addAnnotation:(CLLocationCoordinate2D )coordinate
            setCenter:(BOOL)center
{
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    item.title = [NSString stringWithFormat:@"%f,%f",
                  item.coordinate.longitude,
                  item.coordinate.latitude];
    [_mapView addAnnotation:item];
    self.title = item.title;
}

@end
