//
//  OrderCell.m
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OrderCell.h"
@interface OrderCell ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *productImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UILabel *countLbl;
@property (nonatomic, strong) UILabel *totalPriceLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        UIView *topLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 1)];
        topLinerView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLinerView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 175)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        UIView *bottomLinerView = [[UIView alloc] initWithFrame:CGRectMake(0, 175, 320, 1)];
        bottomLinerView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomLinerView];
        
        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                        5,
                                                                        250 ,
                                                                          30)];
        self.groupNameLbl.font = [UIFont systemFontOfSize:12];
        self.groupNameLbl.numberOfLines = 1;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [contentView addSubview:self.groupNameLbl];
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl),
                                                                      Y(self.groupNameLbl),
                                                                      50 ,
                                                                      30)];
        self.statusLbl.font = [UIFont systemFontOfSize:12];
        self.statusLbl.numberOfLines = 1;
        self.statusLbl.textAlignment = NSTextAlignmentRight;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self.statusLbl];

        UIView *separaterView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(self.groupNameLbl) +5, 300, 1)];
        separaterView.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [contentView addSubview:separaterView];
        
        self.productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MaxY(separaterView) + 5, 60, 60)];
        [contentView addSubview:self.productImgView];
        self.productImgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.productImgView.layer.borderWidth = 2;
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.productImgView) + 5,
                                                                          Y(self.productImgView),
                                                                          180,
                                                                 HEIGHT(self.productImgView)*2/3)];
        self.nameLbl.font = [UIFont systemFontOfSize:14];
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [contentView addSubview:self.nameLbl];
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                      Y(self.nameLbl),
                                                                      50,
                                                                      20)];
        self.priceLbl.font = [UIFont systemFontOfSize:12];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor lightGrayColor];
        [contentView addSubview:self.priceLbl];
        
        
        self.descLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.productImgView) + 5,
                                                                             MaxY(self.nameLbl),
                                                                             WIDTH(self.nameLbl),
                                                                             HEIGHT(self.productImgView)/3)];
        self.descLbl.font = [UIFont systemFontOfSize:12];
        self.descLbl.numberOfLines = 1;
        self.descLbl.backgroundColor = [UIColor clearColor];
        self.descLbl.textColor = [UIColor lightGrayColor];
        [contentView addSubview:self.descLbl];
        
        
        self.countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                   Y(self.descLbl),
                                                                   50,
                                                                   20)];
        self.countLbl.font = [UIFont systemFontOfSize:14];
        self.countLbl.textAlignment = NSTextAlignmentRight;
        self.countLbl.numberOfLines = 1;
        self.countLbl.backgroundColor = [UIColor clearColor];
        self.countLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [contentView addSubview:self.countLbl];
        
        
        UIView *seperaterView2 = [[UIView alloc] initWithFrame:CGRectMake(X(self.productImgView),
                                                                         MaxY(self.descLbl) + 5,
                                                                          300,1)];
        seperaterView2.backgroundColor = [UIColor colorWithHexString:APP_CONTENT_BG_COLOR];
        [contentView addSubview:seperaterView2];
        
        UILabel *shipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       MaxY(seperaterView2) + 5,
                                                                       240,
                                                                       20)];
        shipLbl.font = [UIFont systemFontOfSize:14];
        shipLbl.backgroundColor = [UIColor clearColor];
        shipLbl.textAlignment = NSTextAlignmentRight;
        shipLbl.textColor = [UIColor blackColor];
        shipLbl.text = @"运费:";
        [contentView addSubview:shipLbl];
        
        UILabel *shipPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(shipLbl),
                                                                       MaxY(seperaterView2) + 5,
                                                                     80,
                                                                     20)];
        shipPriceLbl.font = [UIFont systemFontOfSize:14];
        shipPriceLbl.backgroundColor = [UIColor clearColor];
        shipPriceLbl.textAlignment = NSTextAlignmentLeft;
        shipPriceLbl.textColor = [UIColor blackColor];
        shipPriceLbl.text = @"￥5";
        [contentView addSubview:shipPriceLbl];
        
        FAKIcon *deleteIcon = [FAKIonIcons ios7TrashIconWithSize:20];
        [deleteIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
        UIImage *deleteImg =[deleteIcon imageWithSize:CGSizeMake(20, 20)];
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(20, MaxY(shipLbl), 25, 25);
        [self.deleteBtn setImage:deleteImg forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:self.deleteBtn];
        
        UILabel *totalLbl= [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.deleteBtn),
                                                                     MaxY(shipLbl),
                                                                     195,
                                                                     25)];
        totalLbl.font = [UIFont systemFontOfSize:14];
        totalLbl.backgroundColor = [UIColor clearColor];
        totalLbl.textAlignment = NSTextAlignmentRight;
        totalLbl.textColor = [UIColor blackColor];
        totalLbl.text = @"合计:";
        [contentView addSubview:totalLbl];
        
        self.totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(totalLbl),
                                                                            MaxY(shipLbl),
                                                                            80,
                                                                            25)];
        self.totalPriceLbl.font = [UIFont systemFontOfSize:14];
        self.totalPriceLbl.backgroundColor = [UIColor clearColor];
        self.totalPriceLbl.textAlignment = NSTextAlignmentLeft;
        self.totalPriceLbl.textColor = [UIColor blackColor];
        [contentView addSubview:self.totalPriceLbl];
        
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


- (void)setup:(Order *)order
{
    if(order.status == OrderStatusEnum_UnPaid){
        self.statusLbl.text = @"未付款";
        self.statusLbl.hidden = NO;
        self.statusLbl.textColor = [UIColor redColor];
    }else{
        self.statusLbl.hidden = YES;
    }

    self.groupNameLbl.text = order.group.name;
    self.nameLbl.text = order.product.name;
    self.descLbl.text = order.product.description;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",order.product.price];
    self.countLbl.text = [NSString stringWithFormat:@"%d",order.count];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%.2f",order.price];
    self.deleteBtn.hidden = order.status == OrderStatusEnum_Paid;
}

- (void)deleteOrder
{
    [[[UIAlertView alloc] initWithTitle:@"确定删除订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSLog(@"delete order");
    }
}

@end
