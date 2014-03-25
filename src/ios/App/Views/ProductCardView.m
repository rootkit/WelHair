//
//  ProductCardView.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductCardView.h"
#import "Product.h"
#import "UIImageView+WebCache.h"

@interface ProductCardView()

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *groupLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *distanceLbl;

@end
@implementation ProductCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float width = WIDTH(self);

        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width -2, width-2)];
        [self addSubview:self.imgView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, MaxY(self.imgView) + 5, width ,15)];
        self.nameLbl.font = [UIFont systemFontOfSize:14];
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
        
        self.groupLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, MaxY(self.nameLbl) + 3, width ,15)];
        self.groupLbl.font = [UIFont systemFontOfSize:12];
        self.groupLbl.backgroundColor = [UIColor clearColor];
        self.groupLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.groupLbl];
        
        self.priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, MaxY(self.groupLbl) +3, width *1/2 ,20)];
        self.priceLbl.font = [UIFont systemFontOfSize:16];
        self.priceLbl.backgroundColor = [UIColor clearColor];
        self.priceLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self addSubview:self.priceLbl];
        
        float locationIconSize = 15;
        FAKIcon *locationIcon = [FAKIonIcons locationIconWithSize:locationIconSize];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7bcc2"]];
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.priceLbl)+10, Y(self.priceLbl),locationIconSize, locationIconSize)];
        locationImg.image = [locationIcon imageWithSize:CGSizeMake(locationIconSize,locationIconSize)];
        [self addSubview:locationImg];
        
        self.distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(locationImg), Y(locationImg), 30,20)];
        self.distanceLbl.font = [UIFont systemFontOfSize:10];
        self.distanceLbl.textAlignment = NSTextAlignmentRight;
        self.distanceLbl.backgroundColor = [UIColor clearColor];
        self.distanceLbl.textColor = [UIColor colorWithHexString:APP_NAVIGATIONBAR_COLOR];
        [self addSubview:self.distanceLbl];
        [self drawBottomShadowOffset:1 opacity:1];
    }
    return self;
}

//get calculated height
- (void) setupWithData:(Product *)productData
{
    self.product = productData;
    [self.imgView setImageWithURL:[NSURL URLWithString:self.product.imgUrlList[0]]];
    self.nameLbl.text = productData.name;
    self.groupLbl.text = productData.group.name;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",productData.price];
    self.distanceLbl.text = [NSString stringWithFormat:@"%.0f千米 ",productData.distance];
}

@end