//
//  KJCanlendarView.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/22.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCanlendarView.h"
#import "Masonry.h"
#import "KJCalendarMonthCell.h"
#import "KJMonthModel.h"
#import "KJCalendarModel.h"
#import "KJCalendarUtility.h"
#import "NSDate+FSExtension.h"
#import "NSDate+KJChineseDate.h"
#import "KJCollectionReusableView.h"
#import "KJCalendarFlowLayout.h"

@interface KJCanlendarView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic) UIView *weekView;
//数据源
@property (strong, nonatomic) NSMutableArray *dataArray;
//月
@property (strong, nonatomic) NSMutableArray *monthArray;

@property (strong, nonatomic) UICollectionViewLayoutAttributes *kjAttributes;

@property (assign, nonatomic) BOOL isShowNavc;
@property (assign, nonatomic) CGFloat showY;
//最小年份
@property (assign, nonatomic) NSInteger smallYear;

@property (strong, nonatomic) KJCalendarFlowLayout *kjFlowLayout;

@end

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define WEEKDAY @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]


//星期view的高度
#define WEEKVIEWH 20.0
//显示月份的高度 headView
#define HEADERH  20.0

@implementation KJCanlendarView

- (instancetype)initWithY:(CGFloat)viewY
                 withNavc:(BOOL)isNavc
             andLeastYear:(NSInteger)smallYear {
    
    CGRect frame = CGRectMake(0, viewY+(isNavc ? 64 : 0), SCREEN_WIDTH, 0);
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.hidden = YES;
        _screenInSpace = 8.0;
        _bgColor = [UIColor lightGrayColor];
        _isShowNavc = isNavc;
        _showY = viewY;
        if (smallYear < 2000) {
            smallYear = 2000;
        }
        if (smallYear >= [KJCalendarUtility year:[NSDate date]]) {
            smallYear = [KJCalendarUtility year:[NSDate date]];
        }
        self.smallYear = smallYear;
        
        [self initializationDataSource];
        [self initializationCollectionView];
        [self initializationWeekView];
        
        //默认设置
        _isShowLunar = YES;
        _selectBgColor = [UIColor blackColor];
        _selectTitleColor = [UIColor whiteColor];
        _todayTitleColor = [UIColor redColor];
        _todaySelectBgColor = [UIColor redColor];
        _todaySelectTitleColor = [UIColor whiteColor];
        _rowHeight = (SCREEN_WIDTH-2*self.screenInSpace)/7.0;
        _normalDateTitleColor = [UIColor blackColor];
        _normalLunerTitleColor = [UIColor blackColor];
        _dateFont = [UIFont systemFontOfSize:13.0f];
        _lunerFont = [UIFont systemFontOfSize:8.0f];
        _dateSelectFont = [UIFont boldSystemFontOfSize:13.0f];
        _lunerSelectFont = [UIFont boldSystemFontOfSize:8.0f];
        [KJCalendarMonthCell appearance].rowHeight = _rowHeight;
        [KJCalendarMonthCell appearance].isShowLunar = _isShowLunar;
        
        [self.collectionView reloadData];
        
     }
    
    return self;
}

- (void)showKJCalendarInCtrl:(UIViewController *)ctrl {
    [ctrl.view addSubview:self];
    [self performSelector:@selector(showToday) withObject:0 afterDelay:0.1];
}

- (void)showToday {
    UICollectionViewLayoutAttributes * att = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:_kjTodayModel.month-1 inSection:_kjTodayModel.year-_smallYear]];
    self.collectionView.contentOffset = CGPointMake(0, att.frame.origin.y);

//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    //改变高度
    [self changeBgView:att];
}

- (void)showDate:(KJMonthModel *)monthModel {
    KJCalendarModel *calendarModel = self.dataArray.firstObject;
    NSInteger section = monthModel.year - calendarModel.year;
    
    UICollectionViewLayoutAttributes * att = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:monthModel.month-1 inSection:section]];
    self.collectionView.contentOffset = CGPointMake(0, att.frame.origin.y);
    //改变高度
    [self changeBgView:att];
}

