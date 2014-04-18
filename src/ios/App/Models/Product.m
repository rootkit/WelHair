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
#import "Product.h"

@implementation Product

- (Product *)initWithDic:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"GoodsId"] intValue];
        self.name = [dictionary objectForKey:@"Name"];
        self.imgUrlList = [dictionary objectForKey:@"PictureUrl"];
        self.price = [[dictionary objectForKey:@"SellPrice"] floatValue];

        if ([dictionary objectForKey:@"CompanyId"]) {
            self.group = [Group new];
            self.group.id = [[dictionary objectForKey:@"CompanyId"] intValue];
            self.group.name = [dictionary objectForKey:@"CompanyName"];
            self.group.distance = [[dictionary objectForKey:@"CompanyId"] floatValue];
        }

        if ([dictionary objectForKey:@"IsLiked"]) {
            self.isLiked = [[dictionary objectForKey:@"IsLiked"] intValue] == 1;
        }
    }
    
    return self;
}

@end
