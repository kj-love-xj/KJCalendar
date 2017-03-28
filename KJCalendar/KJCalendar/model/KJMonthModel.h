//
//  KJMonthModel.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/24.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJMonthModel : NSObject
//年份
@property (assign, nonatomic) NSInteger year;
//月份
@property (assign, nonatomic) NSInteger month;
//第一天是周几
@property (assign, nonatomic) NSInteger week;
//这个月共多少天
@property (assign, nonatomic) NSInteger totalDay;
//今天第几号
@property (assign, nonatomic) NSInteger day;
//选中的第几号
@property (assign, nonatomic) NSInteger selectDay;

@end
