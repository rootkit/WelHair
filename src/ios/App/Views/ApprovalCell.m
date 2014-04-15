//
//  ApprovalCell.m
//  WelHair
//
//  Created by lu larry on 4/15/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "ApprovalCell.h"
#import "CircleImageView.h"
#import "Staff.h"
@interface ApprovalCell ()

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) CircleImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *descrpLbl;
@property (nonatomic, strong) UIButton *approveBtn;
@property (nonatomic, strong) UIButton *rejectBtn;

@end



@implementation ApprovalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imgView = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:self.imgView];
        self.imgView.layer.borderColor = [[UIColor colorWithHexString:@"e0e0de"] CGColor];
        self.imgView.layer.borderWidth = 2;
        self.imgView.userInteractionEnabled = YES;
        [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoStaffDetail)]];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                 Y(self.imgView),
                                                                 100,
                                                                 HEIGHT(self.imgView)/2)];
        self.nameLbl.font = [UIFont boldSystemFontOfSize:16];
        self.nameLbl.numberOfLines = 1;
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.textColor = [UIColor blackColor];
        [self addSubview:self.nameLbl];
        
        self.descrpLbl = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.imgView) + 5,
                                                                  MaxY(self.nameLbl),
                                                                  WIDTH(self.nameLbl),
                                                                  HEIGHT(self.imgView)/2)];
        self.descrpLbl.font = [UIFont systemFontOfSize:12];
        self.descrpLbl.numberOfLines = 1;
        self.descrpLbl.backgroundColor = [UIColor clearColor];
        self.descrpLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:self.descrpLbl];
        
        self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rejectBtn.frame =  CGRectMake(200, 25, 40, 30);
        self.rejectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.rejectBtn.layer.cornerRadius = 5;
        [self.rejectBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rejectBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.rejectBtn addTarget:self action:@selector(rejectClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.rejectBtn];
        
        self.approveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.approveBtn.frame =  CGRectMake(MaxX(self.rejectBtn) + 20, 25, 40, 30);
        self.approveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.approveBtn.layer.cornerRadius = 5;
        [self.approveBtn setTitle:@"同意" forState:UIControlStateNormal];
        [self.approveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.approveBtn setBackgroundColor:[UIColor redColor]];
        [self.approveBtn addTarget:self action:@selector(appriveClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.approveBtn];

    }
    return self;
}


- (void)setup:(NSDictionary *)dic
{
    self.dataDic = dic;
    Staff *s =  [FakeDataHelper getFakeStaffList][0];
    [self.imgView setImageWithURL:s.avatorUrl];
    self.nameLbl.text = s.name;
    self.descrpLbl.text = @"请求加入";
    
}

- (void)gotoStaffDetail
{
    Staff *s =  [FakeDataHelper getFakeStaffList][0];
    [self.delegate didTapStaff:s];
}

- (void)rejectClick
{
}

- (void)appriveClick
{
    
}

@end
