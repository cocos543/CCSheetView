//
//  CCSheetCellComponent.h
//  
//
//  Created by Cocos on 2020/2/28.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCSheetCellComponent;

extern NSString * _Nonnull const CCSheetCellReuseIdentifier;

NS_ASSUME_NONNULL_BEGIN

@protocol CCSheetTVCellScrollNotifyDelegate <NSObject>

- (void)sheetCell:(CCSheetCellComponent *)cell scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state;

@end

/// Cell滚动状态信息提供者, 可以实现该代理, 方便Cell知道当前的ScrollView的初始位置多少
@protocol CCSheetTVCellScrollViewStateSuggesterDelegate <NSObject>

- (CGPoint)suggestContentOffsetForSheetCell:(CCSheetCellComponent *)cell;

@end

/// 所有SheetCellComponent组件都必须实现该协议, 用来给每一行的列提供数据
@protocol CCSheetCellComponentContentProtocol <NSObject>

@property (nonatomic, strong) __kindof NSArray *contentItems;

@end

/// 所有支持横向扩展的Cell的基类
///
/// 默认实现了一个支持横向滚动的UICollectionView, 并实现了滚动事件分发, 所有要支持横向滚动的视图都需要继承该类.
///
/// 内置的UICollectionView默认注册了UICollectionViewCell, Cell上只有一个测试字符, 开发者需要自行重新注册好UICollectionViewCell的子类, 自行编写UI代码.
@interface CCSheetCellComponent : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CCSheetCellComponentContentProtocol>

/// 是否允许通知滚动信息
///
/// 默认 NO
@property (nonatomic, assign) BOOL disableScrollNotify;

@property (nonatomic, strong) NSArray<NSNumber *> *columnWidths;

/// 同步横向偏移量时可用该属性
@property (nonatomic, readonly) UIScrollView *scrollView;

/// 子类实现自定义布局时可用该属性为内置的collection视图添加cell.
///
/// 注意collectionView其实和scrollView是同一个对象
@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, weak) id<CCSheetTVCellScrollNotifyDelegate> notificationDelegate;

@property (nonatomic, weak) id<CCSheetTVCellScrollViewStateSuggesterDelegate> suggesterDelegate;

@end

NS_ASSUME_NONNULL_END
