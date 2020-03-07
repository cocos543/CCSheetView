//
//  CCSheetView.h
//  
//
//  Created by Cocos on 2020/2/27.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetCellComponent.h"
#import "CCSheetHeaderComponent.h"

NS_ASSUME_NONNULL_BEGIN

@class CCSheetView;

/// 提供Cell的横向滚动功能
///
/// 所有sheet cell会根据section分组, 同一个section的sheet cell都属于同个同步组, 横向滚动时会一起滚动.
@protocol CCSheetViewDelegate <UITableViewDelegate>
@required
/// 告诉视图, 在对应的section里, 每一列的宽度是多少. 返回数组的长度代表列数 (注意同个section的每一行的同一列宽度都是相同的)
/// @param sheetView 视图
/// @param section 那个section
- (NSArray<NSNumber *> *)sheetView:(CCSheetView *)sheetView columnsNumberAndWidthsInSection:(NSInteger)section;

@end



/// 见过Excel吗? 既能上下扩展行, 也能左右扩展列
@interface CCSheetView : UITableView <CCSheetTVCellScrollNotifyDelegate, CCSheetTVHeaderScrollNotifyDelegate>

@property (nonatomic, weak, nullable) id <CCSheetViewDelegate> delegate;

/// 系统没有这个复用指定section的Header的方法, 这里新增一个, 当然内部还是调用系统的方法, 只是方便给Header标上所属的section, 方便同步滚动.
- (nullable __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
