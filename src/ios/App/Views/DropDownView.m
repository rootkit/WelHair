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

#import "DropDownView.h"
@interface DropDownView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *pointToView; // the start position
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic) int selectedIndex;

@end
@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
      contentHeight:(float) contentHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped:)]];
        [self addSubview:bgView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,contentHeight)];
        self.tableView.layer.borderWidth = 1;
        self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"dfe0e3"] CGColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:self.tableView];
        self.tableView.transform = CGAffineTransformMakeTranslation(0,-contentHeight);
        self.alpha = 0;
    }
    return self;
}

- (void)bgTapped:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (void)showData:(NSArray *)datasource
   selectedIndex:(int)selectedIndex
      pointToView:(UIView *)view
{
    if(self.pointToView != view){
        self.selectedIndex = selectedIndex;
        self.datasource = datasource;
        [self.tableView reloadData];
        self.alpha = 1;
        [UIView transitionWithView:self.tableView
                          duration:0.3
                           options:UIViewAnimationOptionCurveLinear
                        animations:
         ^{
             self.tableView.transform = CGAffineTransformMakeTranslation(0,0);
         }
                        completion:NULL];
        self.pointToView = view;
    }
}

- (void)hide
{
    self.alpha = 0;
    self.pointToView = nil;
    [UIView transitionWithView:self.tableView
                      duration:0.3
                       options:UIViewAnimationOptionCurveLinear
                    animations:
     ^{
         self.tableView.transform = CGAffineTransformMakeTranslation(0,-HEIGHT(self.tableView));
     }
                    completion:NULL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"DropDownCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [self.datasource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = self.selectedIndex == indexPath.row? [UIColor orangeColor]: [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didPickItemAtIndex:indexPath.row forView:self.pointToView];
    [self hide];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

@end
