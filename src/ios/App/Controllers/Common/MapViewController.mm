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

#import "BMapKit.h"
#import "GroupDetailViewController.h"
#import "MapViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end


@interface WHPointAnnotation : BMKPointAnnotation

@property (nonatomic, strong) BaseModel *modelInfo;

@end

@implementation WHPointAnnotation
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end


@interface MapViewController ()<BMKMapViewDelegate,BMKSearchDelegate>
{
    BMKMapView *_mapView;
    BMKSearch* _search;
}
@property (nonatomic, strong) UIButton *locateBtn;
@property (nonatomic, strong) UIButton *aroundBtn;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) BMKMapStatus *currentMapStatus;
@property (nonatomic, strong) NSMutableArray *aroundGroups;
@end

@implementation MapViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Map";
        self.aroundGroups = [NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    if(_mapView.annotations.count == 0){
//        [self locateCurrentGroup];
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float bottomHeight = 49;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - bottomHeight)];
    [self.view addSubview:_mapView];
    _search = [[BMKSearch alloc]init];
    [_mapView setZoomLevel:15];
    _mapView.isSelectedAnnotationViewFront = YES;
    
    
    float topViewHeight = isIOS7 ? kStatusBarHeight + kTopBarHeight : kTopBarHeight;
    UIView *topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), topViewHeight)];
    topNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topNavView];
    
    UIView *topNavbgView = [[UIView alloc] initWithFrame:topNavView.bounds];
    topNavbgView.backgroundColor = [UIColor blackColor];
    topNavbgView.alpha = 0.4;
    [topNavView addSubview:topNavbgView];
    // top left button
    FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
    [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, topViewHeight - 35, NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [topNavView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(260, topViewHeight - 35, 50, NAV_BAR_ICON_SIZE);
    [rightBtn setTitle:@"路线" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topNavView addSubview:rightBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_mapView), WIDTH(self.view), bottomHeight)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    // bottom left button
    self.locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locateBtn.frame = CGRectMake(0, 0, WIDTH(bottomView)/2, bottomHeight);
    [self.locateBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.locateBtn setTitle:@"本店地址" forState:UIControlStateNormal];
    [bottomView addSubview:self.locateBtn];
    
    UIView *bottomLinerView = [[UIView alloc] initWithFrame:CGRectMake(MaxX(self.locateBtn),10, 1,29)];
    bottomLinerView.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:bottomLinerView];
    
    // bottom right button
    self.aroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.aroundBtn.frame = CGRectMake(MaxX(self.locateBtn), 0, WIDTH(bottomView)/2, bottomHeight);
    [self.aroundBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.aroundBtn setTitle:@"周边店铺" forState:UIControlStateNormal];
    [bottomView addSubview:self.aroundBtn];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_mapView.annotations.count == 0){
        [self locateCurrentGroup];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.pt = self.currentLocation;
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.pt = self.modelInfo.coordinate;
    [_search drivingSearch:nil startNode:start endCity:nil endNode:end];
}

- (void)bottomButtonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn == self.locateBtn){
        [self locateCurrentGroup];
    }else{
        [self aroundClick];
    }
}

- (void)locateCurrentGroup
{
    [self.aroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.locateBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];

    NSArray *annotations = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:annotations];
    NSArray *overlayers = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overlayers];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    WHPointAnnotation* item = [[WHPointAnnotation alloc]init];
    item.coordinate = self.modelInfo.coordinate;
    item.title = self.modelInfo.name;
    item.modelInfo = self.modelInfo;
    [_mapView addAnnotation:item];
    //将第一个点的坐标移到屏幕中央
    _mapView.centerCoordinate = item.coordinate;
    self.currentMapStatus = [_mapView getMapStatus];
}

- (void)aroundClick
{
    [self.locateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.aroundBtn setTitleColor:[UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR] forState:UIControlStateNormal];
    // 清楚屏幕中所有的annotation
    
    [self getAroundGroups:self.currentLocation];
}

- (void)getAroundGroups:(CLLocationCoordinate2D )coordinate
{
    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:API_COMPANIES_NEARBY]
                                                     andCoordinate:coordinate andParam:nil];
    [self.requests addObject:request];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishgetAroundGroups:)];
    [request setDidFailSelector:@selector(failgetAroundGroups:)];
    [request startAsynchronous];
}

- (void)finishgetAroundGroups:(ASIHTTPRequest *)request
{
    NSArray *rst = [Util objectFromJson:request.responseString];
    if (request.responseStatusCode == 200 && rst.count > 0) {
        
        for (NSDictionary *dic in rst) {
            Group *g = [[Group alloc] initWithDic:dic];
            if(![self hasGroupWithSameCoordinate:g.coordinate]){
                WHPointAnnotation* item = [[WHPointAnnotation alloc]init];
                item.coordinate = g.coordinate;
                item.title = g.name;
                item.modelInfo = g;
                [_mapView addAnnotation:item];
                [self.aroundGroups addObject:g];
            }
        }
        return;
    }
}

- (void)failgetAroundGroups:(ASIHTTPRequest *)request
{
    
}


/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"annotationView";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
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
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    debugLog(@"didAddAnnotationViews");
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[WHPointAnnotation class]]){
        WHPointAnnotation *anno = (WHPointAnnotation *)view.annotation;
        if([anno.modelInfo isKindOfClass:[Group class]]){
            GroupDetailViewController *groupVc = [GroupDetailViewController new];
            groupVc.group = (Group *)anno.modelInfo;
            [self.navigationController pushViewController:groupVc animated:YES];
        }
    }
}

#pragma mark -
#pragma mark implement BMKSearchDelegate

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:(NSUInteger)i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
		}
	} else if (error == BMKErrorRouteAddr){
        debugLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	debugLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
//        self.currentLocation = userLocation.location.coordinate;
		debugLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        self.currentLocation = userLocation.coordinate;
        _mapView.showsUserLocation = NO;
	}
}

- (void)onGetDrivingRouteResult:(BMKSearch*)searcher result:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}

#pragma mark drive line

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}


//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"mapview did dragged %f,%f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
//
//}
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    if([self.locateBtn titleColorForState:UIControlStateNormal] == [UIColor blackColor]){
        BMKMapStatus *s =  [mapView getMapStatus];
        if(s.fLevel <= 15){
            [self getAroundGroups:mapView.centerCoordinate];
            self.currentMapStatus = s;
        }
    }
}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
//- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
//{
//    debugLog(@"onLongClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
//    
//    BMKPointAnnotation* item1 = [[BMKPointAnnotation alloc]init];
//    item1.coordinate = coordinate;
//    item1.title = @"选中坐标";
//    [_mapView addAnnotation:item1];
//    
//}

- (BOOL)hasGroupWithSameCoordinate:(CLLocationCoordinate2D )coordinate
{
    for (Group *g in self.aroundGroups) {
        if(g.coordinate.latitude == coordinate.latitude && g.coordinate.longitude == coordinate.longitude){
            return YES;
        }
    }
    return NO;
}

@end
