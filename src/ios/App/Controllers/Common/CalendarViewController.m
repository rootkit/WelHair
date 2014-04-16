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

#import "CalendarViewController.h"
#import <MNCalendarView.h>

@interface CalendarViewController ()<MNCalendarViewDelegate>

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择预约时间";
        self.rightNavItemTitle = @"预约";
        self.leftNavItemTitle = @"取消";
    }
    return self;
}

- (void) leftNavItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) rightNavItemClick
{
    [self dismissViewControllerAnimated:YES completion:^(){
        [SVProgressHUD showSuccessWithStatus:@"成功预约" duration:2];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MNCalendarView *calendarView = [[MNCalendarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) )];
    calendarView.selectedDate = [NSDate date];
    calendarView.delegate = self;
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date;
{
    return YES;
}
- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    
}

@end
