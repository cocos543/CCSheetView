//
//  CCFirstColumnFixedSheetCell.h
//
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetCellComponent.h"
#import "CCFirstColumnView.h"
#import "CCFirstColumnFixedContentItem.h"
#import "CCSheetViewTypes.h"

extern CCReuseIdentifierName * _Nonnull const CCFirstColumnFixedSheetCellReuseIdentifier;
@class CCFirstColumnFixedSheetCell;

NS_ASSUME_NONNULL_BEGIN

//typedef void(^CCFirstColumnUISettingBlock)(NSIndexPath *indexPath, CCFirstColumnFixedSheetCell *cell);

/// 首列视图固定, 右侧视图可以左右滚动
@interface CCFirstColumnFixedSheetCell : CCSheetCellComponent

/// 首列视图默认内容是一个图标和一个标题, 可以自行设置替换.
@property (nonatomic, strong) CCFirstColumnView *firstColumnContentView;

@property (nonatomic, strong) NSArray<CCFirstColumnFixedContentItem *> *contentItems;

@end

NS_ASSUME_NONNULL_END
