//
//  CCSheetCellComponent.h
//  
//
//  Created by Cocos on 2020/2/28.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSheetHeaderCellComponentContentProtocol.h"
#import "CCPenetrateCollectionView.h"

@class CCSheetCellComponent;

extern NSString *_Nonnull const CCSheetCellComponentReuseIdentifier;

NS_ASSUME_NONNULL_BEGIN

@protocol FMSheetTVCellScrollNotifyDelegate <NSObject>

/// Cell滚动时, 会调用该代理方法
///
/// 如果CCSheetCellComponent对象的disableScrollNotify属性为YES, 则不会触发该方法
- (void)sheetCell:(CCSheetCellComponent *)cell scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state;

/// Cell滚动时, 会调用该代理方法
///
/// 如果CCSheetCellComponent对象的disableHeaderScrollNotify属性为YES, 则不会触发该方法.
- (void)sheetCell:(CCSheetCellComponent *)cell scrollingForHeaderOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state;

@end

/// 所有支持横向扩展的Cell的基类
///
/// 默认实现了一个支持横向滚动的UICollectionView, 并实现了滚动事件分发, 所有要支持横向滚动的视图都需要继承该类.
///
/// 内置的UICollectionView默认注册了UICollectionViewCell, Cell上只有一个测试字符, 开发者需要自行重新注册好UICollectionViewCell的子类, 自行编写UI代码.
@interface CCSheetCellComponent : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CCSheetHeaderCellComponentContentProtocol>

/// 是否允许Cell向Header的代理发出滚动信号
///
/// 如果当前滚动是从Header传递给Cell的, 则需要设置该属性YES, 这样可以避免Cell的横向滚动信号回传给Header
@property (nonatomic, assign) BOOL disableHeaderScrollNotify;

/// 子类实现自定义布局时可用该属性为内置的collection视图添加cell.
///
/// 注意collectionView其实和scrollView是同一个对象
@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, weak) id<FMSheetTVCellScrollNotifyDelegate> notificationDelegate;

@end

NS_ASSUME_NONNULL_END