//UICollectionView
- (void)initializationCollectionView {
    if (!self.collectionView) {
        
        _kjFlowLayout = [[KJCalendarFlowLayout alloc] init];
        WS(weakSelf)
        _kjFlowLayout.itemBlock = ^(UICollectionViewLayoutAttributes *attributes) {
            [weakSelf changeBgView:attributes];
        };
        // 设置间距
        _kjFlowLayout.minimumLineSpacing = 0;
        _kjFlowLayout.minimumInteritemSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_kjFlowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.decelerationRate = 0.1f;;
        // 隐藏水平滚动条
        self.collectionView.showsVerticalScrollIndicator = NO;
        // 取消弹簧效果
        self.collectionView.bounces = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self insertSubview:self.collectionView atIndex:0];
        [self collectionViewLayout];
        
        
        //空白站位cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SpaceCell"];
        //注册cell
        [KJCalendarMonthCell regisCellFor:self.collectionView];
//        [KJCollectionReusableView regisViewFor:self.collectionView];
    }
}

- (void)collectionViewLayout {
    WS(weakSelf)
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(weakSelf.screenInSpace);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-weakSelf.screenInSpace);
        make.top.mas_equalTo(weakSelf.mas_top).offset(0);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(0);
    }];
}

//初始化显示星期的View
- (void)initializationWeekView {
    if (!self.weekView) {
        self.weekView = [UIView new];
        self.weekView.backgroundColor = self.bgColor;
        [self addSubview:self.weekView];
        
        WS(weakSelf)
        [self.weekView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(0);
            make.right.mas_equalTo(weakSelf.mas_right).offset(0);
            make.top.mas_equalTo(weakSelf.mas_top).offset(0);
            make.height.equalTo(@WEEKVIEWH);
        }];
        
        for (int i = 0; i < 7; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.text = WEEKDAY[i];
            label.tag = i + 10;
            label.clipsToBounds = YES;
            [self.weekView addSubview:label];
            [self weekViewLyout:label];
        }
    }
}

- (void)weekViewLyout:(UIView *)weekLabel {
    CGFloat labW  = (SCREEN_WIDTH-self.screenInSpace*2)/7.0;
    WS(weakSelf)
    [weekLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.weekView.mas_top).offset(0);
        make.left.mas_equalTo(weakSelf.weekView.mas_left).offset((weekLabel.tag-10) * labW + weakSelf.screenInSpace);
        make.width.equalTo(@(labW));
        make.bottom.mas_equalTo(weakSelf.weekView.mas_bottom).offset(0);
    }];
    [weekLabel layoutIfNeeded];
}


- (void)setScreenInSpace:(CGFloat)screenInSpace {
    _screenInSpace = screenInSpace;
    for (int i = 0; i < 7; i ++) {
        UILabel *label = [self.weekView viewWithTag:10+i];
        [self weekViewLyout:label];
    }
    [self collectionViewLayout];
    [self.collectionView layoutIfNeeded];
    [self.collectionView reloadData];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.weekView.backgroundColor = bgColor;
}

- (void)setIsShowLunar:(BOOL)isShowLunar {
    _isShowLunar = isShowLunar;
    [KJCalendarMonthCell appearance].isShowLunar = isShowLunar;
}

- (void)setRowHeight:(CGFloat)rowHeight {
    if (rowHeight < _rowHeight) {
        _rowHeight = rowHeight;
        [KJCalendarMonthCell appearance].rowHeight = rowHeight;
    }
}

- (void)setTodaySelectBgColor:(UIColor *)todaySelectBgColor {
    _todaySelectTitleColor = todaySelectBgColor;
    [self.collectionView reloadData];
}

- (void)setTodayTitleColor:(UIColor *)todayTitleColor {
    _todayTitleColor = todayTitleColor;
    [self.collectionView reloadData];
}

- (void)setTodaySelectTitleColor:(UIColor *)todaySelectTitleColor {
    _todaySelectTitleColor = todaySelectTitleColor;
}

- (void)setSelectBgColor:(UIColor *)selectBgColor {
    _selectBgColor = selectBgColor;
    [self.collectionView reloadData];
}

- (void)setSelectTitleColor:(UIColor *)selectTitleColor {
    _selectTitleColor = selectTitleColor;
    [self.collectionView reloadData];
}

- (void)setNormalDateTitleColor:(UIColor *)normalDateTitleColor {
    _normalDateTitleColor = normalDateTitleColor;
    [self.collectionView reloadData];
}

- (void)setNormalLunerTitleColor:(UIColor *)normalLunerTitleColor {
    _normalLunerTitleColor = normalLunerTitleColor;
    [self.collectionView reloadData];
}

- (void)setDateFont:(UIFont *)dateFont {
    _dateFont = dateFont;
    [KJCalendarMonthCell appearance].dateFont = dateFont;
}

