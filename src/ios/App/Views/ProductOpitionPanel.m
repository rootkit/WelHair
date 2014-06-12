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

#import "CircleImageView.h"
#import "OpitionButton.h"
#import "ProductOpitionPanel.h"

@interface ProductOpitionPanel ()
{
    Order *_order;
    SelectOpition *opition;
    cancelSelection _cancelHandler;
    submitSelection _submitHandler;

    UILabel *titleLbl;
    
    UIScrollView *scrollView;
    
    UIImageView *avatorImgView;
    UILabel *nameLbl;
    UILabel *priceLbl;
    UILabel *countLbl;
    UILabel *bottomPriceLbl;
}
@end
@implementation ProductOpitionPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float topHeight = 100;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   WIDTH(self),
                                                                   topHeight)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        UIView *linerView = [[ UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(topView) -1, WIDTH(topView), 1)];
        linerView.backgroundColor = [UIColor lightGrayColor];
        [topView addSubview:linerView];
        
        
        avatorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        avatorImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        avatorImgView.layer.borderWidth = 1;
        [topView addSubview:avatorImgView];
        
        nameLbl= [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, Y(avatorImgView), 250, 30)];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor blackColor];
        nameLbl.font = [UIFont boldSystemFontOfSize:14];
        nameLbl.textAlignment = NSTextAlignmentLeft;;
        [topView addSubview:nameLbl];
        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, MaxY(nameLbl), 100, 30)];
        priceLbl.backgroundColor = [UIColor clearColor];
        priceLbl.textColor = [UIColor redColor];
        priceLbl.font = [UIFont systemFontOfSize:12];
        priceLbl.textAlignment = NSTextAlignmentLeft;;
        [topView addSubview:priceLbl];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(MaxX(topView) - 50,
                                     10,
                                     40,
                                     40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:cancelBtn];
        
        float bottomHeight = kBottomBarHeight;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      HEIGHT(self) - bottomHeight,
                                                                      WIDTH(self),
                                                                      bottomHeight)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UIButton *btnDecrese = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDecrese.frame = CGRectMake(10, 10, 30, 30);
        [btnDecrese addTarget:self action:@selector(countDownClick) forControlEvents:UIControlEventTouchDown];
        [btnDecrese setBackgroundImage:[UIImage imageNamed:@"CountDownBtn"] forState:UIControlStateNormal];
        [bottomView addSubview:btnDecrese];
        
        countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnDecrese) + 10,
                                                                          Y(btnDecrese),
                                                                          40,
                                                                           HEIGHT(btnDecrese))];
        countLbl.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
        countLbl.layer.borderWidth = 1;
        countLbl.layer.cornerRadius = 2;
        countLbl.font = [UIFont systemFontOfSize:14];
        countLbl.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:countLbl];
        
        UIButton *btnIncrease = [UIButton buttonWithType:UIButtonTypeCustom];
        btnIncrease.frame = CGRectMake(MaxX(countLbl)  + 10, Y(btnDecrese), 30, 30);
        [btnIncrease addTarget:self action:@selector(countUpClick) forControlEvents:UIControlEventTouchDown];
        [btnIncrease setBackgroundImage:[UIImage imageNamed:@"CountUpBtn"] forState:UIControlStateNormal];
        [bottomView addSubview:btnIncrease];

        bottomPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnIncrease)+5,
                                                                   Y(btnDecrese),
                                                                   60,
                                                                   HEIGHT(btnDecrese))];;
        bottomPriceLbl.font = [UIFont systemFontOfSize:12];
        bottomPriceLbl.textAlignment = NSTextAlignmentCenter;
        bottomPriceLbl.textColor = [UIColor redColor];
        [bottomView addSubview:bottomPriceLbl];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(220, 10, 80, 30);
        [orderBtn setTitle:@"下单" forState:UIControlStateNormal];
        orderBtn.layer.borderWidth = 1;
        orderBtn.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
        orderBtn.layer.cornerRadius = 2;

        [orderBtn setBackgroundColor:[UIColor colorWithHexString:@"e43a3d"]];
        [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchDown];
        [bottomView addSubview:orderBtn];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MaxY(topView), WIDTH(self), HEIGHT(self) - bottomHeight - HEIGHT(topView))];
        scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView) * 2);
        scrollView.backgroundColor = [UIColor colorWithHexString:@"EEE"];
        [self addSubview:scrollView];
    }

    return self;
}

- (void)countDownClick
{
    if(_order.count > 1){
        _order.count--;
        countLbl.text = [NSString stringWithFormat:@"%d", _order.count];
        _order.price =  _order.singleProductPrice  * _order.count;
        bottomPriceLbl.text = [NSString stringWithFormat:@"￥%.2f",_order.price];
    }
}

- (void)countUpClick
{
    _order.count++;
    countLbl.text = [NSString stringWithFormat:@"%d", _order.count];
    _order.price =  _order.singleProductPrice  * _order.count;
    bottomPriceLbl.text = [NSString stringWithFormat:@"￥%.2f",_order.price];
}

