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