- (void)setLunerFont:(UIFont *)lunerFont {
    _lunerFont = lunerFont;
    [KJCalendarMonthCell appearance].lunerFont = lunerFont;
}

- (void)setDateSelectFont:(UIFont *)dateSelectFont {
    _dateFont = dateSelectFont;
    [KJCalendarMonthCell appearance].dateSelectFont = dateSelectFont;
}

- (void)setLunerSelectFont:(UIFont *)lunerSelectFont {
    _lunerSelectFont = lunerSelectFont;
    [KJCalendarMonthCell appearance].lunerSelectFont = lunerSelectFont;
}

- (void)setWeekColor:(UIColor *)weekColor {
    _weekColor = weekColor;
    self.weekView.backgroundColor = weekColor;
}

- (void)setKjSelectModel:(KJMonthModel *)kjSelectModel {
    if ((kjSelectModel.month != _kjSelectModel.month || kjSelectModel.year != _kjSelectModel.year) && _kjSelectModel) {
        //要刷新cell
        KJCalendarModel *calendarModel = self.dataArray.firstObject;
        NSInteger section = _kjSelectModel.year-calendarModel.year;
        if (self.kjAttributes.indexPath.section != section) {
            NSIndexSet *index = [NSIndexSet indexSetWithIndex:section];
            _kjSelectModel.selectDay = 0;
            [self.collectionView reloadSections:index];
        } else {
            KJCalendarModel *calenModel = self.dataArray[section];
            NSUInteger row = [calenModel.monthData indexOfObject:_kjSelectModel];
            if (row != NSNotFound) {
                NSIndexPath *index = [NSIndexPath indexPathForItem:row inSection:section];
                _kjSelectModel.selectDay = 0;
                [self.collectionView reloadItemsAtIndexPaths:@[index]];
            }
        }
    }
    _kjSelectModel = kjSelectModel;
    //选中的时间回调
    if ([self.kjDelegate respondsToSelector:@selector(selectSolarDate:withLunar:)]) {
        NSString *solar = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld 00:00:00",kjSelectModel.year,kjSelectModel.month,kjSelectModel.selectDay];
        NSString *lunar = [[NSDate fs_dateFromString:solar format:@"yyyy-MM-dd hh:mm:ss"] getChineseCalendar];
        [self.kjDelegate selectSolarDate:solar withLunar:lunar];
    }
}

- (void)initializationDataSource {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (!self.monthArray) {
        self.monthArray = [NSMutableArray arrayWithCapacity:0];
    }
    //获取本月的数据
    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    KJCalendarModel *calendarModel = [[KJCalendarModel alloc] init];
    //年
    calendarModel.year = [KJCalendarUtility year:date];
    //今天
    calendarModel.day = [KJCalendarUtility day:date];
    
    //月份数据
    KJMonthModel *monthModel = [[KJMonthModel alloc] init];
    //这个月共多少天
    monthModel.totalDay = [KJCalendarUtility totaldaysForMonth:date];
    //这个月第一天是星期几
    monthModel.week = [KJCalendarUtility firstWeekdayForMonth:date];
    //月份
    monthModel.month = [KJCalendarUtility month:date];
    //年份
    monthModel.year = [KJCalendarUtility year:date];
    monthModel.day = [KJCalendarUtility day:date];
    [calendarModel.monthData addObject:monthModel];
    
    self.kjTodayModel = monthModel;
    
    [self getYearDateSource:calendarModel];
    
    [self getSmallYearData];
}

