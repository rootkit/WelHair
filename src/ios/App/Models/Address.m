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

#import "Address.h"
#import "CityManager.h"

@implementation Address

- (Address *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"AddressId"] intValue];
        self.userName = [dictionary objectForKey:@"ShippingName"];
        self.phoneNumber = [dictionary objectForKey:@"Mobile"];
        self.detailAddress = [dictionary objectForKey:@"Address"];

        if ([dictionary objectForKey:@"IsDefault"]) {
            self.city = [[CityManager SharedInstance] getCityById:[[dictionary objectForKey:@"City"] intValue]];
        }

        if ([dictionary objectForKey:@"IsDefault"]) {
            self.isDefault = [[dictionary objectForKey:@"IsDefault"] intValue] > 0;
        }
    }

    return self;
}

- (NSDictionary *)dictionaryFromAddress:(Address *)address
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dic setObject:[NSNumber numberWithInt:address.id] forKey:@"AddressId"];

    return dic;
}

@end
