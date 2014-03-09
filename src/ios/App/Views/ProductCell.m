//
//  ProductCell.m
//  WelHair
//
//  Created by lu larry on 3/8/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductCell.h"
#import "ProductCardView.h"

@interface ProductCell ()
@property (nonatomic, strong) ProductCardView *leftCardView;
@property (nonatomic, strong) ProductCardView *rightCardView;
@property (nonatomic, strong) Product *leftProductData;
@property (nonatomic, strong) Product *rightproductData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end
@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithLeftData:(Product *)leftData
                rightData:(Product *)rightData
               tapHandler:(CardTapHandler)tapHandler
{
    self.leftProductData = leftData;
    self.rightproductData = rightData;
    self.cardTapHandler = tapHandler;
    
    if(!self.leftCardView){
        self.leftCardView = [[ProductCardView alloc] initWithFrame:CGRectMake(10, 5, 140, 200)];
        [self addSubview:self.leftCardView];
        self.leftCardView.tag = 0;
        [self.leftCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.leftCardView setupWithData:leftData];
    
    if(!self.rightCardView){
        self.rightCardView = [[ProductCardView alloc] initWithFrame:CGRectMake(MaxX(self.leftCardView) + 20, 5, 140, 200)];
        [self addSubview:self.rightCardView];
        self.rightCardView.tag = 1;
        [self.rightCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.rightCardView setupWithData:rightData];
}

- (void)cardTapped:(id)sender
{
    UITapGestureRecognizer *tapView = (UITapGestureRecognizer *)sender;
    UIView *cardView = tapView.view;
    Product *product = cardView.tag == 0 ? self.leftProductData : self.rightproductData;
    self.cardTapHandler(product);
}

@end
