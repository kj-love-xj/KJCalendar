//
//  KJCalendarMonthCell.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJMonthModel.h"
#import "KJCanlendarView.h"

@interface KJCalendarMonthCell : UICollectionViewCell

+ (void)regisCellFor:(UICollectionView *)collectionView;
+ (instancetype)dequeueCellFor:(UICollectionView *)collectionView withIndex:(NSIndexPath *)index;

@property (strong, nonatomic)KJMonthModel *monthModel;

@property (strong, nonatomic)KJCanlendarView *calendarView;

- (void)setMonthModel:(KJMonthModel *)monthModel
             withView:(KJCanlendarView *)calendarView;

//设置是否显示阴历 YES-显示 NO-隐藏  默认YES
@property (assign, nonatomic) BOOL isShowLunar;
//每行（item）的高度，设置的高度不能大于宽度，宽度的来源是屏幕的宽减去左右间隔除以7得到
@property (assign, nonatomic) CGFloat rowHeight;
//公历字体
@property (strong, nonatomic) UIFont *dateFont;
//农历字体
@property (strong, nonatomic) UIFont *lunerFont;
//选中时公历字体 默认 [UIFont boldSystemFontOfSize:14.0f];
@property (strong, nonatomic) UIFont *dateSelectFont;
//选中时农历字体 默认 [UIFont boldSystemFontOfSize:10.0f];
@property (strong, nonatomic) UIFont *lunerSelectFont;

@end
