//
//  KJCalendarModel.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/24.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJCalendarModel : NSObject
//年份
@property (assign, nonatomic) NSInteger year;
//今天第几号
@property (assign, nonatomic) NSInteger day;

@property (strong, nonatomic) NSMutableArray *monthData;

@end
