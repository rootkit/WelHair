//
//  MapPickPointViewController.m
//  WelHair
//
//  Created by lu larry on 3/5/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

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
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
        
        self.rightNavItemTitle = @"删除";
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
    if(self.location){
        [self addAnnotation:self.location.coordinate];
    }else{
        [self locateClick];
    }    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, self.topBarOffset, WIDTH(self.view), HEIGHT(self.view) - self.topBarOffset)];
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) leftNavItemClick
{
    NSArray *pickedPoint = _mapView.annotations;
    CLLocation *pickedLocation;
    if(pickedPoint.count == 1){
        BMKPointAnnotation *item = (BMKPointAnnotation *)pickedPoint[0];
        pickedLocation = [[CLLocation alloc] initWithLatitude:item.coordinate.latitude longitude:item.coordinate.longitude];
    }
    [self.delegate didPickLocation:pickedLocation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightNavItemClick
{
    NSArray *pickedPoint = _mapView.annotations;
    [_mapView removeAnnotations:pickedPoint];
}

- (void)locateClick
{
    //普通态
    debugLog(@"进入普通定位态");
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.zoomLevel = 16;
    _mapView.showsUserLocation = YES;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BMKPointAnnotation *item = (BMKPointAnnotation *)obj;
        item.title = [NSString stringWithFormat:@"经度:%f，纬度:%f",
                      item.coordinate.longitude,
                      item.coordinate.latitude];
    }];
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
    annotationView.draggable = NO;
    
    return annotationView;
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
    [self addAnnotation:coordinate];
}


- (void)addAnnotation:(CLLocationCoordinate2D )coordinate
{
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    
    [_mapView addAnnotation:item];

}

@end
