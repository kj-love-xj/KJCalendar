//
//  KJCollectionReusableView.m
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCollectionReusableView.h"

@implementation KJCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (void)regisViewFor:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"KJCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KJCollectionReusableView"];
}

+ (instancetype)dequeueViewFor:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KJCollectionReusableView" forIndexPath:indexPath];
}

@end
