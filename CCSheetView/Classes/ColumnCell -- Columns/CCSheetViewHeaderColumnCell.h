//
//  CCSheetViewHeaderColumnCell.h
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSheetViewTypes.h"

extern CCReuseIdentifierName * _Nonnull const CCSheetViewHeaderColumnCellReuseIdentifier;

NS_ASSUME_NONNULL_BEGIN

@interface CCSheetViewHeaderColumnCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
