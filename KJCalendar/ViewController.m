//
//  ViewController.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/22.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "ViewController.h"
#import "KJCanlendarView.h"
#import "KJCalendarUtility.h"

@interface ViewController ()<KJCalendarDelegate>

@property (strong, nonatomic) KJCanlendarView *calView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"日历";
    
    //高度是根据日历的月份天数决定的
    self.calView = [[KJCanlendarView alloc] initWithY:0 withNavc:YES andLeastYear:0];
    self.calView.kjDelegate = self;
    
    [self.calView showKJCalendarInCtrl:self];

    //显示今日月历
    UIButton *today = [UIButton buttonWithType:UIButtonTypeCustom];
    today.frame = CGRectMake(0, 0, 30, 30);
    [today setTitle:@"今日" forState:UIControlStateNormal];
    [today setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    today.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [today addTarget:self action:@selector(showTodayAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *batBtn1 = [[UIBarButtonItem alloc] initWithCustomView:today];
    
    self.navigationItem.rightBarButtonItems = @[batBtn1];
    
}

- (void)showTodayAction {
    [self.calView showToday];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 随着每个月的天数不一样而改变高度
 
 @param height 日历高度
 */
- (void)calendarViewHeightChange:(CGFloat)height {
    NSLog(@"%s",__func__);
    NSLog(@"日历的高度%f",height);
}


/**
 当前展示的年和月
 
 @param year 年
 @param month 月
 */
- (void)currentShowYear:(NSInteger)year withMonth:(NSInteger)month {
    NSLog(@"%s",__func__);
    NSLog(@"当前展示的时间：%ld年,%ld月",year,month);
    
    self.title = [NSString stringWithFormat:@"%ld年%ld月",year,month];
}


/**
 选中的时间
 
 @param solar 阳历
 @param lunar 农历
 */
- (void)selectSolarDate:(NSString *)solar withLunar:(NSString *)lunar {
    NSLog(@"%s",__func__);
    NSLog(@"选择的日期-->阳历：%@， 农历：%@",solar,lunar);
}

@end