- (void)getYearDateSource:(KJCalendarModel *)calenModel {
    if (calenModel.monthData.count < 12) {
        KJMonthModel *model = calenModel.monthData.lastObject;
        NSInteger month = 0;
        if (model) {
            month = model.month;
        }
        for (NSInteger i = month+1; i <= 12; i ++) {
            NSString *dateStr = [NSString stringWithFormat:@"%ld-%.2ld-01 00:00:00",calenModel.year,i];
            NSDate *curDate = [NSDate fs_dateFromString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
            //年
            calenModel.year = [KJCalendarUtility year:curDate];
            //月份数据
            KJMonthModel *monthModel = [[KJMonthModel alloc] init];
            //这个月共多少天
            monthModel.totalDay = [KJCalendarUtility totaldaysForMonth:curDate];
            //这个月第一天是星期几
            monthModel.week = [KJCalendarUtility firstWeekdayForMonth:curDate];
            //月份
            monthModel.month = [KJCalendarUtility month:curDate];
            //年份
            monthModel.year = [KJCalendarUtility year:curDate];
            [calenModel.monthData addObject:monthModel];
//            [self.monthArray addObject:monthModel];
        }
        
        for (NSInteger i = month-1; i > 0; i --) {
            NSString *dateStr = [NSString stringWithFormat:@"%ld-%.2ld-01 00:00:00",calenModel.year,i];
            NSDate *curDate = [NSDate fs_dateFromString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
            //年
            calenModel.year = [KJCalendarUtility year:curDate];
            //月份数据
            KJMonthModel *monthModel = [[KJMonthModel alloc] init];
            //这个月共多少天
            monthModel.totalDay = [KJCalendarUtility totaldaysForMonth:curDate];
            //这个月第一天是星期几
            monthModel.week = [KJCalendarUtility firstWeekdayForMonth:curDate];
            //月份
            monthModel.month = [KJCalendarUtility month:curDate];
            //年份
            monthModel.year = [KJCalendarUtility year:curDate];
            [calenModel.monthData insertObject:monthModel atIndex:0];
            [self.monthArray insertObject:monthModel atIndex:0];
        }
    }
    KJCalendarModel *model1 = self.dataArray.lastObject;
    if (model1 && model1.year > calenModel.year) {
        [self.dataArray insertObject:calenModel atIndex:0];
    } else {
        [self.dataArray addObject:calenModel];
    }
}

- (void)getSmallYearData {
    for (NSInteger i = self.kjTodayModel.year-1; i >= self.smallYear; i --) {
        KJCalendarModel *calendarModel = [[KJCalendarModel alloc] init];
        //年
        calendarModel.year = i;
        [self getYearDateSource:calendarModel];
    }
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    KJCalendarModel *calendarModel = self.dataArray[section];
    return calendarModel.monthData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KJCalendarModel *calendarModel = self.dataArray[indexPath.section];
    KJMonthModel *monthModel = calendarModel.monthData[indexPath.row];
    int rowCount = ceil((monthModel.totalDay + monthModel.week)/7.0);
    CGFloat cellHeight = rowCount * self.rowHeight + HEADERH;
    return CGSizeMake(SCREEN_WIDTH-2*self.screenInSpace, cellHeight);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KJCalendarModel *calendarModel = self.dataArray[indexPath.section];
    KJMonthModel *monthModel = calendarModel.monthData[indexPath.row];
    KJCalendarMonthCell *cell = [KJCalendarMonthCell dequeueCellFor:collectionView withIndex:indexPath];
    [cell setMonthModel:monthModel withView:self];
    return cell;
}

- (void)changeBgView:(UICollectionViewLayoutAttributes *)attributes {
    self.kjAttributes = attributes;
    //高度改变的回调
    if ([self.kjDelegate respondsToSelector:@selector(calendarViewHeightChange:)]) {
        [self.kjDelegate calendarViewHeightChange:attributes.size.height];
    }
    //当前展示的年月回调
    if ([self.kjDelegate respondsToSelector:@selector(currentShowYear:withMonth:)]) {
        KJCalendarModel *calenModel = self.dataArray[attributes.indexPath.section];
        KJMonthModel *mModel = calenModel.monthData[attributes.indexPath.row];
        [self.kjDelegate currentShowYear:mModel.year withMonth:mModel.month];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.frame;
        rect.size.height = attributes.size.height;
        self.frame = rect;
        
        if (self.hidden) {
            self.hidden = NO;
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (attributes.indexPath.section == self.dataArray.count-1) {
            //获取下一年的数据
            [self getNextYearData];
        }
    }];
}

- (void)getNextYearData {
    
    if (self.dataArray.count-1 == _kjAttributes.indexPath.section) {
        KJCalendarModel *calendarModel = self.dataArray.lastObject;
        //先获取下一年的内容
        NSString *strNextDate = [NSString stringWithFormat:@"%ld-01-01 00:00:00",calendarModel.year+1];
        NSDate *nextDate = [NSDate fs_dateFromString:strNextDate format:@"yyyy-MM-dd HH:mm:ss"];
        KJCalendarModel *newModel = [[KJCalendarModel alloc] init];
        //年
        newModel.year = [KJCalendarUtility year:nextDate];
        [self getYearDateSource:newModel];
        //后面新增了一年，插入一个section
        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:self.dataArray.count-1]];
    }
}

@end
