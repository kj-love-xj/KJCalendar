//
//  KJCalendarMonthCell.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCalendarMonthCell.h"
#import "KJCalendarDayCell.h"
#import "KJCollectionReusableView.h"

@interface KJCalendarMonthCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *monthCollectionView;

@end


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define WEEKDAY @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]

//显示月份的高度 headView
#define HEADERH  20.0

@implementation KJCalendarMonthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [KJCollectionReusableView regisViewFor:self.monthCollectionView];
    [KJCalendarDayCell regisCellFor:self.monthCollectionView];
    [self.monthCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
    
    self.monthCollectionView.scrollEnabled = NO;
}

+ (void)regisCellFor:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"KJCalendarMonthCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KJCalendarMonthCell"];
}

+ (instancetype)dequeueCellFor:(UICollectionView *)collectionView withIndex:(NSIndexPath *)index {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"KJCalendarMonthCell" forIndexPath:index];
}

- (void)setDateFont:(UIFont *)dateFont {
    _dateFont = dateFont;
    [self.monthCollectionView reloadData];
}

- (void)setLunerFont:(UIFont *)lunerFont {
    _lunerFont = lunerFont;
    [self.monthCollectionView reloadData];
}

- (void)setIsShowLunar:(BOOL)isShowLunar {
    _isShowLunar = isShowLunar;
    [KJCalendarDayCell appearance].isShowLunar = isShowLunar;
}

- (void)setDateSelectFont:(UIFont *)dateSelectFont {
    _dateFont = dateSelectFont;
    NSArray *arr = [self.monthCollectionView indexPathsForSelectedItems];
    for (UICollectionViewCell *cell in arr) {
        if ([cell isKindOfClass:[KJCalendarDayCell class]]) {
            ((KJCalendarDayCell *)cell).labelDate.font = dateSelectFont;
        }
    }
}

- (void)setLunerSelectFont:(UIFont *)lunerSelectFont {
    _lunerSelectFont = lunerSelectFont;
    NSArray *arr = [self.monthCollectionView indexPathsForSelectedItems];
    for (UICollectionViewCell *cell in arr) {
        if ([cell isKindOfClass:[KJCalendarDayCell class]]) {
            ((KJCalendarDayCell *)cell).labelLunar.font = lunerSelectFont;
        }
    }
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
     [KJCalendarDayCell appearance].rowHeight = rowHeight;
}

- (void)setMonthModel:(KJMonthModel *)monthModel
             withView:(KJCanlendarView *)calendarView {
    _monthModel = monthModel;
    _calendarView = calendarView;
    [self.monthCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.monthModel.totalDay + self.monthModel.week;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, HEADERH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        KJCollectionReusableView *headerView = [KJCollectionReusableView dequeueViewFor:collectionView withIndexPath:indexPath];
        CGFloat cellWidth = collectionView.frame.size.width/7.0;
        headerView.labelTitleLeftConstraint.constant =  cellWidth* self.monthModel.week + cellWidth/2.0/2.0;
        headerView.labelTitle.font = [UIFont boldSystemFontOfSize:12];
        headerView.labelTitle.text = [NSString stringWithFormat:@"%d月",(int)self.monthModel.month];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return CGSizeMake(collectionView.bounds.size.width/7.0, self.rowHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row >= self.monthModel.week && indexPath.row - self.monthModel.week < self.monthModel.totalDay) {
        KJCalendarDayCell *cell = [KJCalendarDayCell dequeueCellFor:collectionView withIndex:indexPath];
        [cell setMonthModel:self.monthModel indexPath:indexPath withView:self.calendarView];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpaceCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[KJCalendarDayCell class]]) {
        NSInteger deselectRow = -1;
        if (self.calendarView.kjSelectModel) {
            if (self.calendarView.kjSelectModel.month == self.monthModel.month && self.calendarView.kjSelectModel.year == self.monthModel.year) {
                deselectRow = self.calendarView.kjSelectModel.selectDay+self.calendarView.kjSelectModel.week-1;
            }
        }
        if (deselectRow == indexPath.row) {
            return;
        }
        self.monthModel.selectDay = indexPath.row - self.monthModel.week + 1;
        self.calendarView.kjSelectModel = self.monthModel;
        if (deselectRow >= 0) {
            [collectionView reloadItemsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForItem:deselectRow inSection:0]]];
        } else {
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        
    }
}


@end
