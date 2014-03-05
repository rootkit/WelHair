//
//  SelectOpitions.m
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

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
