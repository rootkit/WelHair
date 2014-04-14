//
//  BaiduMapHelper.h
//  WelHair
//
//  Created by lu larry on 3/31/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

typedef void (^LocateCompleteHandler)(City *city);

@interface BaiduMapHelper : NSObject

+(id)SharedInstance;

- (void)locateCityWithCompletion:(LocateCompleteHandler)completion;
@end
