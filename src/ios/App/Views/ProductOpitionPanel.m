//
//  OpitionSelectPanel.m
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ProductOpitionPanel.h"
#import "OpitionButton.h"

#import "CircleImageView.h"
#import "UIImageView+WebCache.h"
@interface ProductOpitionPanel ()
{
    Product *_product;
    SelectOpition *opition;
    cancelSelection _cancelHandler;
    submitSelection _submitHandler;

    UILabel *titleLbl;
    
    UIScrollView *scrollView;
    
    CircleImageView *avatorImgView;
    UILabel *nameLbl;
    UILabel *priceLbl;
    UILabel *countLbl;
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
        
        
        avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        avatorImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        avatorImgView.layer.borderWidth = 1;
        [avatorImgView setImageWithURL:[NSURL URLWithString:@"http://4.xiustatic.com/upload/goods20111107/65002396/650023960001/g1_600_600.1339481667492.jpg"]];
        [topView addSubview:avatorImgView];
        
        nameLbl= [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, Y(avatorImgView), 100, 30)];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor blackColor];
        nameLbl.font = [UIFont boldSystemFontOfSize:14];
        nameLbl.text = @"海飞丝";
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
        
        float bottomHeight = 40;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      HEIGHT(self) - bottomHeight,
                                                                      WIDTH(self),
                                                                      40)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UIButton *btnDecrese = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDecrese.frame = CGRectMake(20, 10, 20, 20);
        [btnDecrese addTarget:self action:@selector(countDownClick) forControlEvents:UIControlEventTouchDown];
        [btnDecrese setBackgroundImage:[UIImage imageNamed:@"CountDownBtn"] forState:UIControlStateNormal];
        [bottomView addSubview:btnDecrese];
        
        countLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(btnDecrese) + 10,
                                                                          Y(btnDecrese),
                                                                          40  ,
                                                                           HEIGHT(btnDecrese))];
        countLbl.layer.borderColor = [[UIColor colorWithHexString:APP_CONTENT_BG_COLOR] CGColor];
        countLbl.layer.borderWidth = 1;
        countLbl.layer.cornerRadius = 2;
        countLbl.font = [UIFont systemFontOfSize:14];
        countLbl.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:countLbl];
        
        UIButton *btnIncrease = [UIButton buttonWithType:UIButtonTypeCustom];
        btnIncrease.frame = CGRectMake(MaxX(countLbl)  + 10, 10, 20, 20);
        [btnIncrease addTarget:self action:@selector(countUpClick) forControlEvents:UIControlEventTouchDown];
        [btnIncrease setBackgroundImage:[UIImage imageNamed:@"CountUpBtn"] forState:UIControlStateNormal];
        [bottomView addSubview:btnIncrease];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(220, 5, 80, 30);
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
    if(_product.count > 1){
        _product.count--;
        countLbl.text = [NSString stringWithFormat:@"%d", _product.count];
    }
}

- (void)countUpClick
{
    _product.count++;
    countLbl.text = [NSString stringWithFormat:@"%d", _product.count];
}

- (void)orderClick
{
    NSArray *unselectedCategory = [opition unselectedCategory];
    if(unselectedCategory.count == 0){
        _submitHandler(opition);
    }else{
        NSMutableString *str = [NSMutableString string];
        [str appendString:@"请选择"];
        for (NSString *item in unselectedCategory) {
            [str appendFormat:@",%@", item];
        }
        [SVProgressHUD showErrorWithStatus:str duration:1];
    }
}

- (void)cancelClick
{
    _cancelHandler();
}

- (void)setupTitle:(NSString *)title
          opitions:(SelectOpition *)selectOptioin
           product:(Product *)product
            cancel:(cancelSelection)cancelHandler
            submit:(submitSelection)submitHandler
{
    _product = product;
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
    countLbl.text = [NSString stringWithFormat:@"%d", _product.count];
    scrollView.contentSize = CGSizeMake(WIDTH(self), offsetY);
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
    cateTitleLbl.font = [UIFont systemFontOfSize:14];
    cateTitleLbl.textAlignment = TextAlignmentLeft;
    [scrollView addSubview:cateTitleLbl];
    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(categoryMargin, MaxY(cateTitleLbl), contentMaxWidth, 1)];
    liner.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:liner];
    offsetY = MaxY(liner);
    for (OpitionItem *item in category.opitionItems) {
        CGSize itemTitleSsize = [item.title sizeWithFont:font
                                       constrainedToSize:CGSizeMake(contentMaxWidth , CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
        OpitionButton *opitionBtn = [[OpitionButton alloc] initWithFrame:CGRectMake(categoryMargin,
                                                                                    offsetY + categoryMargin,
                                                                                    contentMaxWidth,
                                                                                    itemTitleSsize.height + 2*categoryMargin)];
        [opitionBtn setTitle:item.title forState:UIControlStateNormal];
        opitionBtn.opitionItem = item;
        opitionBtn.groupName = category.title;
        opitionBtn.tag = item.id;
        [opitionBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [scrollView addSubview:opitionBtn];
        offsetY = MaxY(opitionBtn);
    }
    return offsetY;
}

- (void)itemClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    btn.choosen = YES;
    float money = btn.tag == 0 ? 100 : 200;
    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", money];
    
    OpitionItem *item = btn.opitionItem;
    OpitionItem *itemUnderSameCategory = nil;
    NSMutableArray *selectedValues = [NSMutableArray arrayWithArray:opition.selectedValues];
    for (OpitionItem *opitionItem in selectedValues) {
        if(opitionItem.categoryId == item.categoryId){
            itemUnderSameCategory = opitionItem;
            break;
        }
    }
    if(itemUnderSameCategory)
        [selectedValues removeObject:itemUnderSameCategory];
    [selectedValues addObject:item];
    opition.selectedValues = selectedValues;
}

- (BOOL)isChecked:(OpitionButton *)btn
{
    BOOL isChecked = NO;
    OpitionItem *btnItem = btn.opitionItem;
    for (OpitionItem *item in opition.selectedValues) {
        if(item.id == btnItem.id){
            isChecked = YES;
            break;
        }
    }
    return isChecked;
}

@end
