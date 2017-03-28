//
//  KJCalendarDayCell.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJMonthModel.h"
#import "KJCanlendarView.h"

@interface KJCalendarDayCell : UICollectionViewCell

+ (void)regisCellFor:(UICollectionView *)collectionView;
+ (instancetype)dequeueCellFor:(UICollectionView *)collectionView
                     withIndex:(NSIndexPath *)index;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelDateCenterYConstraint;

//背景颜色 (圆圈)
@property (strong, nonatomic) IBOutlet UIImageView *bgView;
//阳历
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
//阴历
@property (strong, nonatomic) IBOutlet UILabel *labelLunar;

//设置是否显示阴历 YES-显示 NO-隐藏  默认YES
@property (assign, nonatomic) BOOL isShowLunar;
//每行（item）的高度，设置的高度不能大于宽度，宽度的来源是屏幕的宽减去左右间隔除以7得到
@property (assign, nonatomic) CGFloat rowHeight;

- (void)setMonthModel:(KJMonthModel *)monthModel
            indexPath:(NSIndexPath *)indexPath
             withView:(KJCanlendarView *)calendarView;

@end
