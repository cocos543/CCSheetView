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

/// 这个类只是为了封装数据
@interface CCFirstColumnFixedContentItem : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier;

@property (nonatomic, strong, nullable) NSArray<NSAttributedString *> *texts;

/// 设置内容项所属的Cell类型
@property (nonatomic, strong) CCReuseIdentifierName *identifier;

@end

NS_ASSUME_NONNULL_END
