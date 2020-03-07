//
//  CCSheetHeaderCellComponentContentProtocol.h
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#ifndef CCSheetHeaderCellComponentContentProtocol_h
#define CCSheetHeaderCellComponentContentProtocol_h

/// 所有SheetCellComponent组件和CCSheetHeaderComponent都必须实现该协议, 用来给每一行的列提供数据
@protocol CCSheetHeaderCellComponentContentProtocol <NSObject>

@property (nonatomic, strong) __kindof NSArray *contentItems;

/// 同步横向偏移量时可用该属性
@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<NSNumber *> *columnWidths;

/// 是否允许Cell或者Header发出滚动信号
///
/// 默认 NO
@property (nonatomic, assign) BOOL disableScrollNotify;

/// 接收滚动信息的代理, 一般是TableView
@property (nonatomic, weak) id notificationDelegate;

@end

#endif /* CCSheetHeaderCellComponentContentProtocol_h */
