//
//  NSDate+FSExtension.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "NSDate+FSExtension.h"
#import "NSCalendar+FSExtension.h"

@implementation NSDate (FSExtension)

- (NSInteger)fs_year
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSYearCalendarUnit fromDate:self];
    return component.year;
}

- (NSInteger)fs_month
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSMonthCalendarUnit
                                              fromDate:self];
    return component.month;
}

- (NSInteger)fs_day
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSDayCalendarUnit
                                              fromDate:self];
    return component.day;
}

- (NSInteger)fs_weekday
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    return component.weekday;
}

- (NSInteger)fs_hour
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSHourCalendarUnit
                                              fromDate:self];
    return component.hour;
}

- (NSInteger)fs_minute
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSMinuteCalendarUnit
                                              fromDate:self];
    return component.minute;
}

- (NSInteger)fs_second
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSSecondCalendarUnit
                                              fromDate:self];
    return component.second;
}

- (NSInteger)fs_numberOfDaysInMonth
{
    NSCalendar *c = [NSCalendar fs_sharedCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self];
    return days.length;
}

- (NSString *)fs_stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDate *)fs_dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fs_dateBySubtractingMonths:(NSInteger)months
{
    return [self fs_dateByAddingMonths:-months];
}

- (NSDate *)fs_dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fs_dateBySubtractingDays:(NSInteger)days
{
    return [self fs_dateByAddingDays:-days];
}

- (NSDate *)fs_dateByAddingMinutes:(NSInteger)minutes
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)fs_dateBySubtractingMinutes:(NSInteger)minutes
{
    return [self fs_dateByAddingMonths:-minutes];
}

- (NSInteger)fs_yearsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.year;
}

- (NSInteger)fs_monthsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSMonthCalendarUnit
                                               fromDate:date
                                                 toDate:self
                                                    options:0];
    return components.month;
}

- (NSInteger)fs_daysFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.day;
}

- (BOOL)fs_isEqualToDateForMonth:(NSDate *)date
{
    return self.fs_year == date.fs_year && self.fs_month == date.fs_month;
}

- (BOOL)fs_isEqualToDateForDay:(NSDate *)date
{
    return self.fs_year == date.fs_year && self.fs_month == date.fs_month && self.fs_day == date.fs_day;
}


+ (instancetype)fs_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (instancetype)fs_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

- (NSString *)fs_dateIntervalSinceNow
{
    NSTimeInterval interval = [self timeIntervalSinceNow];
    NSInteger dInterval = fabs(interval);
    NSDate *dateNow = [NSDate date];
    NSString *string = @"";
    //是否是今天
    if ([self fs_isEqualToDateForDay:dateNow]) {//是今天
        if (dInterval < 5) {
            string = @"刚刚";
        } else if (dInterval < 60) {
            string = [NSString stringWithFormat:@"%d秒前", (int)dInterval];
        } else if (dInterval < 60*60) {
            string = [NSString stringWithFormat:@"%d分钟前", (int)(dInterval/60)];
        } else if (dInterval < 60*60*24) {
            string = [NSString stringWithFormat:@"%d小时前", (int)(dInterval/(60*60))];
        }
    } else if([[dateNow fs_dateBySubtractingDays:1] fs_isEqualToDateForDay:self]) {//昨天
        string = @"昨天";
    } else {//前天及以前
        if (self.fs_year == dateNow.fs_year) {//是同一年
            NSCalendar *calendar = [NSCalendar fs_sharedCalendar];
            NSDateComponents *components =[calendar components:NSDayCalendarUnit fromDate:self toDate:dateNow options:NSCalendarWrapComponents];
            int days = (int)[components day] + 1;
            if (days <= 30) {
                string = [NSString stringWithFormat:@"%d天前",days];
            } else {
                string = [NSString stringWithFormat:@"%@",[self fs_stringWithFormat:@"M-d HH:mm"]];
            }
        } else {//不是今年
            string = [NSString stringWithFormat:@"%@",[self fs_stringWithFormat:@"yy-M-d HH:mm"]];
        }
    }
    return string;
}

////聊天时间显示格式
//- (NSString *)fs_timeIntervalSinceNow
//{
//    NSDate *dateNow = [NSDate date];
//    NSString *string = @"";
//    //是否是今天
//    if ([self fs_isEqualToDateForDay:dateNow]) {//是今天
//        string = [self fs_stringWithFormat:@"HH:mm"];
//    } else if([[dateNow fs_dateBySubtractingDays:1] fs_isEqualToDateForDay:self]) {//昨天
//        string = [NSString stringWithFormat:@"昨天 %@",[self fs_stringWithFormat:@"HH:mm"]];
//    } else if([[dateNow fs_dateBySubtractingDays:2] fs_isEqualToDateForDay:self]) {//前天
//        
//        string = [NSString stringWithFormat:@"%@ %@",[Utility currentShowingWeek:self],[self fs_stringWithFormat:@"HH:mm"]];
//    } else if([[dateNow fs_dateBySubtractingDays:3] fs_isEqualToDateForDay:self]) {//前两天
//        string = [NSString stringWithFormat:@"%@ %@",[Utility currentShowingWeek:self],[self fs_stringWithFormat:@"HH:mm"]];
//    } else if([[dateNow fs_dateBySubtractingDays:4] fs_isEqualToDateForDay:self]) {//前三天
//        string = [NSString stringWithFormat:@"%@ %@",[Utility currentShowingWeek:self],[self fs_stringWithFormat:@"HH:mm"]];
//    } else {//以前
//        string = [NSString stringWithFormat:@"%@",[self fs_stringWithFormat:@"yyyy-MM-dd HH:mm"]];
//    }
//    return string;
//}

////聊天时间显示格式
//- (NSString *)fs_timeSimpleIntervalSinceNow
//{
//    NSDate *dateNow = [NSDate date];
//    NSString *string = @"";
//    //是否是今天
//    if ([self fs_isEqualToDateForDay:dateNow]) {//是今天
//        string = [self fs_stringWithFormat:@"HH:mm"];
//    } else if([[dateNow fs_dateBySubtractingDays:1] fs_isEqualToDateForDay:self]) {//昨天
//        string = @"昨天";
//    } else if([[dateNow fs_dateBySubtractingDays:2] fs_isEqualToDateForDay:self]) {//前天
//        string = [NSString stringWithFormat:@"%@",[Utility currentShowingWeek:self]];
//    } else if([[dateNow fs_dateBySubtractingDays:3] fs_isEqualToDateForDay:self]) {//前两天
//        string = [NSString stringWithFormat:@"%@",[Utility currentShowingWeek:self]];
//    } else if([[dateNow fs_dateBySubtractingDays:4] fs_isEqualToDateForDay:self]) {//前三天
//        string = [NSString stringWithFormat:@"%@",[Utility currentShowingWeek:self]];
//    } else {//以前
//        string = [NSString stringWithFormat:@"%@",[self fs_stringWithFormat:@"yy/M/d"]];
//    }
//    return string;
//}

@end
