//
//  CCFirstColumnFixedContentItem.h
// 
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSheetViewTypes.h"
NS_ASSUME_NONNULL_BEGIN

/// 封装了视图的内容项, 很简单.
@interface CCFirstColumnFixedContentItem : NSObject

@property (nonatomic, strong, nullable) UIImage *icon;

@property (nonatomic, strong, nullable) NSAttributedString *title;

@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> *texts;

/// 设置内容项所属的Cell类型
@property (nonatomic, strong) CCReuseIdentifierName *identifier;

@end

NS_ASSUME_NONNULL_END
