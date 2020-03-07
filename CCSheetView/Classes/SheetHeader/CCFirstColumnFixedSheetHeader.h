//
//  CCFirstColumnFixedSheetHeader.h
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetHeaderComponent.h"
#import "CCSheetViewHeaderColumnCell.h"

extern CCReuseIdentifierName * _Nonnull const CCFirstColumnFixedSheetHeaderReuseIdentifier;

NS_ASSUME_NONNULL_BEGIN

/// 和CCFirstColumnFixedSheetCell类似, 支持首列固定, 右侧可以滚动
@interface CCFirstColumnFixedSheetHeader : CCSheetHeaderComponent

@property (nonatomic, strong) UILabel *firstColumnTitleLabel;

/// 右边N列数据
///
/// 这里Header只有包括了标题, 所以只需要一个字符串数组即可
@property (nonatomic, strong) NSArray<NSString *> *contentItems;
@end

NS_ASSUME_NONNULL_END
