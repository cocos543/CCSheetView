//
//  CCSheetView.h
//
//
//  Created by Cocos on 2020/2/27.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetTVCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CCSheetView;

/// 提供Cell的横向滚动功能
///
/// 所有sheet cell会根据section分组, 同一个section的sheet cell都属于同个同步组, 横向滚动时会一起滚动.
@protocol CCSheetViewDelegate <NSObject>


/// 告诉视图, 在对应的section里, 某列的宽度. 注意同个section的每一行的同一列宽度是相同的
/// @param sheetView 视图
/// @param col 第几列
/// @param section 那个section
- (CGFloat)sheetView:(CCSheetView *)sheetView widthAtColumnNumber:(NSInteger)col inSection:(NSInteger)section;

@end

/// 见过Excel吗? 既能上下扩展行, 也能左右扩展列
@interface CCSheetView : UITableView <CCSheetTVCellScrollNotifyDelegate>

/// 列宽度 section[@{column, width}]
///
/// 用户可以自行设置每一列的宽度
@property (nonatomic, strong) NSArray<NSMutableDictionary<NSNumber *, NSNumber *> *> *columnWidths;

@end

NS_ASSUME_NONNULL_END
