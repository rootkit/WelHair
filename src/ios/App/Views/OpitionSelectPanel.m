//
//  OpitionSelectPanel.m
//  WelHair
//
//  Created by lu larry on 3/2/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "OpitionSelectPanel.h"
#import "OpitionButton.h"
#import "SVProgressHUD.h"
@interface OpitionSelectPanel ()
{
    SelectOpition *opition;
    cancelSelection _cancelHandler;
    submitSelection _submitHandler;
    
    UILabel *titleLbl;
    
    UIScrollView *scrollView;
    
}
@end
@implementation OpitionSelectPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float topHeight = 40;
        float cancelBtnWidth = 60;
        float cancelBtnHeight = 30;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    WIDTH(self),
                                                                    topHeight)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                0,
                                                                 WIDTH(topView) - 30 - cancelBtnWidth, topHeight)];
        titleLbl.textColor = [UIColor blackColor];
        [topView addSubview:titleLbl];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(MaxX(titleLbl) + 10,
                                    (HEIGHT(topView) - cancelBtnHeight)/2,
                                    cancelBtnWidth,
                                    cancelBtnHeight);
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:cancelBtn];
        
        float bottomHeight = 40;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     HEIGHT(self) - bottomHeight,
                                                                     WIDTH(self),
                                                                      40)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(0, 0, WIDTH(bottomView), HEIGHT(bottomView));
        [orderBtn setTitle:@"Order" forState:UIControlStateNormal];
        [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchDown];
        [bottomView addSubview:orderBtn];
        
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MaxY(topView), WIDTH(self), HEIGHT(self) - bottomHeight - HEIGHT(topView))];
        scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView) * 2);
        scrollView.backgroundColor = [UIColor colorWithHexString:@"EEE"];
        [self addSubview:scrollView];
    }
    return self;
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
            cancel:(cancelSelection)cancelHandler
            submit:(submitSelection)submitHandler
{
    titleLbl.text = title;
    _cancelHandler = cancelHandler;
    _submitHandler = submitHandler;
    
    opition = selectOptioin;
    [self fillControls];
}

- (void)fillControls
{
    float offsetY = 0; // 上一个cate的offsetY];
    for (OpitionCategory *category in opition.opitionCateogries) {
        offsetY = [self fillCategory:category withOffsetY:offsetY];
    }
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
    cateTitleLbl.textAlignment = TextAlignmentCenter;
    [scrollView addSubview:cateTitleLbl];
    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(categoryMargin, MaxY(cateTitleLbl) + categoryMargin, contentMaxWidth, 1)];
    liner.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:liner];
    offsetY = MaxY(liner);
    for (OpitionItem *item in category.opitionItems) {
            CGSize itemTitleSsize = [item.title sizeWithFont:font
                                           constrainedToSize:CGSizeMake(contentMaxWidth , CGFLOAT_MAX)
                                               lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *itemTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(categoryMargin,
                                                                              offsetY + categoryMargin,
                                                                              contentMaxWidth,
                                                                              itemTitleSsize.height + 2*categoryMargin)];
            itemTitleLbl.text = item.title;
            itemTitleLbl.textAlignment = TextAlignmentCenter;
            OpitionButton *opitionBtn = [OpitionButton buttonWithType:UIButtonTypeCustom];
            opitionBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            opitionBtn.layer.borderWidth = 1.0;
            opitionBtn.frame = itemTitleLbl.frame;
            opitionBtn.opitionItem = item;
            opitionBtn.tag = item.id;
            opitionBtn.layer.borderColor = [self isChecked:opitionBtn]?[[UIColor redColor] CGColor]:[[UIColor lightGrayColor] CGColor];
        
            [opitionBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
            [scrollView addSubview:itemTitleLbl];
            [scrollView addSubview:opitionBtn];
            offsetY = MaxY(itemTitleLbl);
    }
    return offsetY;
}

- (void)itemClick:(id)sender
{
    OpitionButton *btn = (OpitionButton *)sender;
    [self refreshSelectedOpitions:btn.opitionItem];
    btn.layer.borderColor = [self isChecked:btn]?[[UIColor redColor] CGColor]:[[UIColor lightGrayColor] CGColor];

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

- (void)refreshSelectedOpitions:(OpitionItem *)item
{
    OpitionItem *itemUnderSameCategory = nil;
    NSMutableArray *selectedValues = [NSMutableArray arrayWithArray:opition.selectedValues];
    for (OpitionItem *opitionItem in selectedValues) {
        if(opitionItem.categoryId == item.categoryId){
            itemUnderSameCategory = opitionItem;
            break;
        }
    }
    //用户选择该类别下其他选项
    if(itemUnderSameCategory){
        [selectedValues removeObject:itemUnderSameCategory];
        for (UIView *view in scrollView.subviews) {
            if([view isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)view;
                if(btn.tag == itemUnderSameCategory.id){
                    btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                }
            }
        }
    }
    //用户取消所选option
    if(itemUnderSameCategory != item){
        [selectedValues addObject:item];
    }
    opition.selectedValues = selectedValues;
}

@end
