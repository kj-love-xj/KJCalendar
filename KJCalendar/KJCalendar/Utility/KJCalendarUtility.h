//
//  KJCalendarUtility.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/22.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJCalendarUtility : NSObject

///获取日
+ (NSInteger)day:(NSDate *)date;

///获取月
+ (NSInteger)month:(NSDate *)date;

///获取年
+ (NSInteger)year:(NSDate *)date;

///获取某个月有多少天
+ (NSInteger)totaldaysForMonth:(NSDate *)date;

///某个月第一天是周几
+ (NSInteger)firstWeekdayForMonth:(NSDate *)date;

@end