- (void)orderClick
{
    NSString *unSelectedSpecStr = [_order unSelectedSpecStr];
    if(unSelectedSpecStr.length == 0){
        _submitHandler(opition);
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请选择%@",unSelectedSpecStr] duration:1];
    }
}

- (void)cancelClick
{
    _cancelHandler();
}

- (void)setupTitle:(NSString *)title
          opitions:(SelectOpition *)selectOptioin
             order:(Order *)order
            cancel:(cancelSelection)cancelHandler
            submit:(submitSelection)submitHandler
{
    _order = order;

    if (_order.product.imgUrlList.count > 0) {
        [avatorImgView setImageWithURL:[NSURL URLWithString:_order.product.imgUrlList[0]]];
    }

    nameLbl.text = _order.product.name;

    titleLbl.text = title;

    _cancelHandler = cancelHandler;
    _submitHandler = submitHandler;
    
    opition = selectOptioin;
    [self fillControls];
}

- (void)fillControls
{
    float offsetY =0 ; // 上一个cate的offsetY];
    for (OpitionCategory *category in opition.opitionCateogries) {
        offsetY = [self fillCategory:category withOffsetY:offsetY];
    }
    countLbl.text = [NSString stringWithFormat:@"%d", _order.count == 0 ? 1 : _order.count];
    bottomPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", _order.price];
    scrollView.contentSize = CGSizeMake(WIDTH(self), offsetY + 10);
}

- (float)fillCategory:(OpitionCategory *)category
          withOffsetY:(float)offsetY
{
    int fontSize = 14;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    float categoryMargin = 10;
    float contentMaxWidth = WIDTH(self) - 2*categoryMargin ;
    
    
    CGSize cateTitleSsize = [category.title sizeWithFont:font
                                       constrainedToSize:CGSizeMake(contentMaxWidth - 2 *categoryMargin, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *cateTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(categoryMargin,
                                                                      offsetY + categoryMargin,
                                                                      contentMaxWidth  ,
                                                                      cateTitleSsize.height + categoryMargin)];
    cateTitleLbl.text = category.title;
    cateTitleLbl.font = [UIFont systemFontOfSize:16];
    cateTitleLbl.textAlignment = TextAlignmentLeft;
    cateTitleLbl.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:cateTitleLbl];
    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(categoryMargin, MaxY(cateTitleLbl), contentMaxWidth, 1)];
    liner.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:liner];
    offsetY = MaxY(liner);
    int selectedOptionId = ((OpitionItem *)[_order.productSelectedSpecs objectForKey:@(category.id)]).id;
    for (OpitionItem *item in category.opitionItems) {
        CGSize itemTitleSsize = [item.title sizeWithFont:font
                                       constrainedToSize:CGSizeMake(contentMaxWidth - 2*categoryMargin , CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
        OpitionButton *opitionBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(2 * categoryMargin,
                                                                                    offsetY + categoryMargin,
                                                                                    contentMaxWidth - 2*categoryMargin,
                                                                                    itemTitleSsize.height + 2*categoryMargin)];
        [opitionBtn setTitle:item.title forState:UIControlStateNormal];
        opitionBtn.opitionItem = item;
        opitionBtn.groupName = category.title;
        opitionBtn.tag = item.id;
        [opitionBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [scrollView addSubview:opitionBtn];
        opitionBtn.choosen = item.id == selectedOptionId;
        offsetY = MaxY(opitionBtn);
    }
    return offsetY;
}

- (void)itemClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    btn.choosen = YES;

    OpitionItem *item = btn.opitionItem;
    [_order.productSelectedSpecs setObject:item forKey:@(item.categoryId)];

    NSDictionary *productMatched = nil;

    NSArray *productsList = _order.product.productList;
    for (NSDictionary *prod in productsList) {
        int matched = 0;
        NSArray *prodSpecList = [prod objectForKey:@"Spec"];
        for (NSDictionary *prodSpec in prodSpecList) {
            for (OpitionItem *itm in [_order.productSelectedSpecs allValues]) {
                if (itm.id == [[prodSpec objectForKey:@"Id"] intValue] && [itm.title isEqualToString:[prodSpec objectForKey:@"Value"]]) {
                    matched++;
                }
            }
        }

        if (matched == prodSpecList.count) {
            productMatched = prod;
        }
    }

    if (productMatched) {
        _order.productId = [[productMatched objectForKey:@"ProductId"] intValue];
        _order.singleProductPrice = [[productMatched objectForKey:@"Price"] floatValue];
        _order.count = [countLbl.text floatValue];
        _order.price = _order.singleProductPrice  * _order.count;

        priceLbl.text = [NSString stringWithFormat:@"￥%.2f", _order.singleProductPrice];
        bottomPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", _order.price];
    } else {
        _order.productId = 0;
        _order.singleProductPrice = 0;
        _order.count = [countLbl.text floatValue];
        _order.price = _order.singleProductPrice  * _order.count;

        priceLbl.text = [NSString stringWithFormat:@"￥%.2f", _order.singleProductPrice];
        bottomPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", _order.price];
    }
}


@end
