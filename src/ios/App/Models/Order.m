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
#import "Order.h"
#import "OpitionItem.h"
@implementation Order

- (id)init
{
    self = [super init];
    if(self){
        self.productSelectedSpecs = [NSMutableDictionary dictionary];
        self.count = 1;
        self.status = OrderStatusEnum_UnPaid;
    }
    return self;
}
// check if need pick spec
- (NSString *)unSelectedSpecStr
{
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *dic  in self.product.specList) {
        int specId = [[dic objectForKey:@"SpecId"] intValue];
        if(![self.productSelectedSpecs objectForKey:@(specId)]){
            [str appendFormat:@"%@,",[dic objectForKey:@"Title"]];
            continue;
        }
    }
    if(str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    }
    return str;
}

- (NSString *)selectedSpecStr
{
    NSMutableString *str = [NSMutableString string];
    for (OpitionItem *item in self.productSelectedSpecs.allValues) {
        [str appendFormat:@"%@,",item.title];
    }
    if(str.length > 0){
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    }
    return str;

}
@end
