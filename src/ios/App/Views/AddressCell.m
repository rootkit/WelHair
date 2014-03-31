//
//  AppointmentCell.m
//  WelHair
//
//  Created by lu larry on 3/14/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AddressCell.h"
#import "AddressView.h"

@interface AddressCell()<AddressViewDelegate>
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) AddressView *addressView;
@end

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addressView = [[AddressView alloc] initWithFrame:CGRectMake(20, 10, 280, 80)];
        self.addressView.delegate = self;
        self.addressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.addressView];
    }
    return self;
}


- (void)setPicked:(BOOL)picked
{
    [self.addressView setSelected:picked];
}
- (void)setup:(Address *)address;
{
    self.address = address;
    [self.addressView setup:self.address editable:YES selectable:YES];
}

- (void)addressView:(AddressView *)addressView didClickEdit:(Address *)address
{
    [self.delegate addressCell:self didClickEdit:self.address];
}

- (void)addressView:(AddressView *)addressView didSelected:(Address *)address
{
    [self.delegate addressCell:self didSelected:self.address];
}


@end