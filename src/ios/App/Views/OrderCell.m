//
//  OrderCell.m
//  WelHair
//
//  Created by lu larry on 3/26/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OrderCell.h"
@interface OrderCell ()

@property (nonatomic, strong) UIImageView *productImgView;
@property (nonatomic, strong) UILabel *groupNameLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UILabel *countLbl;
@property (nonatomic, strong) UILabel *totalPriceLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                        5,
                                                                        250 ,
                                                                          30)];
        self.groupNameLbl.font = [UIFont systemFontOfSize:12];
        self.groupNameLbl.numberOfLines = 1;
        self.groupNameLbl.backgroundColor = [UIColor clearColor];
        self.groupNameLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self addSubview:self.groupNameLbl];
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.groupNameLbl),
                                                                      Y(self.groupNameLbl),
                                                                      50 ,
                                                                      30)];
        self.statusLbl.font = [UIFont systemFontOfSize:12];
        self.statusLbl.numberOfLines = 1;
        self.statusLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:self.statusLbl];

        UIView *separaterView = [[UIView alloc] initWithFrame:CGRectMake(15, MaxY(self.groupNameLbl) +5, 300, 1)];
        separaterView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separaterView];
        
        self.productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MaxY(separaterView) + 5, 60, 60)];
        [self addSubview:self.productImgView];
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
        [self addSubview:self.nameLbl];
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                      Y(self.nameLbl),
                                                                      50,
                                                                      20)];
        self.priceLbl.font = [UIFont systemFontOfSize:12];
        self.priceLbl.textAlignment = NSTextAlignmentRight;
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.priceLbl];
        
        
        self.descLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.productImgView) + 5,
                                                                             MaxY(self.nameLbl),
                                                                             WIDTH(self.nameLbl),
                                                                             HEIGHT(self.productImgView)/3)];
        self.descLbl.font = [UIFont systemFontOfSize:12];
        self.descLbl.numberOfLines = 1;
        self.descLbl.backgroundColor = [UIColor clearColor];
        self.descLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.descLbl];
        
        
        self.countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLbl) + 5,
                                                                   Y(self.descLbl),
                                                                   50,
                                                                   20)];
        self.countLbl.font = [UIFont systemFontOfSize:14];
        self.countLbl.textAlignment = NSTextAlignmentRight;
        self.countLbl.numberOfLines = 1;
        self.countLbl.backgroundColor = [UIColor clearColor];
        self.countLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self addSubview:self.countLbl];
        
        
        UIView *seperaterView2 = [[UIView alloc] initWithFrame:CGRectMake(X(self.productImgView),
                                                                         MaxY(self.descLbl) + 5,
                                                                          300,1)];
        seperaterView2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:seperaterView2];
        
        self.totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(X(seperaterView2),
                                                                            MaxY(seperaterView2) + 5,
                                                                            WIDTH(seperaterView2),
                                                                            25)];
        self.totalPriceLbl.font = [UIFont systemFontOfSize:14];
        self.totalPriceLbl.backgroundColor = [UIColor clearColor];
        self.totalPriceLbl.textColor = [UIColor blackColor];
        [self addSubview:self.totalPriceLbl];
        
        UIView *seperaterView3 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          MaxY(self.totalPriceLbl) + 5,
                                                                          320,1)];
        seperaterView3.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:seperaterView3];
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
    self.statusLbl.text = @"未付款";
    self.statusLbl.textColor = [UIColor redColor];
    self.groupNameLbl.text = order.group.name;
    self.nameLbl.text = order.product.name;
    self.descLbl.text = order.product.description;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",order.product.price];
    self.countLbl.text = [NSString stringWithFormat:@"%d",order.count];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%.2f",order.price];
}

@end
