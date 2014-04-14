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
#import "OpitionSelectPanel.h"

@interface OpitionSelectPanel ()
{
    SelectOpition *opition;
    cancelSelection _cancelHandler;
    submitSelection _submitHandler;
    
    UILabel *titleLbl;
    
    UIScrollView *scrollView;
 
    CircleImageView *avatorImgView;
    UILabel *nameLbl;
    UILabel *priceLbl;

    UIDatePicker *pick;
}
@end

@implementation OpitionSelectPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        float topHeight = 100;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), topHeight)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];

        UIView *linerView = [[ UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(topView) -1, WIDTH(topView), .5)];
        linerView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [topView addSubview:linerView];
        
        avatorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
        avatorImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        avatorImgView.layer.borderWidth = 1;
        [topView addSubview:avatorImgView];
        
        nameLbl= [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, Y(avatorImgView), 180, 30)];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor blackColor];
        nameLbl.font = [UIFont boldSystemFontOfSize:14];
        nameLbl.textAlignment = TextAlignmentLeft;
        [topView addSubview:nameLbl];

        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(avatorImgView) + 5, MaxY(nameLbl), 100, 30)];
        priceLbl.backgroundColor = [UIColor clearColor];
        priceLbl.textColor = [UIColor redColor];
        priceLbl.font = [UIFont systemFontOfSize:12];
        priceLbl.textAlignment = TextAlignmentLeft;
        [topView addSubview:priceLbl];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(MaxX(topView) - 50,
                                    10,
                                    40,
                                    40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
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
        [orderBtn setTitle:@"确认预约" forState:UIControlStateNormal];
        [orderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
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
    if (unselectedCategory.count == 0) {
        NSMutableArray *selectedValues = [NSMutableArray arrayWithArray:opition.selectedValues];
        [selectedValues addObject:pick.date];
        opition.selectedValues = selectedValues;

        _submitHandler(opition);
    } else {
        NSMutableString *str = [NSMutableString string];
        [str appendString:@"请选择"];
        for (NSString *item in unselectedCategory) {
            [str appendFormat:@"，%@", item];
        }

        NSMutableCharacterSet *characterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [characterSet addCharactersInString:@"，"];
        [SVProgressHUD showErrorWithStatus:[str stringByTrimmingCharactersInSet:characterSet] duration:1];
    }
}

- (void)cancelClick
{
    _cancelHandler();
}

- (void)setupData:(Staff *)staff
         opitions:(SelectOpition *)selectOptioin
           cancel:(cancelSelection)cancelHandler
           submit:(submitSelection)submitHandler
{
    titleLbl.text = @"预约";
    nameLbl.text = staff.name;
    [avatorImgView setImageWithURL:staff.avatorUrl];

    _cancelHandler = cancelHandler;
    _submitHandler = submitHandler;
    
    opition = selectOptioin;

    [self fillControls];
}

- (void)fillControls
{
    float offsetY =0 ; // 上一个cate的offsetY;
    for (OpitionCategory *category in opition.opitionCateogries) {
        offsetY = [self fillCategory:category withOffsetY:offsetY];
    }
    
    UILabel *timeLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, offsetY + 10, 100, 30)];
    timeLbl.font = [UIFont systemFontOfSize:14];
    timeLbl.textAlignment = NSTextAlignmentLeft;
    timeLbl.backgroundColor = [UIColor clearColor];
    timeLbl.textColor = [UIColor blackColor];
    timeLbl.text = @"预约时间";
    [scrollView addSubview:timeLbl];

    float categoryMargin = 10;
    float contentMaxWidth = WIDTH(self) - 2 * categoryMargin;

    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(categoryMargin, MaxY(timeLbl), contentMaxWidth, .5)];
    liner.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [scrollView addSubview:liner];
    
    pick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, MaxY(liner) + 10, 320, 100)];
    pick.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [scrollView addSubview:pick];

    offsetY = MaxY(pick);

    scrollView.contentSize = CGSizeMake(WIDTH(self), offsetY);
}

- (float)fillCategory:(OpitionCategory *)category withOffsetY:(float)offsetY
{
    int fontSize = 14;
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    float categoryMargin = 10;
    float contentMaxWidth = WIDTH(self) - 2 * categoryMargin;
    
    
    CGSize cateTitleSsize = [category.title sizeWithFont:font
                                       constrainedToSize:CGSizeMake(contentMaxWidth - 2 *categoryMargin, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *cateTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(categoryMargin,
                                                                      offsetY + categoryMargin,
                                                                      contentMaxWidth  ,
                                                                      cateTitleSsize.height + categoryMargin)];
    cateTitleLbl.text = category.title;
    cateTitleLbl.backgroundColor = [UIColor clearColor];
    cateTitleLbl.font = [UIFont systemFontOfSize:14];
    cateTitleLbl.textAlignment = TextAlignmentLeft;
    [scrollView addSubview:cateTitleLbl];

    UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(categoryMargin, MaxY(cateTitleLbl), contentMaxWidth, .5)];
    liner.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
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

    priceLbl.text = [NSString stringWithFormat:@"￥%.2f", btn.opitionItem.price];

    OpitionItem *item = btn.opitionItem;
    OpitionItem *itemUnderSameCategory = nil;
    NSMutableArray *selectedValues = [NSMutableArray arrayWithArray:opition.selectedValues];
    for (OpitionItem *opitionItem in selectedValues) {
        if(opitionItem.categoryId == item.categoryId){
            itemUnderSameCategory = opitionItem;
            break;
        }
    }

    if(itemUnderSameCategory) {
        [selectedValues removeObject:itemUnderSameCategory];
    }

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
