//
//  KJCollectionReusableView.h
//  KJCalendar
//
//  Created by Kegem Huang on 2017/3/25.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJCollectionReusableView : UICollectionReusableView

+ (void)regisViewFor:(UICollectionView *)collectionView;
+ (instancetype)dequeueViewFor:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTitleLeftConstraint;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@end
