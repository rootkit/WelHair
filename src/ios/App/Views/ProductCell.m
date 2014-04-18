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

#import "ProductCell.h"
#import "ProductCardView.h"

@interface ProductCell ()

@property (nonatomic, strong) ProductCardView *cardView;
@property (nonatomic, strong) Product *productData;
@property (nonatomic, strong) CardTapHandler cardTapHandler;

@end

@implementation ProductCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    }

    return self;
}

- (void)setupWithData:(Product *)data
           tapHandler:(CardTapHandler)tapHandler
{
    self.productData = data;
    self.cardTapHandler = tapHandler;
    
    if(!self.cardView){
        self.cardView = [[ProductCardView alloc] initWithFrame:CGRectMake(0, 0, 145, 210)];
        [self addSubview:self.cardView];
        [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)]];
    }
    [self.cardView setupWithData:self.productData];
}

- (void)cardTapped:(id)sender
{
    self.cardTapHandler(self.productData);
}

@end
