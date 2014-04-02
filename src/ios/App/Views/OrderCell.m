//
//  OrderCell.m
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,329,210)];
        bgImg.image = [UIImage imageNamed:@"OrderListViewControl_CellBg"];
        [self addSubview:bgImg];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
