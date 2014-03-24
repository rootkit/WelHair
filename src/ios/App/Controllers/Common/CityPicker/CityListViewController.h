//
//  CityListViewController.h
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "City.h"
@protocol CityPickViewDelegate

- (void) didPickCity:(City *)city;

@end

@interface CityListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) BOOL enableLocation;

@property (nonatomic, strong) City *selectedCity;

@property (nonatomic, strong) id<CityPickViewDelegate> delegate;


@end
