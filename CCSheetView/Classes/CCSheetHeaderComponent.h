//
//  CCSheetHeaderComponent.h
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSheetHeaderCellComponentContentProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class CCSheetHeaderComponent;

@protocol CCSheetTVHeaderScrollNotifyDelegate <NSObject>

- (void)sheetHeader:(CCSheetHeaderComponent *)header scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state;

@end

/// 和CCSheetHeaderComponent类似, 实现了滚动同步功能的Header, 有需要的可以通过实现该类的子类来定制具体UI
@interface CCSheetHeaderComponent : UITableViewHeaderFooterView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CCSheetHeaderCellComponentContentProtocol>

@property (nonatomic, weak) id<CCSheetTVHeaderScrollNotifyDelegate> notificationDelegate;

/// 子类实现自定义布局时可用该属性为内置的collection视图添加cell.
///
/// 注意collectionView其实和scrollView是同一个对象
@property (nonatomic, readonly) UICollectionView *collectionView;

/// 标记属于哪个section
@property (nonatomic, assign) NSInteger belongSection;

@end

NS_ASSUME_NONNULL_END
