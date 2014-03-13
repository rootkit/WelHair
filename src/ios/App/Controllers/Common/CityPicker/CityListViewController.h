//
//  CityListViewController.h
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CityPickViewDelegate

- (void) didPickCity:(NSString *)cityName cityId:(int)cityId;

@end

@interface CityListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *selectedCity;

@property (nonatomic, strong) id<CityPickViewDelegate> delegate;


@end
