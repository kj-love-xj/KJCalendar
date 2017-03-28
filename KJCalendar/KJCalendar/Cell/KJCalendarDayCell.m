//
//  KJCalendarDayCell.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCalendarDayCell.h"
#import "NSDate+FSExtension.h"
#import "NSDate+KJChineseDate.h"

@implementation KJCalendarDayCell


+ (void)regisCellFor:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"KJCalendarDayCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KJCalendarDayCell"];
}

+ (instancetype)dequeueCellFor:(UICollectionView *)collectionView withIndex:(NSIndexPath *)index {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"KJCalendarDayCell" forIndexPath:index];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    self.bgView.layer.cornerRadius = (rowHeight-8)/2.0;
    [self.bgView layoutIfNeeded];
}

- (void)setIsShowLunar:(BOOL)isShowLunar {
    _isShowLunar = isShowLunar;
    if (isShowLunar) {
        self.labelDateCenterYConstraint.constant = -5;
    } else {
        self.labelDateCenterYConstraint.constant = 0;
    }
    
    [self.labelDate layoutIfNeeded];
    [self.labelLunar layoutIfNeeded];
}

//- (void)setDateFont:(UIFont *)dateFont {
//    _dateFont = dateFont;
//    self.labelDate.font = dateFont;
//    [self.labelDate layoutIfNeeded];
//}
//
//- (void)setLunerFont:(UIFont *)lunerFont {
//    _lunerFont = lunerFont;
//    self.labelLunar.font = lunerFont;
//    [self.labelLunar layoutIfNeeded];
//}

- (void)setMonthModel:(KJMonthModel *)monthModel
            indexPath:(NSIndexPath *)indexPath
             withView:(KJCanlendarView *)calendarView{
    int day = (int)(indexPath.row - monthModel.week) + 1;
    self.labelDate.text = [NSString stringWithFormat:@"%d",day];
    
    self.labelLunar.hidden = !calendarView.isShowLunar;
    if (calendarView.isShowLunar) {
        //计算阴历
        NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d 00:00:00",(int)monthModel.year,(int)monthModel.month,day];
        NSString *lunarStr = [[NSDate fs_dateFromString:dateStr format:@"yyyy-MM-dd hh:mm:ss"] getChineseCalendar];
        NSArray *lunarAry = [lunarStr componentsSeparatedByString:@" "];
        if ([lunarAry.lastObject isEqualToString:@"初一"]) {
            self.labelLunar.text = lunarAry[1];
        } else {
            self.labelLunar.text = lunarAry.lastObject;
        }
    }
    
    BOOL res = [self monthModel:monthModel compareModel:calendarView.kjSelectModel andToday:day];
    if (day == monthModel.day) {//当天
        self.bgView.backgroundColor = res ? calendarView.todaySelectBgColor : [UIColor clearColor];
        self.labelDate.textColor = self.labelLunar.textColor = res ? calendarView.todaySelectTitleColor : calendarView.todayTitleColor;
        self.labelLunar.font = calendarView.lunerSelectFont;
        self.labelDate.font = calendarView.dateSelectFont;
    } else {
        self.bgView.backgroundColor = res ? calendarView.selectBgColor:[UIColor clearColor];
        self.labelLunar.textColor = res ? calendarView.selectTitleColor : calendarView.normalLunerTitleColor;
        self.labelDate.textColor = res ? calendarView.selectTitleColor : calendarView.normalDateTitleColor;
        
        self.labelDate.font = res ? calendarView.dateSelectFont : calendarView.dateFont;
        self.labelLunar.font = res ? calendarView.lunerSelectFont : calendarView.lunerFont;
    }
}

//判断是否是选中的item
- (BOOL)monthModel:(KJMonthModel *)monthModel compareModel:(KJMonthModel *)kjSelectModel andToday:(NSInteger)day {
    if (!kjSelectModel) {
        return NO;
    }
    if (monthModel.year == kjSelectModel.year && monthModel.month == kjSelectModel.month && kjSelectModel.selectDay == day) {
        return YES;
    } else {
        return NO;
    }
}

@end
