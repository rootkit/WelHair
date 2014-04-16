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

#import "SelectOpition.h"

@implementation SelectOpition


- (NSArray *)unselectedCategory
{
    NSMutableArray *array = [NSMutableArray array];
    for (OpitionCategory *cate in self.opitionCateogries) {
        BOOL found = NO;
        for (OpitionItem *item in self.selectedValues) {
            if(cate.id == item.categoryId){
                found = YES;
                break;
            }
        }
        if(!found){
            [array addObject:cate.title];
        }
    }
    return array;
}
@end
