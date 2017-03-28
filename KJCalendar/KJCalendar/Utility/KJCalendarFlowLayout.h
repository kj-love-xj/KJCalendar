//
//  KJCalendarFlowLayout.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJCanlendarView.h"

typedef void(^ChangeItemHeightBlock)(UICollectionViewLayoutAttributes *attributes);

@interface KJCalendarFlowLayout : UICollectionViewFlowLayout

@property (copy, nonatomic) ChangeItemHeightBlock itemBlock;


@end
