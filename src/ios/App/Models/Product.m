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

        if ([dictionary objectForKey:@"Company"]) {
            NSDictionary *dicCompany = [dictionary objectForKey:@"Company"];
            self.group = [[Group alloc] initWithDic:dicCompany];
            self.distance = self.group.distance;
        }

        if ([dictionary objectForKey:@"IsLiked"]) {
            self.isLiked = [[dictionary objectForKey:@"IsLiked"] intValue] == 1;
        }

        if ([dictionary objectForKey:@"Attributes"]) {
            self.attrList = [dictionary objectForKey:@"Attributes"];
        }

        if ([dictionary objectForKey:@"Spec"]) {
            self.specList = [dictionary objectForKey:@"Spec"];
        }
    }
    
    return self;
}

@end
