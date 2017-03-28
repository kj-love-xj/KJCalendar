//
//  KJCalendarFlowLayout.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCalendarFlowLayout.h"

@implementation KJCalendarFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    //获取目标区域中包含的cell
    NSArray *attArray = [super layoutAttributesForElementsInRect:targetRect];
    //collectionView在屏幕中心点y坐标
    UICollectionViewLayoutAttributes *att = nil;
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attributes in attArray) {
        CGFloat itemCenterY = attributes.center.y;
        CGFloat y = proposedContentOffset.y + (attributes.size.height/2.0);
        //找出离中心点最新的点
        if (fabs(itemCenterY - y) < fabs(offsetAdjustment)) {
            offsetAdjustment = itemCenterY - y;
            att = attributes;
        }
    }
    if (self.itemBlock) {
        self.itemBlock(att);
    }
    //返回最终停留的位置
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y+offsetAdjustment);
    
}

@end
