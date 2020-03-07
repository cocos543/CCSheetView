//
//  CCSheetTVCell.h
//
//
//  Created by Cocos on 2020/2/28.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCSheetTVCell;

NS_ASSUME_NONNULL_BEGIN

extern NSString* const CCSheetFirstFixedCellReuseIdentifier;

@protocol CCSheetTVCellScrollNotifyDelegate <NSObject>

- (void)sheetCell:(CCSheetTVCell *)cell scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state;

@end

/// Cell滚动状态信息提供者, 可以实现该代理, 方便Cell知道当前的ScrollView的初始位置多少
@protocol CCSheetTVCellScrollViewStateSuggesterDelegate <NSObject>

- (CGPoint)suggestContentOffsetForSheetCell:(CCSheetTVCell *)cell;

@end

/// 提供左右滚动内容的
///
/// 默认实现的界面就是左边第一列固定, 第二列开始都可以滚动. 当然用户可以自行设置每一列的宽度(没有设置的列则采用默认宽度)
@interface CCSheetTVCell : UITableViewCell

/// 是否允许通知滚动信息, 默认允许推送
///
/// 默认 NO
@property (nonatomic, assign) BOOL disableScrollNotify;

@property (nonatomic, strong) NSArray *columnHeights;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<CCSheetTVCellScrollNotifyDelegate> notificationDelegate;

@property (nonatomic, weak) id<CCSheetTVCellScrollViewStateSuggesterDelegate> suggesterDelegate;

@end

NS_ASSUME_NONNULL_END
