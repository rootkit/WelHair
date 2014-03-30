//
//  AddressView.m
//  WelHair
//
//  Created by lu larry on 3/30/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "AddressView.h"
@interface AddressView ()

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *detailAddressLbl;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation AddressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;

        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
        
        self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 10, 10, 100, 20)];
        self.phoneLbl.font = [UIFont boldSystemFontOfSize:14];
        self.phoneLbl.backgroundColor = [UIColor clearColor];
        self.phoneLbl.textColor = [UIColor blackColor];
        [self addSubview:self.phoneLbl];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame =  CGRectMake(MaxX(self.phoneLbl)+10, 10, 20, 20);
        self.editBtn.tag = 0;
        [self.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.editBtn];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(MaxX(self.editBtn)+20, 10, 20, 20);
        self.selectBtn.tag = 0;
        [self.selectBtn addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.selectBtn];
        
        self.detailAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, MaxY(self.nameLbl) +10, 240, 30)];
        self.detailAddressLbl.font = [UIFont boldSystemFontOfSize:12];
        self.detailAddressLbl.numberOfLines = 2;
        self.detailAddressLbl.textColor = [UIColor lightGrayColor];
        self.detailAddressLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:self.detailAddressLbl];
    }
    return self;
}

- (void)setup:(Address *)address
     editable:(BOOL)editable
     selectable:(BOOL)selectable
{
    self.address = address;
    self.nameLbl.text = address.userName;
    self.phoneLbl.text = address.phoneNumber;
    self.detailAddressLbl.text = address.detailAddress;
    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"AddressEditBtn"] forState:UIControlStateNormal];
    self.editBtn.hidden = !editable;
    
    self.selectBtn.hidden = !selectable;
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"AddressUnSelectedBtn"] forState:UIControlStateNormal];
}

- (void) setSelected:(BOOL)selected
{
    _selected = selected;
    NSString *selectImgName = selected ? @"AddressSelectedBtn":@"AddressUnSelectedBtn";
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:selectImgName] forState:UIControlStateNormal];
}


- (void)pick:(id)sender
{
    [self.delegate addressView:self didSelected:self.address];
}

- (void)edit:(id)sender
{
    [self.delegate addressView:self didClickEdit:self.address];
}




@end
