# KJCalendar

#简易日历的实现
#用的UICollectionView
##代理部分：
```
@protocol KJCalendarDelegate <NSObject>

/**
 随着每个月的天数不一样而改变高度

 @param height 日历高度
 */
- (void)calendarViewHeightChange:(CGFloat)height;


/**
 当前展示的年和月，当类型是年历的时候，只返回年

 @param year 年
 @param month 月
 */
- (void)currentShowYear:(NSInteger)year withMonth:(NSInteger)month;


/**
 选中的时间

 @param solar 阳历
 @param lunar 农历
 */
- (void)selectSolarDate:(NSString *)solar withLunar:(NSString *)lunar;

@end
```
##可自定义部分
```
//======以下属性可自定义======

//背景颜色
@property (strong, nonatomic) UIColor *bgColor;
//weekView背景色 默认clearcolor
@property (strong, nonatomic) UIColor *weekColor;
//选择状态下的背景颜色
@property (strong, nonatomic) UIColor *selectBgColor;
//选择状态下的字体颜色
@property (strong, nonatomic) UIColor *selectTitleColor;
//普通状态下公历字体颜色
@property (strong, nonatomic) UIColor *normalDateTitleColor;
//普通状态下农历字体颜色
@property (strong, nonatomic) UIColor *normalLunerTitleColor;
//今天的字体颜色
@property (strong, nonatomic) UIColor *todayTitleColor;
//今天选择状态下的背景颜色
@property (strong, nonatomic) UIColor *todaySelectBgColor;
//今天选择状态下的字体颜色
@property (strong, nonatomic) UIColor *todaySelectTitleColor;
//距屏幕左右间隔，默认8
@property (assign, nonatomic) CGFloat screenInSpace;
//每行（item）的高度，设置的高度不能大于宽度，宽度的来源是屏幕的宽减去左右间隔除以7得到
@property (assign, nonatomic) CGFloat rowHeight;
//设置是否显示阴历 YES-显示 NO-隐藏  默认YES
@property (assign, nonatomic) BOOL isShowLunar;
//公历字体 默认system 13
@property (strong, nonatomic) UIFont *dateFont;
//农历字体 默认system 8
@property (strong, nonatomic) UIFont *lunerFont;
//选中时公历字体 默认 [UIFont boldSystemFontOfSize:13.0f];
@property (strong, nonatomic) UIFont *dateSelectFont;
//选中时农历字体 默认 [UIFont boldSystemFontOfSize:8.0f];
@property (strong, nonatomic) UIFont *lunerSelectFont;
```
###使用：
```
//高度是根据日历的月份天数决定的
    self.calView = [[KJCanlendarView alloc] initWithY:0 withNavc:YES andLeastYear:0];
    self.calView.kjDelegate = self;
    
    [self.calView showKJCalendarInCtrl:self];
```

###效果图:
[gif]()
