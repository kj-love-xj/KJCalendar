//
//  KJCalendarModel.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/24.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCalendarModel.h"

@implementation KJCalendarModel

- (NSMutableArray *)monthData {
    if (!_monthData) {
        _monthData = [NSMutableArray arrayWithCapacity:0];
    }
    return _monthData;
}

@end
